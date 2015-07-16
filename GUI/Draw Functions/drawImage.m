function [ handles ] = drawImage( currentFile, handles )
%drawImage draws the actual image itself, no lines or other points are
%drawn

image = currentFile.getCurrentImage(handles.currentImage); %either ROI or not
cLim = currentFile.getCurrentLimits();

axes(handles.imageAxes);

imshow(image,cLim);

%clear all other handles because imshow killed everything
handles = emptyDisplayHandles(handles);

end

