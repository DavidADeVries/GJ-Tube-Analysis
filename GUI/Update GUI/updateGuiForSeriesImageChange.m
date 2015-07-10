function [  ] = updateGuiForSeriesImageChange(currentFile, handles)
%[  ] = updateGuiForSeriesImageChange(currentFile, handles)
% as required for GIANT

updateImageInfo(currentFile, handles);
updateToggleButtons(handles);
updateUnitPanel(currentFile, handles);

end

