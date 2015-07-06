function [] = updateUnitPanel(currentFile, handles)
%updateUnitPanel takes the unitPanel radio buttons and enables/disables
%them

if isempty(currentFile)
    enableVal = 'off';
    unitRelativeEnableVal = 'off';
    
    set(handles.unitNone, 'Value', 1);
elseif currentFile.quickMeasureOn || currentFile.metricsOn    
    refPoints = currentFile.getRefPoints();
    displayUnits = currentFile.displayUnits();
    
    enableVal = 'on';
    
    if isempty(refPoints)
        unitRelativeEnableVal = 'off'; %can't have that turning on without a reference point!
    else
        unitRelativeEnableVal = 'on';
    end
  
    switch displayUnits
        case 'none'
            set(handles.unitNone, 'Value', 1);
        case 'relative'
            set(handles.unitRelative, 'Value', 1);
        case 'absolute'
            set(handles.unitAbsolute, 'Value', 1);
        case 'pixel'
            set(handles.unitPixel, 'Value', 1);
        otherwise
            set(handles.unitNone, 'Value', 1);
    end
else %nothing is on that needs unit measurement
    enableVal = 'off';
    unitRelativeEnableVal = 'off';
end

% apply the found enableVal to each radio button
set(handles.unitNone, 'Enable', enableVal);
set(handles.unitRelative, 'Enable', unitRelativeEnableVal);
set(handles.unitAbsolute, 'Enable', enableVal);
set(handles.unitPixel, 'Enable', enableVal);

end