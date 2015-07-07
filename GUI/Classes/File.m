classdef File
    %file represents an open DICOM file
    
    properties
        dicomInfo
        name = '';
        image
        roiCoords = [];
        originalLimits
        contrastLimits = [];
        date % I know dicomInfo would hold this, but to have it lin an easily compared form is nice

        roiOn = false;
        contrastOn = false;
        waypointsOn = false;
        tubeOn = false;
        refOn = false;
        midlineOn = false;
        metricsOn = false;
        quickMeasureOn = false;
        displayUnits = ''; %can be: none, absolute, relative, pixel
        
        waypoints = [];
        tubePoints = [];
        refPoints = [];
        midlinePoints = [];
        metricPoints = MetricPoints.empty;%extrema/metric points are kept in the order [maxL; min; maxR]
        quickMeasurePoints = [];
        
        longitudinalOverlayOn = true; %whether or not it will be included in a longitudinal comparison view
        
        undoCache = UndoCache.empty;
    end
    
    methods
        %% Constructor %%
        function file = File(name, dicomInfo, dicomImage, originalLimits)
            file.name = name;
            file.dicomInfo = dicomInfo;
            file.image = dicomImage;
            file.originalLimits = originalLimits;
            file.date = Date(dicomInfo.StudyDate);
            
            file.undoCache = UndoCache(file);
        end
        
        %% setWaypoints %%
        % sets points, transforming points in non-ROI coords
        function file = setWaypoints(file, waypoints)
            file.waypoints = confirmNonRoi(waypoints, file.roiOn, file.roiCoords);
        end
        
        %% getWaypoints %%
        % gets points adjusting for ROI being on or not
        function waypoints = getWaypoints(file)
            waypoints = confirmMatchRoi(file.waypoints, file.roiOn, file.roiCoords);
        end
        
        %% setTubePoints %%
        % sets points, transforming points in non-ROI coords
        function file = setTubePoints(file, tubePoints)
            file.tubePoints = confirmNonRoi(tubePoints, file.roiOn, file.roiCoords);
        end
        
        %% getTubePoints %%
        % gets points adjusting for ROI being on or not
        function tubePoints = getTubePoints(file)
            tubePoints = confirmMatchRoi(file.tubePoints, file.roiOn, file.roiCoords);
        end
                
        %% setRefPoints %%
        % sets points, transforming points in non-ROI coords
        function file = setRefPoints(file, refPoints)
            file.refPoints = confirmNonRoi(refPoints, file.roiOn, file.roiCoords);
        end
        
        %% getRefPoints %%
        % gets points adjusting for ROI being on or not
        function refPoints = getRefPoints(file)
            refPoints = confirmMatchRoi(file.refPoints, file.roiOn, file.roiCoords);
        end
        
        %% setMidlinePoints %%
        % sets points, transforming points in non-ROI coords
        function file = setMidlinePoints(file, midlinePoints)
            file.midlinePoints = confirmNonRoi(midlinePoints, file.roiOn, file.roiCoords);
        end
        
        %% getMidlinePoints %%
        % gets points adjusting for ROI being on or not
        function midlinePoints = getMidlinePoints(file)
            midlinePoints = confirmMatchRoi(file.midlinePoints, file.roiOn, file.roiCoords);
        end
                
        %% setQuickMeasurePoints %%
        % sets points, transforming points in non-ROI coords
        function file = setQuickMeasurePoints(file, quickMeasurePoints)
            file.quickMeasurePoints = confirmNonRoi(quickMeasurePoints, file.roiOn, file.roiCoords);
        end
        
        %% getQuickMeasurePoints %%
        % gets points adjusting for ROI being on or not
        function quickMeasurePoints = getQuickMeasurePoints(file)
            quickMeasurePoints = confirmMatchRoi(file.quickMeasurePoints, file.roiOn, file.roiCoords);
        end
        
        %% getDisplayTubePoints %%
        function displayTubePoints = getDisplayTubePoints(file)
            %returns not just the tube points, but points from a spline
            %joining the tube points, so that a smooth curve can be plotted
            localTubePoints = file.getTubePoints();
            
            if ~isempty(localTubePoints)
                displayTubePoints = getSplinePoints(localTubePoints);
            else
                displayTubePoints = [];
            end
        end
        
        %% getSeriesDescription %%
        function description = getSeriesDescription(file)
            header = file.dicomInfo;
            
            if isfield(header, 'SeriesDescription')
                description = header.SeriesDescription;
            else
                description = 'No Description Found';
            end
        end
        
        %% getStudyDescription %%
        function description = getStudyDescription(file)
            header = file.dicomInfo;
            
            if isfield(header, 'StudyDescription')
                description = header.StudyDescription;
            else
                description = 'No Description Found';
            end
        end
        
        %% setTubePointsFromRaw %%
        function file = setTubePointsFromRaw(file, rawTubePoints)
            % STEP 1: make spline from all points. This is NOT the spline displayed
            spline = cscvn([rawTubePoints(:,1)';rawTubePoints(:,2)']); %spline store as a function
            initSplinePoints = fnplt(spline)'; %returns points doesn't actually display them
            
            % STEP 2: from this initial spline, find the spacing of all the points
            % plotted for it (not actually displayed)
            norms = zeros(height(initSplinePoints)-1,1);
            
            for i=1:height(initSplinePoints)-1
                norms(i) = norm(initSplinePoints(i,:)-initSplinePoints(i+1,:));
            end
            
            % STEP 3: find the average spacing of these points and get a resolution so
            % that the specified TUBE_POINT_RESOLUTION will reflect a roi point every
            % "TUBE_POINT_RESOLUTION pixels" e.g. a tube point every 15 pxs
            averSpacing = mean(norms);
            
            res = round(Constants.TUBE_POINT_RESOLUTION/averSpacing);
            
            % STEP 4: Get the tube points based upon this resolution from the initial
            % spline            
            numPoints = floor(height(initSplinePoints)/res);
            
            localTubePoints = zeros(numPoints, 2);
            
            for i=1:height(initSplinePoints)
                if mod(i,res) == 0
                    localTubePoints(i/res,:) = initSplinePoints(i,:);
                end
            end
            
            file = file.setTubePoints(localTubePoints);
        end
        
        %% chooseDisplayUnits %%
        % sets the file's displayUnits field if not yet set
        function file = chooseDisplayUnits(file)
            if isempty(file.displayUnits) %only change if not yet defined
                % putting it in the reference units is preferred, but if not, pixels it is, boys, pixels it is
                if isempty(file.refPoints)
                    file.displayUnits = 'pixel';
                else
                    file.displayUnits = 'relative';
                end
            end
        end
        
        %% getUnitConversion %%
        %returns the unitString (px, mm, etc.) and the unitConversion
        %factor, in the form [xScalingFactor, yScalingFactor]
        %to convert take value in px and multiply by scaling factor
        function [ unitString, unitConversion ] = getUnitConversion(file)
            %getUnitConversions gives back a string for display purposes, as well as a
            %coefficient such that pixelMeaurement*coeff = measurementInUnits
            
            switch file.displayUnits
                case 'none'
                    unitString = '';
                    unitConversion = [];
                case 'relative'
                    unitString = 'u';
                    conversionFactor = 1 / norm(file.refPoints(1,:) - file.refPoints(2,:));
                    
                    unitConversion = [conversionFactor, conversionFactor];
                case 'absolute'
                    unitString = 'mm';
                    
                    sourceToDetector = file.dicomInfo.DistanceSourceToDetector;
                    sourceToPatient = file.dicomInfo.DistanceSourceToPatient;
                    
                    magFactor = sourceToDetector / sourceToPatient;
                    
                    pixelSpacing = file.dicomInfo.ImagerPixelSpacing;
                    
                    unitConversion = pixelSpacing / magFactor; %NOTE: THIS CAN ONLY BE A ROUGH ESTIMATE DUE TO THE PROPERITIES OF PROJECTION IMAGING!!!
                case 'pixel'
                    unitString = 'px';
                    unitConversion = [1,1]; %everything is stored in px measurements,so no conversion neeeded.
            end
        end
        
        %% getCurrentLimits %%
        % returns the current contrast limits
        function [ cLim ] = getCurrentLimits(obj)
            %getCurrentLimits returns cLims dependent on whether contrast is set or not
            
            if obj.contrastOn
                cLim = obj.contrastLimits;
            else
                cLim = obj.originalLimits;
            end
            
        end
        
        %% getCurrentImage %%
        % returns cropped imaged or not
        function [ image ] = getCurrentImage(obj)
            %getCurrentImage returns the current image for the file (entire or ROI)
            
            if obj.roiOn
                image = imcrop(obj.image, obj.roiCoords);
            else
                image = obj.image;
            end           
        end
        
        %% getAdjustedImage %%
        % applies contrast limits to actual image values
        function [ adjImage ] = getAdjustedImage(obj)
            %getAdjustedImage returns image matrix with contrast applied, if required
            
            adjImage = getCurrentImage(obj);
            
            if obj.contrastOn
                dims = size(adjImage);
                
                contrastLim = obj.contrastLimits;
                
                for i=1:dims(1)
                    for j=1:dims(2)
                        if adjImage(i,j) < contrastLim(1) %basic contrast implementation (no gamma)
                            adjImage(i,j) = contrastLim(1);
                        elseif adjImage(i,j) > contrastLim(2)
                            adjImage(i,j) = contrastLim(2);
                        end
                    end
                end
            end
            
        end
        
        %% isValidForLongitudinal %%
        function [isValid] = isValidForLongitudinal(file)
            %returns if the file is valid to be used in a longitudinal
            %comparison (must have certain points set)
            
            hasTube = ~isempty(file.tubePoints);
            hasReference = ~isempty(file.refPoints);
            hasMetricPoints = ~isempty(file.metricPoints);
            
            isValid = hasTube && hasReference && hasMetricPoints;
        end
        
        %% updateMetricPoints %%
        function file = updateMetricPoints(file, metricPointCoords)
            localMetricPoints = file.metricPoints;
            
            if height(metricPointCoords) == localMetricPoints.getNumPoints()
                metricPointCoords = confirmNonRoi(metricPointCoords, file.roiOn, file.roiCoords);
                
                localMetricPoints.pylorusPoint = metricPointCoords(1,:);
                localMetricPoints.pointA = metricPointCoords(2,:);
                localMetricPoints.pointB = metricPointCoords(3,:);
                localMetricPoints.pointC = metricPointCoords(4,:);
                localMetricPoints.pointD = metricPointCoords(5,:);
                
                file.metricPoints = localMetricPoints;
            end
        end
                
        %% updateUndoCache %%
        % saves the file at current into its own undo cache
        function [ file ] = updateUndoCache( file )
            %updateUndoCache takes whatever is in the currentFile that could be changed
            %and caches it
            
            cache = file.undoCache;
            
            oldCacheEntries = cache.cacheEntries;
            
            newCacheSize = cache.numCacheEntries()  - cache.cacheLocation + 2;
            
            maxCacheSize = cache.cacheSize;
            
            if newCacheSize > maxCacheSize
                newCacheSize = maxCacheSize;
            end
            
            newCacheEntries = CacheEntry.empty(newCacheSize,0);
            
            newCacheEntries(1) = CacheEntry(file); %most recent is now the current state (all previous redo options eliminated)
            
            %bring in all entries that are still in the "past". Any before
            %cacheLocation are technically in a "future" that since a change has been
            %made, it would be inconsistent for this "future" to be reachable, and so
            %the entries are removed.
            
            for i=2:newCacheSize
                newCacheEntries(i) = oldCacheEntries(cache.cacheLocation + i - 2);
            end
            
            cache.cacheEntries = newCacheEntries;
            cache.cacheLocation = 1;
            
            file.undoCache = cache;            
        end
        
        
        %% performUndo %%
        function [ file ] = performUndo( file )
            %performUndo actually what it says on the tin
            
            cacheLocation = file.undoCache.cacheLocation;
            
            numCacheEntries = length(file.undoCache.cacheEntries);
            
            cacheLocation = cacheLocation + 1; %go back in time
            
            if cacheLocation > numCacheEntries
                cacheLocation = numCacheEntries;
            end
            
            if cacheLocation > file.undoCache.cacheSize
                cacheLocation = file.undoCache.cacheSize;
            end
            
            file.undoCache.cacheLocation = cacheLocation;
            
            cacheEntry = file.undoCache.cacheEntries(cacheLocation);
            
            file = cacheEntry.restoreToFile(file);           
        end
        
        %% performRedo %%
        function [ file ] = performRedo( file )
            %performUndo actually what it says on the tin
                        
            cacheLocation = file.undoCache.cacheLocation;
            
            cacheLocation = cacheLocation - 1; %go forward in time
            
            if  cacheLocation == 0
                cacheLocation = 1;
            end
            
            file.undoCache.cacheLocation = cacheLocation;
            
            cacheEntry = file.undoCache.cacheEntries(cacheLocation);
            
            file = cacheEntry.restoreToFile(file); 
        end
        
        %% getMeasurements %%
        function [measurements] = getMeasurements(file)
            %returns the measurements needed to be outputted for analysis
            %results stored in struct
            metricLines = calcMetricLines(file);
            tubeMetrics = calcTubeMetrics(file);
            
            file.displayUnits = 'relative'; %NOTE: these changes to the file are not getting pushed back
            
            [~, unitConversion] = file.getUnitConversion();
                                   
            a = metricLines(1).getLength(unitConversion);
            b = metricLines(2).getLength(unitConversion);
            c = metricLines(3).getLength(unitConversion);
            d = metricLines(4).getLength(unitConversion);
            e = metricLines(5).getLength(unitConversion);
            f = metricLines(6).getLength(unitConversion);
            g = metricLines(7).getLength(unitConversion);
            h = metricLines(8).getLength(unitConversion);
            
            if isempty(tubeMetrics)
                i = 0;
                j = 0;
            else
                i = tubeMetrics(1);
                j = tubeMetrics(2);
            end
            
            measurements = struct('a',a,'b',b,'c',c,'d',d,'e',e,'f',f,'g',g,'h',h,'i',i,'j',j);
        end
        
        %% getTubeMetricStrings %%
        function [tubeMetricStrings] = getTubeMetricStrings(file)            
            tubeMetrics = file.calcTubeMetrics();
                     
            numTubeMetrics = length(tubeMetrics);            
            tubeMetricStrings = cell(numTubeMetrics);
            
            if numTubeMetrics == 0
                tubeMetricStrings = {'',''}; %tubepoints must not be defined
            else
                roundedMetrics = round(10000 .* tubeMetrics) ./ 10000;
                
                tubeMetricStrings{1} = ['Average Curvature from Pylorus to Point C, i = ', num2str(roundedMetrics(1))];
                tubeMetricStrings{2} = ['Average Curvature from Point A to Point C, j = ', num2str(roundedMetrics(2))];
            end
            
        end
        
        %% calcTubeMetrics %%
        % calculates the "tightness" of the tube from pylorus to C and A to
        % C using derivatives
        function [tubeMetrics] = calcTubeMetrics(file)
            localMetricPoints = file.metricPoints;
               
            if isempty(file.tubePoints())
                tubeMetrics = [];
            else
                localTubePoints = getSplinePoints(file.tubePoints()); %don't want any ROI business
                spline = getSpline(file.tubePoints());
                
                splineFirstDeriv = fnder(spline, 1);
                firstDerivPoints = fnplt(splineFirstDeriv)';
                
                splineSecondDeriv = fnder(spline, 2);
                secondDerivPoints = fnplt(splineSecondDeriv)';
                
                pylorusTubePointNum = getClosestTubePointNum(localMetricPoints.pylorusPoint, localTubePoints);
                pointATubePointNum = getClosestTubePointNum(localMetricPoints.pointA, localTubePoints);
                pointCTubePointNum = getClosestTubePointNum(localMetricPoints.pointC, localTubePoints);
                
                range = pylorusTubePointNum:pointCTubePointNum;
                pylorusToCFirstDerivPoints = firstDerivPoints(range,:);
                pylorusToCSecondDerivPoints = secondDerivPoints(range,:);
                                
                range = pointATubePointNum:pointCTubePointNum;
                AToCFirstDerivPoints = firstDerivPoints(range,:);
                AToCSecondDerivPoints = secondDerivPoints(range,:);
                
                %take norm of each deriv points.
                %these derivative are 2D because the spline is parametric,
                %not a function
                pylorusToCCurvatures = zeros(length(pylorusToCFirstDerivPoints), 1);
                
                for i=1:length(pylorusToCFirstDerivPoints)
                    pylorusToCCurvatures(i) = norm(pylorusToCSecondDerivPoints(i,:)) / ((1 + ((norm(pylorusToCFirstDerivPoints(i,:))) .^ 2)).^(1.5));
                end
                
                AToCCurvatures = zeros(length(AToCFirstDerivPoints), 1);
                
                for i=1:length(AToCFirstDerivPoints)
                    AToCCurvatures(i) = norm(AToCSecondDerivPoints(i,:)) / ((1 + ((norm(AToCFirstDerivPoints(i,:))) .^ 2)).^(1.5));
                end
                
                %take average of the norm of the derivatives
                pylorusToCCurvatureMean = mean(pylorusToCCurvatures);
                AToCCurvatureMean = mean(AToCCurvatures);                
                                
                tubeMetrics(1) = pylorusToCCurvatureMean;
                tubeMetrics(2) = AToCCurvatureMean;
            end
        end

    end
    
end

function splinePoints = getSplinePoints(tubePoints)
spline = getSpline(tubePoints);

splinePoints = fnplt(spline)';

end

function spline = getSpline(points)
x = points(:,1)';
y = points(:,2)';

% get all the points needed to plot by fitting a spline to the tube points
% and sampling a series of points from it with fnplt
spline = cscvn([x;y]); %spline stored as a function

end
