function handles = zoomCallback(currentFile, hObject, handles)
% handles = zoomCallback(currentFile, hObject, handles)
%
% ** REQUIRED BY GIANT **
%
% This function is triggered automatically whenever the zoom changes. The
% zoom state may then be saved and stuff redrawn if need be
%
% NOTE: the push back of data (aka. guidata(hObject, handles)) will be done
% by GIANT, you just need to return the updated handles.

currentFile.roiOn = false; %once a zoom happens, ROI goes off

updateUndo = false;
pendingChanges = true;

handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

toggled = false;

handles = drawMetricLines(currentFile, handles, toggled);
handles = drawQuickMeasureWithCallback(currentFile, handles, hObject, toggled);


end

