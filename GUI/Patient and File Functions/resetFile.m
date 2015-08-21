function file = resetFile(file)
% file = resetFile(file)
%   Detailed explanation goes here
%
% ** REQUIRED BY GIANT **
%
% this functions removes any changes done to a file, so that it is as if
% the file was deleted and then added to the patient again

file.roiCoords = [];
%file.originalLimits; don't touch those!
file.contrastLimits = [];

file.roiOn = false;
file.contrastOn = false;
file.waypointsOn = false;
file.tubeOn = false;
file.refOn = false;
file.midlineOn = false;
file.metricsOn = false;
file.quickMeasureOn = false;
file.displayUnits = '';
        
file.waypoints = [];
file.tubePoints = [];
file.refPoints = [];
file.midlinePoints = [];
file.metricPoints = MetricPoints.empty;
file.quickMeasurePoints = [];
        
file.longitudinalOverlayOn = true;

end

