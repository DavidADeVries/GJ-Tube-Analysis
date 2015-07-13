function [ ] = updateGuiForUndoRedo(currentFile, handles )
%[ ] = updateGuiForUndoRedo(currentFile, handles )
% as required by GIANT

updateToggleButtons(handles);
updateUnitPanel(currentFile, handles);

end

