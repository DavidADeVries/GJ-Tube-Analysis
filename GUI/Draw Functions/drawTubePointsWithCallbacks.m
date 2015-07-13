function [ handles ] = drawTubePointsWithCallbacks( currentFile, handles, hObject )
%[ handles ] = drawTubePoints( currentFile, handles )

tubePoints = currentFile.getTubePoints(); %adjusted for ROI

% constants
startColour = Constants.TUNING_POINT_START_COLOUR;
endColour = Constants.TUNING_POINT_END_COLOUR;

draggable = true;

%plot the tuning points!

numTubePoints = length(tubePoints);

% calculate colour increments for gradient colour shift between
% lines
redShift = (endColour(1) - startColour(1))/numTubePoints;
greenShift = (endColour(2) - startColour(2))/numTubePoints;
blueShift = (endColour(3) - startColour(3))/numTubePoints;

tubePointHandles = impoint.empty(numTubePoints,0);

for i=1:length(tubePoints)         
    r = startColour(1) + i*redShift;
    g = startColour(2) + i*greenShift;
    b = startColour(3) + i*blueShift;
    
    colour = [r g b];
    
    tubePointHandle = plotImpoint(tubePoints(i,:), colour, draggable, handles.imageAxes);
    
    func = @(pos) tubePointCallback(hObject);
    addNewPositionCallback(tubePointHandle, func);
    
    tubePointHandles(i) = tubePointHandle;
end

handles.tubePointHandles = tubePointHandles;

end

