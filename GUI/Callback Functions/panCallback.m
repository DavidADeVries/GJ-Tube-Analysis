function handles = panCallback(currentFile, hObject, handles)
% handles = panCallback(currentFile, hObject, handles)
%
% ** REQUIRED BY GIANT **
%
% This function is triggered automatically whenever the pan changes. The
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


end

