function [ handles ] = drawImage( currentFile, handles )
%drawImage draws the actual image itself, no lines or other points are
%drawn

image = handles.currentImage;

axesHandle = handles.imageAxes;

imageHandle = handles.imageHandle;

if isempty(imageHandle)
    axes(axesHandle);
    
    handles.imageHandle = imshow(image, currentFile.getCurrentLimits());
else
    set(imageHandle, 'CData', image);
    set(axesHandle, 'CLim', currentFile.getCurrentLimits());
end

% set roi if on
if currentFile.roiOn
    roiCoords = currentFile.roiCoords;
    
    xLim = [roiCoords(1), roiCoords(1) + roiCoords(3)];
    yLim = [roiCoords(2), roiCoords(2) + roiCoords(4)];
else
    xLim = currentFile.zoomLims.xLim;
    yLim = currentFile.zoomLims.yLim;
end

zoom reset; % do this or else zooming out becomes an issue
set(axesHandle, 'XLim', xLim, 'YLim', yLim);



end

