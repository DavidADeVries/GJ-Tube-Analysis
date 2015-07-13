function [ ] = updateGui( currentFile, handles )
%[ ] = updateGui( currentFile, handles )
% updates the entire GUI not just specific elements
% useful when switching patients/studies/series/files, a bit overkill if
% just making updates to the file

updateImageInfo(currentFile, handles);

updatePatientSelector(handles);
updateStudySelector(handles);
updateSeriesSelector(handles);

updateUnitPanel(currentFile, handles);

updateToggleButtons(handles);


end

