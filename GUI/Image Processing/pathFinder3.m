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

maxIters = 10*2*((dims(1)+dims(2))/searchRadius); %max number of iterations: around the perimeter of the image 10x

% from the first point, find the way to go
firstPoint = [waypoints(1,1), waypoints(1,2)];

%DEBUG
% figure(1);
% imshow(mask,[]);
% hold on;

% used by "findTubeOrientation", sets how far to look for the tube edges
vertScanRadius = 2*searchRadius;
horzScanRadius = searchRadius;

% describes the angle of the tube
tubeAngle = findTubeOrientation(mask, firstPoint, vertScanRadius, horzScanRadius);

delX = stepRadius*cosd(tubeAngle);
delY = stepRadius*sind(tubeAngle);

% tube may extend in two directions from the first point
possibleSecondPoints = [firstPoint(1) + delX, firstPoint(2) + delY; firstPoint(1) - delX, firstPoint(2) - delY];

numTubes = 0;

finalTubePoints = [];

% try all possible directions from first point
for i=1:height(possibleSecondPoints)
    lastPoint = firstPoint;
    curPoint = possibleSecondPoints(i,:);
    
    tubePoints = [lastPoint; curPoint];
    numTubePoints = 2;
    
    curWaypointNum = 2;
    
    waypointUsed = false;
    
    while curWaypointNum <= numWaypoints && numTubePoints < maxIters
        % search for waypoint
        curWaypoint = waypoints(curWaypointNum,:);
        
        distanceFromWaypoint = norm(curWaypoint - curPoint);
        
        % if next waypoint is within reach, use it
        if distanceFromWaypoint <= 2*searchRadius
            point = curWaypoint;
            curWaypointNum = curWaypointNum + 1;
            waypointUsed = true;
        else
            vectorAngle = findVectorAngle(lastPoint, curPoint);
            
            % if the curPoint is a waypoint, the vectorAngle (angle for
            % lastPoint to curPoint) may point at crazy angle. So we
            % findTubeOrientation to get the vectorAngle correct
            if waypointUsed
                % two angles (since tube extends in 2 directions)
                tubeAngle1 = findTubeOrientation(mask, curPoint, vertScanRadius, horzScanRadius);
                tubeAngle2 = mod((tubeAngle1 + 180), 360);
                
                diff1 = abs(tubeAngle1 - vectorAngle);
                diff2 = abs(tubeAngle2 - vectorAngle);
                
                % choose the tubeAngle closest to the vector angle (aka
                % don't go backwards
                if diff1 <= diff2
                    vectorAngle = tubeAngle1;
                else
                    vectorAngle = tubeAngle2;
                end
                
                waypointUsed = false;
            end
            
            curValue = interpolate(mask, curPoint);
            
            if curValue < 0.5 %the point is dark, so we assume that tube in the mask is defined by two thin white lines (probably no contrast agent in the tube)
                restartOn = true;
                hitFunction = @hitWhite;
            else %the point is light, so we assume that the tube in the mask is defined by a thick white line (probably contrast agent in the tube)
                restartOn = false;
                hitFunction = @hitBlack;
            end
            
            % find left wall
            
            leftWallAngle = findTubeWallAngle(mask, curPoint, vectorAngle, searchRadius, angularRes, searchAngle, hitFunction, restartOn);
            
            %find right wall
            
            rightWallAngle = findTubeWallAngle(mask, curPoint, vectorAngle, searchRadius, -angularRes, searchAngle, hitFunction, restartOn); %negative angular resolution to look other way
                        
            % use middle between walls as the new place to go
            
            correctionAngle = (leftWallAngle + rightWallAngle) / 2;
            
            
            [x,y] = findXY(curPoint, vectorAngle + correctionAngle, stepRadius);
            
            point = [x,y];
        end
        
        % update points and add new point to the list of tubePoints
        lastPoint = curPoint;
        curPoint = point;
        
        numTubePoints = numTubePoints + 1;
        tubePoints(numTubePoints,:) = point; % TODO: pre-allocate?!
        
        % DEBUG
        % plot(point(1),point(2),'x');
        
        if (curPoint(1) > dims(2) - (searchRadius + 1)) || (curPoint(1) < (searchRadius + 1) || (curPoint(2) > dims(1) - (searchRadius + 1)) || (curPoint(2) < (searchRadius + 1)))
            break;
        end
    end
    
    if curWaypointNum == numWaypoints+1 %completed successfully
        numTubes = numTubes + 1; %update number of possible tubes
        finalTubePoints = tubePoints; 
    end
end

% only interest in having a single tube, so empty finalTubePoints if more
% than 1 is found
if numTubes ~= 1
    finalTubePoints = [];
end

end




% functions for determining whether a wall has been hit or not.
% need two depending on the image type.
% Different image types can produce either a mask with a single white tube,
% or two white lines describing the walls of the tube
function hit = hitWhite(val)
    hit = (val > 0.5);
end

function hit = hitBlack(val)
    hit = (val < 0.5);
end

% this function finds the angle from the current vectorAngle to the left or
% right wall (angularRes > 0 -> left, angularRes < 0 -> right)
function wallAngle = findTubeWallAngle(mask, curPoint, vectorAngle, searchRadius, angularRes, searchAngle, hitFunction, restartOn)
    
    wallAngle = 0;
    streak = 0;
    streakCutoff = 2;
    
    while abs(wallAngle) <= searchAngle && streak ~= streakCutoff
        [x,y] = findXY(curPoint, vectorAngle + wallAngle, searchRadius);
        
        if hitFunction(interpolate(mask, [x,y]))
            streak = streak + 1;
        elseif restartOn
            streak = 0;
        end
        
        wallAngle = wallAngle + angularRes;
    end
end

% this function takes a single point within the tube, and find at what
% angle the tube is at (horizontal, vertical, or somewhere inbetween)
function tubeAngle = findTubeOrientation(mask, point, vertScanRadius, horzScanRadius)

    angle = 0;

    maxEdgeDrop = 0;
    maxEdgeDropAng = 0;  
    
    angularRes = 5;

    while angle < 180
        shift = [0,0]; %no shifting
        angleShift = -point; %firstPoint is centre of rotation
        scale = 1; %no scaling

        transform = getTransform(shift, scale, angleShift, angle);

        scanValues = zeros(2*vertScanRadius+1, 2*horzScanRadius+1);

        for i=1:2*vertScanRadius+1
            for j=1:2*horzScanRadius+1
                interPoint = [point(1) + 2*(j-horzScanRadius-1), point(2) + 2*(i-vertScanRadius-1)];

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
            maxEdgeDropAng = angle;
        end

        angle = angle + angularRes;
    end
    
    tubeAngle = maxEdgeDropAng;
end
