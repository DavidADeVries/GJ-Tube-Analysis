function [ metricPoints, handles ] = findMetricsPoints( currentFile, handles, hObject )
%findMetricsPoints takes tubePoints (that have been corrected by rotating
%such that midline is vertical) and then extracts two maximums and a
%minimum

tubePoints = currentFile.getDisplayTubePoints();

pointA = []; %first max after pylorus (will be a min due matlab coords)
pointB = []; %horizontal "min"
pointC = []; %minimum (will be a max due to matlab coords)
pointD = []; %second max (will be min due to matlab coords

extremaRadius = 5; %how many points on each side will be examined to find extrema

cancelled = false;

metricPoints = MetricPoints.empty();

if ~isempty(tubePoints)
    midlinePoints = currentFile.getMidlinePoints();

    corAngle = findCorrectionAngle(midlinePoints);

    rotMatrix = [cosd(corAngle) -sind(corAngle); sind(corAngle) cosd(corAngle)];
    
    %rotate tube points into coord system where midline is vertical
    rotTubePoints = applyRotationMatrix(tubePoints, rotMatrix);
    
    corMidlinePoints = applyRotationMatrix(midlinePoints, rotMatrix);
    
    % used for finding point D (max relative to 45deg tilted axis)
    rotMatrix45 = [cosd(corAngle-45) -sind(corAngle-45); sind(corAngle-45) cosd(corAngle-45)];
    
    %rotate tube points for this coord system where 45 clockwise from
    %midline is vertical
    tubePoints45 = applyRotationMatrix(tubePoints, rotMatrix45);
    
    % keep track of maximum vertical value left (medical right) of midline
    % done so that in case point C isn't found, it is set to be the to be this
    % point
    
    maxVerticalValue = -Inf; %vertical coords are flipped in matlab
    maxVerticalIndex = 0;
        
    for i=1+extremaRadius:length(tubePoints)-extremaRadius        
        prePoints = zeros(extremaRadius, 2);
        postPoints = zeros(extremaRadius, 2);
        
        for j=1:extremaRadius
            prePoints(j,:) = rotTubePoints(i-j,:);
            postPoints(j,:) = rotTubePoints(i+j,:);
        end
        
        pointX = rotTubePoints(i,1) .* ones(extremaRadius,1);
        pointY = rotTubePoints(i,2) .* ones(extremaRadius,1);
        
        preXDiff = mean(pointX - prePoints(:,1));
        preYDiff = mean(pointY - prePoints(:,2));
        
        postXDiff = mean(pointX - postPoints(:,1));
        postYDiff = mean(pointY - postPoints(:,2));
        
        %look for vertical max in matlab coords (point C)
        if preYDiff > 0 && postYDiff > 0 && isempty(pointC) && ~isempty(pointB)
            pointC = confirmNonRoi(tubePoints(i,:), currentFile.roiOn, currentFile.roiCoords);
        end
        
        %if max not found for point C, assign it to be vertical max (matlab
        %coords) for left of the midline (medically right of midline)
        currentLeftOfMidline = rotTubePoints(i,1) < corMidlinePoints(1,1);
        
        if isempty(pointC) && currentLeftOfMidline && ~isempty(pointB)
            % update max if needed
            if rotTubePoints(i,2) > maxVerticalValue
                maxVerticalValue = rotTubePoints(i,2);
                maxVerticalIndex = i;
            end
            
            % assign point C if we're crossing from left of midline to
            % right of midline
            nextRightOfMidline = rotTubePoints(i+1,1) >= corMidlinePoints(1,1);
        
            if nextRightOfMidline
                pointC = confirmNonRoi(tubePoints(maxVerticalIndex,:), currentFile.roiOn, currentFile.roiCoords);
            end
        end  
        
        %look for vertical min in matlab coords (point A)
        %checks if still in point A territory (e.g. B and C not found)
        if isempty(pointB) && isempty(pointC) && preYDiff < 0 && postYDiff < 0
            pointA = confirmNonRoi(tubePoints(i,:), currentFile.roiOn, currentFile.roiCoords);
        end
        
        %look for hoizontal min in matlab coords (point B)
        if preXDiff < 0 && postXDiff < 0
            pointB = confirmNonRoi(tubePoints(i,:), currentFile.roiOn, currentFile.roiCoords);
        end
        
        % look in 45deg rotated axes for point D
        
        prePoints45 = zeros(extremaRadius, 2);
        postPoints45 = zeros(extremaRadius, 2);
        
        for j=1:extremaRadius
            prePoints45(j,:) = tubePoints45(i-j,:);
            postPoints45(j,:) = tubePoints45(i+j,:);
        end
        
        pointY45 = tubePoints45(i,2) .* ones(extremaRadius,1);
        
        preYDiff45 = mean(pointY45 - prePoints45(:,2));
        
        postYDiff45 = mean(pointY45 - postPoints45(:,2));
        
        % only look for D after at least one of the other points is defined
        if (~isempty(pointA) || ~isempty(pointB) || ~isempty(pointC)) && preYDiff45 < 0 && postYDiff45 > 0
            pointD = confirmNonRoi(tubePoints(i,:), currentFile.roiOn, currentFile.roiCoords);
        end
        
    end
else
    cancelled = manualMetricPointWarningDialog();
end

if ~cancelled
    % manually select pylorus
    
    message = 'Please select the pylorus. The pylorus cannot be automatically defined.';
    
    point = manualPointSelection(message);
    
    pylorus = confirmNonRoi(point, currentFile.roiOn, currentFile.roiCoords);
    
    metricPoints = MetricPoints(pylorus, pointA, pointB, pointC, pointD);
    
    currentFile.metricPoints = metricPoints;
    currentFile.metricsOn = true;
    
    % delete what was there previously
    handles = deleteMetricLines(handles);
    handles = deleteMetricPoints(handles);
    
    % temporarily draw what points we have
    toggled = false;
    labelsOn = false;
    
    handles = drawMetricPointsWithCallback(currentFile, handles, hObject, toggled, labelsOn);
    
    % now make sure none of the points A - D are missing
    points = {pointA, pointB, pointC, pointD};
    labels = {'Point A', 'Point B', 'Point C', 'Point D'};
    descriptors = {...
        'Point A is the first vertical maximum after the pylorus.',...
        'Point B is the leftmost point after the pylorus',...
        'Point C is the vertical minimum to the left of the midline.',...
        'Point D is the maximum with respect to an axis tilted by 45 degrees. It is the most upper and right point after Point C.'};
    
    for i=1:length(points)
        if isempty(points{i})
            line1 = char(strcat(labels{i}, {' '}, 'was not automatically found. Please manually select.'));
            line2 = char(descriptors{i});
            
            point = manualPointSelection({line1; line2});
            point = confirmNonRoi(point, currentFile.roiOn, currentFile.roiCoords);
            points{i} = point;
            
            handles = deleteMetricPoints(handles);
            
            metricPoints = MetricPoints(pylorus, points{1}, points{2}, points{3}, points{4});
            currentFile.metricPoints = metricPoints;
            
            % temporarily draw what points we have
            toggled = false;
            handles = drawMetricPointsWithCallback(currentFile, handles, hObject, toggled, labelsOn);
        end
    end
    
    % delete what was temporarily drawn
    
    handles = deleteMetricPoints(handles);
    
end
    
end

function point = manualPointSelection(message)
    title = 'Select Point';
    icon = 'warn';
    waitfor(msgbox(message,title,icon));
    
    point = ginput(1);
end


