function [finalTubePoints, numTubes] = pathFinder3( image, waypoints, stepRadius, searchAngle, searchRadius, angularRes)
%path_finder for a given image and starting priors, the algorithm segments
%out a tube structure, displaying the results on the given axes handle

dims = size(image);

imageMax = max(max(image));
imageMin = min(min(image));
imageMiddle = (imageMax + imageMin)/2;

waypointSum = 0;
numWaypoints = height(waypoints);

for i=1:numWaypoints
    waypointSum = waypointSum + interpolate(image, waypoints(i,:));
end

if waypointSum/numWaypoints > imageMiddle %tube is lighter than background
    blackOnWhite = false;
else %tube is darker than background
    blackOnWhite = true;
end

% do feature detection
[~, ~, ~, ft, ~, ~, ~] = phasecong3(image);

% filter out for only tube like features
params = struct('BlackWhite', blackOnWhite,'verbose',false);
[j,~,~] = FrangiFilter2D(ft, params);

% convert to a binary map
jBw = im2bw(j, 0.0003);

% get rid of random little specks of garbage
deblob = bwareaopen(jBw, 3000);

% get rid of an spurs coming off the tube
despur = bwmorph(deblob, 'spur', Inf);

%pre-processing complete
mask = despur;

maxIters = 1000;

% from the first point, find the way to go
firstPoint = [waypoints(1,1), waypoints(1,2)];

vertScanRadius = 2*searchRadius;
horzScanRadius = searchRadius;

ang = 0;

maxEdgeDrop = 0;
maxEdgeDropAng = 0;

while ang < 180
    shift = [0,0]; %no shifting
    angleShift = -firstPoint; %firstPoint is centre of rotation
    scale = 1; %no scaling
    
    transform = getTransform(shift,scale,angleShift,ang);
    
    scanValues = zeros(2*vertScanRadius+1, 2*horzScanRadius+1);
    
    for i=1:2*vertScanRadius+1
        for j=1:2*horzScanRadius+1
            interPoint = [firstPoint(1) + 2*(j-horzScanRadius-1), firstPoint(2) + 2*(i-vertScanRadius-1)];
            
            [x,y] = transformPointsForward(transform, interPoint(1), interPoint(2)); %rotate to be parallel with line
            interPoint = [x,y];
                        
            scanValues(i,j) = interpolate(mask, interPoint);
        end
    end    
    
    rowValues = sum(scanValues,2); %sum across rows
    
    lastUpSum = rowValues(vertScanRadius+1);
    lastDownSum = rowValues(vertScanRadius+1);
        
    localMaxDrop = 0;
    
    for i=1:vertScanRadius
        curUpSum = rowValues(vertScanRadius+1+i);
        curDownSum = rowValues(vertScanRadius+1-i);
        
        upDiff = abs(lastUpSum - curUpSum);
        downDiff = abs(lastDownSum - curDownSum);
        
        localMaxDrop = max([localMaxDrop, upDiff, downDiff]);
        
        lastUpSum = curUpSum;
        lastDownSum = curDownSum;
    end
    
    if localMaxDrop > maxEdgeDrop
        maxEdgeDrop = localMaxDrop;
        maxEdgeDropAng = ang;
    end
   
    ang = ang + 5;
end

delX = stepRadius*cosd(maxEdgeDropAng);
delY = stepRadius*sind(maxEdgeDropAng);

possibleSecondPoints = [firstPoint(1) + delX, firstPoint(2) + delY; firstPoint(1) - delX, firstPoint(2) - delY];

numTubes = 0;

finalTubePoints = [];

for i=1:height(possibleSecondPoints)
    lastPoint = firstPoint;
    curPoint = possibleSecondPoints(i,:);
    
    tubePoints = [lastPoint; curPoint];
    numTubePoints = 2;
    
    curWaypointNum = 2;
    
    while curWaypointNum <= numWaypoints && numTubePoints < maxIters
        
        % search for waypoint
        curWaypoint = waypoints(curWaypointNum,:);
        
        distanceFromWaypoint = norm(curWaypoint - curPoint);
        
        if distanceFromWaypoint <= 2*searchRadius
            point = curWaypoint;
            curWaypointNum = curWaypointNum + 1;
        else
            
            vectorAngle = findVectorAngle(lastPoint, curPoint);
            curValue = interpolate(mask, curPoint);
            
            if curValue < 0.5 %the point is dark, so we assume that tube in the mask is defined by two thin white lines (probably no contrast agent in the tube)
                
                % find left wall
                
                ang = 0;
                streak = 0;
                streakCutoff = 3;
                
                while ang <= searchAngle && streak ~= streakCutoff
                    [x,y] = findXY(curPoint, vectorAngle + ang, searchRadius);
                    
                    if interpolate(mask, [x,y]) > 0.5 % we've hit white
                        streak = streak + 1;
                    else %restart streak
                        streak = 0;
                    end
                    
                    ang = ang + angularRes;
                end
                
                leftWallAngle = ang;
                
                %find right wall
                
                ang = 0;
                streak = 0;
                streakCutoff = 3;
                
                while ang >= -searchAngle && streak ~= streakCutoff
                    [x,y] = findXY(curPoint, vectorAngle + ang, searchRadius);
                    
                    if interpolate(mask, [x,y]) > 0.5 % we've hit white
                        streak = streak + 1;
                    else %restart streak
                        streak = 0;
                    end
                    
                    ang = ang - angularRes;
                end
                
                rightWallAngle = ang;
                
                % use middle between walls as the new place to go
                
                correctionAngle = (leftWallAngle + rightWallAngle) / 2;
                
                
            else %the point is light, so we assume that the tube in the mask is defined by a thick white line (probably contrast agent in the tube)
                % find left wall
                ang = 0;
                streak = 0;
                streakCutoff = 3;
                
                while ang <= searchAngle && streak ~= streakCutoff
                    [x,y] = findXY(curPoint, vectorAngle + ang, searchRadius);
                    
                    if interpolate(mask, [x,y]) < 0.5 % we've hit black
                        streak = streak + 1;
                    else %restart streak
                        %streak = 0;
                    end
                    
                    ang = ang + angularRes;
                end
                
                leftWallAngle = ang;
                
                %find right wall
                
                ang = 0;
                streak = 0;
                streakCutoff = 3;
                
                while ang >= -searchAngle && streak ~= streakCutoff
                    [x,y] = findXY(curPoint, vectorAngle + ang, searchRadius);
                    
                    if interpolate(mask, [x,y]) < 0.5 % we've hit black
                        streak = streak + 1;
                    else %restart streak
                        %streak = 0;
                    end
                    
                    ang = ang - angularRes;
                end
                
                rightWallAngle = ang;
                
                % use middle between walls as the new place to go
                
                correctionAngle = (leftWallAngle + rightWallAngle) / 2;
            end
            
            
            
            [x,y] = findXY(curPoint, vectorAngle + correctionAngle, stepRadius);
            
            point = [x,y];
        end
        
        lastPoint = curPoint;
        curPoint = point;
        
        numTubePoints = numTubePoints + 1;
        tubePoints(numTubePoints,:) = point; % TODO: pre-allocate?!
        
        if (curPoint(1) > dims(2) - (searchRadius + 1)) || (curPoint(1) < (searchRadius + 1) || (curPoint(2) > dims(1) - (searchRadius + 1)) || (curPoint(2) < (searchRadius + 1)))
            break;
        end
    end
    
    if curWaypointNum == numWaypoints+1 %completed successfully
        numTubes = numTubes + 1;
        finalTubePoints = tubePoints;
    end
end

if numTubes ~= 1
    finalTubePoints = [];
end
