function [ lines ] = calcMetricLines(file)
%calcMetricLines given a file, a list of lines of are
%given back, where each line is of the Line class

midlinePoints = file.midlinePoints;
metricPoints = file.metricPoints;
roiOn = file.roiOn;
roiCoords = file.roiCoords;

corAngle = findCorrectionAngle(midlinePoints);

rotMatrix = [cosd(corAngle) -sind(corAngle); sind(corAngle) cosd(corAngle)];
invRotMatrix = [cosd(-corAngle) -sind(-corAngle); sind(-corAngle) cosd(-corAngle)];

% first rotate extrema points into coord system such that midline is
% vertical

pylorusPoint = applyRotationMatrix(metricPoints.pylorusPoint, rotMatrix);
pointA = applyRotationMatrix(metricPoints.pointA, rotMatrix);
pointB = applyRotationMatrix(metricPoints.pointB, rotMatrix);
pointC = applyRotationMatrix(metricPoints.pointC, rotMatrix);
pointD = applyRotationMatrix(metricPoints.pointD, rotMatrix);

rotMidlinePoints = applyRotationMatrix(midlinePoints, rotMatrix);
midlineX = rotMidlinePoints(1,1);

% create the lines
lines = Line.empty(12,0);

%offsets so that labels don't lie directly on lines
vertOffset = -5; %px
horzOffset = +3; %px

% % find lines % %
isBridge = false; %all these are actual measurement lines, not bridge reference lines

% % % % % % % %
% % line  a % %
% % % % % % % %
startPoint = pointD;
endPoint = [pointA(1), pointD(2)];

halfwayPoint = getHalfwayPoint(startPoint, endPoint);
tagPoint = [halfwayPoint(1), halfwayPoint(2) + vertOffset];

[startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords);

tagStringPrefix = 'a = ';
lines(1) = Line(startPoint, endPoint, tagPoint, 'left', isBridge, tagStringPrefix);

% % % % % % % %
% % line  b % %
% % % % % % % %
startPoint = pointA;
endPoint = [pointA(1), pointD(2)];

halfwayPoint = getHalfwayPoint(startPoint, endPoint);
tagPoint = [halfwayPoint(1)-horzOffset, halfwayPoint(2)];

[startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords);

% length should be negative if D is below A
isNeg =  pointD(2) > pointA(2); %remember vertical MATLAB coords are flipped!

tagStringPrefix = 'b = ';
lines(2) = Line(startPoint, endPoint, tagPoint, 'right', isBridge, tagStringPrefix, isNeg);

% % % % % % % %
% % line  c % %
% % % % % % % %
startPoint = pylorusPoint;
endPoint = [pylorusPoint(1), pointD(2)];

halfwayPoint = getHalfwayPoint(startPoint, endPoint);
tagPoint = [halfwayPoint(1)+horzOffset, halfwayPoint(2)];

[startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords);

% length should be negative if D is below pylorus
isNeg = pointD(2) > pylorusPoint(2); %remember vertical MATLAB coords are flipped!

tagStringPrefix = 'c = ';
lines(3) = Line(startPoint, endPoint, tagPoint, 'left', isBridge, tagStringPrefix, isNeg);

% % % % % % % %
% % line  d % %
% % % % % % % %
startPoint = pylorusPoint;
endPoint = [pointD(1), pylorusPoint(2)];

halfwayPoint = getHalfwayPoint(startPoint, endPoint);
tagPoint = [halfwayPoint(1), halfwayPoint(2) + vertOffset];

[startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords);

tagStringPrefix = 'd = ';
lines(4) = Line(startPoint, endPoint, tagPoint, 'left', isBridge, tagStringPrefix);

% % % % % % % %
% % line  e % %
% % % % % % % %
AandBHalfway = getHalfwayPoint(pointA, pointB);

startPoint = [AandBHalfway(1), pointA(2)]; %line is shifted to be halway between A and B horizontally. Gives room for line b if D is below A
endPoint = [AandBHalfway(1), pointC(2)];

tagPoint = [startPoint(1)-horzOffset, startPoint(2)+20]; %can't go halfway, too many lines. Go just a bit from the top. 

[startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords);

tagStringPrefix = 'e = ';
lines(5) = Line(startPoint, endPoint, tagPoint, 'right', isBridge, tagStringPrefix);

% % % % % % % %
% % line  f % %
% % % % % % % %
startPoint = pointB;
endPoint = [midlineX, pointB(2)];

halfwayPoint = getHalfwayPoint(startPoint, endPoint);
tagPoint = [halfwayPoint(1), halfwayPoint(2) + vertOffset];

[startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords);

tagStringPrefix = 'f = ';
lines(6) = Line(startPoint, endPoint, tagPoint, 'left', isBridge, tagStringPrefix);

% % % % % % % %
% % line  g % %
% % % % % % % %
startPoint = [midlineX, pointB(2)];
endPoint = [pointD(1), pointB(2)];

halfwayPoint = getHalfwayPoint(startPoint, endPoint);
tagPoint = [halfwayPoint(1), halfwayPoint(2) + vertOffset];

[startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords);

% length should be negative if D is left (medical right) of midline
isNeg = pointD(1) < midlineX;

tagStringPrefix = 'g = ';
lines(7) = Line(startPoint, endPoint, tagPoint, 'left', isBridge, tagStringPrefix, isNeg);

% % % % % % % %
% % line  h % %
% % % % % % % %
BandCHalfway = getHalfwayPoint(pointB, pointC);

startPoint = [pointB(1), BandCHalfway(2)];
endPoint = [pointD(1), BandCHalfway(2)];

halfwayPoint = getHalfwayPoint(startPoint, endPoint);
tagPoint = [halfwayPoint(1), halfwayPoint(2) + vertOffset];

[startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords);

tagStringPrefix = 'h = ';
lines(8) = Line(startPoint, endPoint, tagPoint, 'left', isBridge, tagStringPrefix);


% % find bridges % %
isBridge = true; %these are just reference lines for the measurment lines, such that their ends are floating in space

% % % % % % % % % % % % % % % %
% % bridge for line e from C% %
% % % % % % % % % % % % % % % %
startPoint = pointC;
endPoint = [AandBHalfway(1), pointC(2)]; %see line e form AandBHalfway

tagPoint = startPoint; %no tag

[startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords);

lines(9) = Line(startPoint, endPoint, tagPoint, 'left', isBridge);

% % % % % % % % % % % % % % %
% % bridge for line d,g,h % %
% % % % % % % % % % % % % % %
yCoords = [pointD(2), pylorusPoint(2), pointB(2), BandCHalfway(2)]; %these points may appear in various orders vertically. We want the bridge to run from the top most to the bottom most points. See line h for BandCHalfway
maxY = max(yCoords);
minY = min(yCoords);

startPoint = [pointD(1), maxY];
endPoint = [pointD(1), minY]; 

tagPoint = startPoint; %no tag

[startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords);

lines(10) = Line(startPoint, endPoint, tagPoint, 'right', isBridge);

% % % % % % % % % % % % %
% % bridge for line h % %
% % % % % % % % % % % % %
startPoint = pointB;
endPoint = [pointB(1), BandCHalfway(2)]; %see line h for BandCHalfway

tagPoint = startPoint; %no tag

[startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords);

lines(11) = Line(startPoint, endPoint, tagPoint, 'right', isBridge);

% % % % % % % % % % % % % % % %
% % bridge for line e from A% %
% % % % % % % % % % % % % % % %
startPoint = [AandBHalfway(1), pointA(2)]; %see line e for AandBHalfway
endPoint = pointA;

tagPoint = startPoint; %no tag

[startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords);

lines(12) = Line(startPoint, endPoint, tagPoint, 'right', isBridge);

end

function [startPoint, endPoint, tagPoint] = transformForDisplay(startPoint, endPoint, tagPoint, invRotMatrix, roiOn, roiCoords)
%transformForDisplay
%rotates make into normal coords and applys ROI transform if needed

points = [startPoint; endPoint; tagPoint];

points = applyRotationMatrix(points, invRotMatrix);

startPoint = points(1,:);
endPoint = points(2,:);
tagPoint = points(3,:);

end
