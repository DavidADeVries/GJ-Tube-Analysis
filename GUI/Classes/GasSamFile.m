classdef GasSamFile < File
    %file represents an open DICOM file
    
    properties
        roiCoords = [];
        originalLimits
        contrastLimits = [];

        roiOn = false;
        contrastOn = false;
        waypointsOn = false;
        tubeOn = false;
        refOn = false;
        midlineOn = false;
        metricsOn = false;
        quickMeasureOn = false;
        displayUnits = ''; %can be: none, absolute, relative, pixel. '' means units have not yet been used.
        
        waypoints = [];
        tubePoints = [];
        refPoints = [];
        midlinePoints = [];
        metricPoints = MetricPoints.empty;%extrema/metric points are kept in the order [maxL; min; maxR]
        quickMeasurePoints = [];
        
        longitudinalOverlayOn = true; %whether or not it will be included in a longitudinal comparison view
        
    end
    
    methods
        %% Constructor %%
        function gasSamFile = GasSamFile(name, dicomInfo, imagePath, image, originalLimits)
            gasSamFile@File(name, dicomInfo, imagePath, image);
            
            gasSamFile.originalLimits = originalLimits;
        end
        
        %% setWaypoints %%
        % sets points, transforming points in non-ROI coords
        function file = setWaypoints(file, waypoints)
            file.waypoints = waypoints;
        end
        
        %% getWaypoints %%
        % gets points adjusting for ROI being on or not
        function waypoints = getWaypoints(file)
            waypoints = file.waypoints;
        end
        
        %% setTubePoints %%
        % sets points, transforming points in non-ROI coords
        function file = setTubePoints(file, tubePoints)
            file.tubePoints = tubePoints;
        end
        
        %% getTubePoints %%
        % gets points adjusting for ROI being on or not
        function tubePoints = getTubePoints(file)
            tubePoints = file.tubePoints;
        end
                
        %% setRefPoints %%
        % sets points, transforming points in non-ROI coords
        function file = setRefPoints(file, refPoints)
            file.refPoints = refPoints;
        end
        
        %% getRefPoints %%
        % gets points adjusting for ROI being on or not
        function refPoints = getRefPoints(file)
            refPoints = file.refPoints;
        end
        
        %% setMidlinePoints %%
        % sets points, transforming points in non-ROI coords
        function file = setMidlinePoints(file, midlinePoints)
            file.midlinePoints = midlinePoints;
        end
        
        %% getMidlinePoints %%
        % gets points adjusting for ROI being on or not
        function midlinePoints = getMidlinePoints(file)
            midlinePoints = file.midlinePoints;
        end
                
        %% setQuickMeasurePoints %%
        % sets points, transforming points in non-ROI coords
        function file = setQuickMeasurePoints(file, quickMeasurePoints)
            file.quickMeasurePoints = quickMeasurePoints;
        end
        
        %% getQuickMeasurePoints %%
        % gets points adjusting for ROI being on or not
        function quickMeasurePoints = getQuickMeasurePoints(file)
            quickMeasurePoints = file.quickMeasurePoints;
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
            numPoints = floor(height(initSplinePoints)/res) + 1; %plus one to make room for the first point
            
            numSplinePoints = height(initSplinePoints);
                        
            localTubePoints = zeros(numPoints, 2);
            
            localTubePoints(1,:) = initSplinePoints(1,:); % for sure include first point
            
            for i=1:numSplinePoints
                if mod(i,res) == 0
                    localTubePoints((i/res) + 1, :) = initSplinePoints(i, :);
                end
            end
            
            if mod(numSplinePoints, res) ~= 0 %add in last point if it's not already included
                localTubePoints(numPoints + 1, :) = initSplinePoints(numSplinePoints, :);
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
        function [ cLim ] = getCurrentLimits(file)
            %getCurrentLimits returns cLims dependent on whether contrast is set or not
            
            if file.contrastOn
                cLim = file.contrastLimits;
            else
                cLim = file.originalLimits;
            end
            
        end
                
        %% getAdjustedImage %%
        % applies contrast limits to actual image values
        function [ adjImage ] = getAdjustedImage(file, image)
            %getAdjustedImage returns image matrix with contrast applied, if required
                        
            if file.roiOn
                adjImage = imcrop(image, file.roiCoords);
            else
                adjImage = image;
            end
            
            if file.contrastOn
                dims = size(adjImage);
                
                contrastLim = file.contrastLimits;
                
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
        
        %% isValidForExport %%
        % ** required for GIANT **
        function isValid = isValidForExport(file)
            isValid = ~(isempty(file.metricPoints) || isempty(file.refPoints) || isempty(file.midlinePoints));
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
                localMetricPoints.pylorusPoint = metricPointCoords(1,:);
                localMetricPoints.pointA = metricPointCoords(2,:);
                localMetricPoints.pointB = metricPointCoords(3,:);
                localMetricPoints.pointC = metricPointCoords(4,:);
                localMetricPoints.pointD = metricPointCoords(5,:);
                
                file.metricPoints = localMetricPoints;
            end
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
                roundedMetrics = round(10 .* tubeMetrics) ./ 10;
                
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
                
                rescalingFactor = 10000; %to eliminate small decimal values
                                
                tubeMetrics(1) = pylorusToCCurvatureMean * rescalingFactor;
                tubeMetrics(2) = AToCCurvatureMean * rescalingFactor;
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
