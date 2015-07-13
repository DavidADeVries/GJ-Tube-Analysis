function [ ] = tubePointCallback(hObject)
%[ ] = tubePointCallback(hObject)
% triggered when a tube point is moved. Updates the displayed tube spline.

handles = guidata(hObject);

tubePointHandles = handles.tubePointHandles;
numTubePoints = length(tubePointHandles);

tubePoints = zeros(numTubePoints, 2);

for i=1:numTubePoints
    tubePoints(i,:) = tubePointHandles(i).getPosition();
end

currentFile = getCurrentFile(handles);

%changes are not saved to the current file. That will be done if the
%general accept is clicked
tempFile = currentFile.setTubePoints(tubePoints);

toggled = false;

drawTube(tempFile, handles, toggled);


end

