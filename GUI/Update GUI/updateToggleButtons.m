function [ ] = updateToggleButtons( handles )
%updateToggleButtons when switching images, the toggle buttons need to be
%correctly depressed or not to begin with

disableAllToggles(handles);

updateGiantToggleButtons(handles);

currentFile = getCurrentFile(handles);

if ~isempty(currentFile) %add in file operations for module
    % on no matter what state currentFile is in
    
    set(handles.selectContrast, 'Enable', 'on');
    set(handles.selectRoi, 'Enable', 'on');
    set(handles.selectWaypoints, 'Enable', 'on');
    set(handles.manualSegmentTube, 'Enable', 'on');
    set(handles.selectReference, 'Enable', 'on');
    set(handles.selectMidline, 'Enable', 'on');
    set(handles.quickMeasure, 'Enable', 'on');
    
    set(handles.menuSelectContrast, 'Enable', 'on');
    set(handles.menuSelectRoi, 'Enable', 'on');
    set(handles.menuSelectWaypoints, 'Enable', 'on');
    set(handles.menuManualSegmentTube, 'Enable', 'on');
    set(handles.menuSelectReference, 'Enable', 'on');
    set(handles.menuSelectMidline, 'Enable', 'on');
    set(handles.menuQuickMeasure, 'Enable', 'on');
    
    % state of these depends on what state file is in
    %contrast toggle button
    if ~isempty(currentFile.contrastLimits)
        %set(handles.toggleContrast, 'Enable', 'on');
        set(handles.menuToggleContrast, 'Enable', 'on');
    end
    
    if currentFile.contrastOn
        %set(handles.toggleContrast, 'State', 'on');
        set(handles.menuToggleContrast, 'Checked', 'on');
    end
    
    %ROI toggle button
    if ~isempty(currentFile.roiCoords)
        %set(handles.toggleRoi, 'Enable', 'on');
        set(handles.menuToggleRoi, 'Enable', 'on');
    end
    
    if currentFile.roiOn
        %set(handles.toggleRoi, 'State', 'on');
        set(handles.menuToggleRoi, 'Checked', 'on');
    end
    
    %waypoint toggle button
    if ~isempty(currentFile.waypoints)
        %set(handles.toggleWaypoints, 'Enable', 'on');
        set(handles.menuToggleWaypoints, 'Enable', 'on');
        set(handles.segmentTube, 'Enable', 'on');
        set(handles.menuSegmentTube, 'Enable', 'on');
    end
    
    if currentFile.waypointsOn
        %set(handles.toggleWaypoints, 'State', 'on');
        set(handles.menuToggleWaypoints, 'Checked', 'on');
    end
    
    %tube toggle button
    if ~isempty(currentFile.tubePoints)
        %set(handles.toggleTube, 'Enable', 'on');
        set(handles.menuToggleTube, 'Enable', 'on');
    end
    
    if currentFile.tubeOn
        %set(handles.toggleTube, 'State', 'on');
        set(handles.menuToggleTube, 'Checked', 'on');
    end
    
    %reference points button
    if ~isempty(currentFile.refPoints)
        %set(handles.toggleReference, 'Enable', 'on');
        set(handles.menuToggleReference, 'Enable', 'on');
    end
    
    if currentFile.refOn
        %set(handles.toggleReference, 'State', 'on');
        set(handles.menuToggleReference, 'Checked', 'on');
    end
    
    %midline points button
    if ~isempty(currentFile.midlinePoints)
        %set(handles.toggleMidline, 'Enable', 'on');
        set(handles.menuToggleMidline, 'Enable', 'on');
    end
    
    if currentFile.midlineOn
        %set(handles.toggleMidline, 'State', 'on');
        set(handles.menuToggleMidline, 'Checked', 'on');
    end
    
    %metrics button
    if ~isempty(currentFile.metricPoints)
        %set(handles.toggleMetrics, 'Enable', 'on');
        set(handles.menuToggleMetrics, 'Enable', 'on');
    end
    
    if currentFile.metricsOn
        %set(handles.toggleMetrics, 'State', 'on');
        set(handles.menuToggleMetrics, 'Checked', 'on');
    end
    
    if ~isempty(currentFile.midlinePoints)
        set(handles.calcMetrics, 'Enable', 'on');
        set(handles.menuCalcMetrics, 'Enable', 'on');
    end
    
    %quick measure button
    if ~isempty(currentFile.quickMeasurePoints)
        %set(handles.toggleQuickMeasure, 'Enable', 'on');
        set(handles.menuToggleQuickMeasure, 'Enable', 'on');
    end
    
    if currentFile.quickMeasureOn
        %set(handles.toggleQuickMeasure, 'State', 'on');
        set(handles.menuToggleQuickMeasure, 'Checked', 'on');
    end
    
    % tuning button (only available when there are waypoints)
    
    if ~isempty(currentFile.tubePoints)
        set(handles.tuneTube, 'Enable', 'on');
        set(handles.menuTuneTube, 'Enable', 'on');
    end
    
    % longitudinal button (only available when there more than file)
    
%     if currentPatient.getNumFilesInSeries > 1
%         set(handles.calcLongitudinal, 'Enable', 'on');
%         set(handles.toggleLongitudinal, 'Enable', 'on');
%         
%         set(handles.menuCalcLongitudinal, 'Enable', 'on');
%         set(handles.menuToggleLongitudinal, 'Enable', 'on');
%     end
%     
%     if currentPatient.longitudinalOn
%         set(handles.toggleLongitudinal, 'State', 'on');
%         set(handles.menuToggleLongitudinal, 'Checked', 'on');
%     end
end