function [ ] = updateToggleButtons( handles )
%updateToggleButtons when switching images, the toggle buttons need to be
%correctly depressed or not to begin with

disableAllToggles(handles);

% always available
set(handles.open, 'Enable', 'on');
set(handles.menuOpen, 'Enable', 'on');

set(handles.importPatientDirectory, 'Enable', 'on');
set(handles.addPatient, 'Enable', 'on');

set(handles.menuImportPatientDirectory, 'Enable', 'on');
set(handles.menuAddPatient, 'Enable', 'on');


currentPatient = getCurrentPatient(handles);

if ~isempty(currentPatient) %add in patient operations
    
    if ~currentPatient.changesPending
        set(handles.savePatient, 'Enable', 'off');
        set(handles.menuSavePatient, 'Enable', 'off');
    else
        set(handles.savePatient, 'Enable', 'on');
        set(handles.menuSavePatient, 'Enable', 'on');        
    end
    
    set(handles.saveAll, 'Enable', 'on');
    set(handles.exportPatient, 'Enable', 'on');
    set(handles.exportAllPatients, 'Enable', 'on');
    
    set(handles.addStudy, 'Enable', 'on');
    set(handles.closePatient, 'Enable', 'on');
    set(handles.closeAllPatients, 'Enable', 'on');
    
    set(handles.menuOpen, 'Enable', 'on');
    set(handles.menuSavePatientAs, 'Enable', 'on');
    set(handles.menuSaveAll, 'Enable', 'on');
    set(handles.menuExportPatient, 'Enable', 'on');
    set(handles.menuExportAllPatients, 'Enable', 'on');
    
    set(handles.menuImportPatientDirectory, 'Enable', 'on');
    set(handles.menuAddPatient, 'Enable', 'on');    
    set(handles.menuAddStudy, 'Enable', 'on');
    set(handles.menuClosePatient, 'Enable', 'on');
    set(handles.menuCloseAllPatients, 'Enable', 'on');
           
    currentStudy = currentPatient.getCurrentStudy();
    
    if ~isempty(currentStudy) %add in study operations
        set(handles.addSeries, 'Enable', 'on');        
        set(handles.removeStudy, 'Enable', 'on');
                
        set(handles.menuAddSeries, 'Enable', 'on');        
        set(handles.menuRemoveStudy, 'Enable', 'on');
                
        currentSeries = currentStudy.getCurrentSeries();
        
        if ~isempty(currentSeries) %add in series operations
            set(handles.addFile, 'Enable', 'on');        
            set(handles.removeSeries, 'Enable', 'on');
                
            set(handles.menuAddFile, 'Enable', 'on');        
            set(handles.menuRemoveSeries, 'Enable', 'on');
            
            currentFile = currentSeries.getCurrentFile();
            
            if ~isempty(currentFile) %add in file operations
                % on no matter what state currentFile is in
                set(handles.removeFile, 'Enable', 'on');
                
                set(handles.selectContrast, 'Enable', 'on');
                set(handles.selectRoi, 'Enable', 'on');
                set(handles.selectWaypoints, 'Enable', 'on');
                set(handles.manualSegmentTube, 'Enable', 'on');
                set(handles.selectReference, 'Enable', 'on');
                set(handles.selectMidline, 'Enable', 'on');
                set(handles.quickMeasure, 'Enable', 'on');
                
                set(handles.menuRemoveFile, 'Enable', 'on');
                
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
                    set(handles.toggleContrast, 'Enable', 'on');
                    set(handles.menuToggleContrast, 'Enable', 'on');
                end
                
                if currentFile.contrastOn
                    set(handles.toggleContrast, 'State', 'on');
                    set(handles.menuToggleContrast, 'Checked', 'on');
                end
                
                %ROI toggle button
                if ~isempty(currentFile.roiCoords)
                    set(handles.toggleRoi, 'Enable', 'on');
                    set(handles.menuToggleRoi, 'Enable', 'on');
                end
                
                if currentFile.roiOn
                    set(handles.toggleRoi, 'State', 'on');
                    set(handles.menuToggleRoi, 'Checked', 'on');
                end
                
                %waypoint toggle button
                if ~isempty(currentFile.waypoints)
                    set(handles.toggleWaypoints, 'Enable', 'on');
                    set(handles.menuToggleWaypoints, 'Enable', 'on');
                    set(handles.segmentTube, 'Enable', 'on');
                    set(handles.menuSegmentTube, 'Enable', 'on');
                end
                
                if currentFile.waypointsOn
                    set(handles.toggleWaypoints, 'State', 'on');
                    set(handles.menuToggleWaypoints, 'Checked', 'on');
                end
                
                %tube toggle button
                if ~isempty(currentFile.tubePoints)
                    set(handles.toggleTube, 'Enable', 'on');
                    set(handles.menuToggleTube, 'Enable', 'on');
                end
                
                if currentFile.tubeOn
                    set(handles.toggleTube, 'State', 'on');
                    set(handles.menuToggleTube, 'Checked', 'on');
                end
                
                %reference points button
                if ~isempty(currentFile.refPoints)
                    set(handles.toggleReference, 'Enable', 'on');
                    set(handles.menuToggleReference, 'Enable', 'on');
                end
                
                if currentFile.refOn
                    set(handles.toggleReference, 'State', 'on');
                    set(handles.menuToggleReference, 'Checked', 'on');
                end
                
                %midline points button
                if ~isempty(currentFile.midlinePoints)
                    set(handles.toggleMidline, 'Enable', 'on');
                    set(handles.menuToggleMidline, 'Enable', 'on');
                end
                
                if currentFile.midlineOn
                    set(handles.toggleMidline, 'State', 'on');
                    set(handles.menuToggleMidline, 'Checked', 'on');
                end
                
                %metrics button
                if ~isempty(currentFile.metricPoints)
                    set(handles.toggleMetrics, 'Enable', 'on');
                    set(handles.menuToggleMetrics, 'Enable', 'on');
                end
                
                if currentFile.metricsOn
                    set(handles.toggleMetrics, 'State', 'on');
                    set(handles.menuToggleMetrics, 'Checked', 'on');
                end
                
                if ~isempty(currentFile.midlinePoints)
                    set(handles.calcMetrics, 'Enable', 'on');
                    set(handles.menuCalcMetrics, 'Enable', 'on');
                end
                
                %quick measure button
                if ~isempty(currentFile.quickMeasurePoints)
                    set(handles.toggleQuickMeasure, 'Enable', 'on');
                    set(handles.menuToggleQuickMeasure, 'Enable', 'on');
                end
                
                if currentFile.quickMeasureOn
                    set(handles.toggleQuickMeasure, 'State', 'on');
                    set(handles.menuToggleQuickMeasure, 'Checked', 'on');
                end
                
                % undo/redo buttons
                
                undoCache = currentFile.undoCache;
                
                if undoCache.cacheLocation ~= 1
                    set(handles.redo, 'Enable', 'on');
                    set(handles.menuRedo, 'Enable', 'on');
                end
                
                if undoCache.cacheLocation ~= undoCache.numCacheEntries()
                    set(handles.undo, 'Enable', 'on');
                    set(handles.menuUndo, 'Enable', 'on');
                end
                
                % tuning button (only available when there are waypoints)
                
                if ~isempty(currentFile.tubePoints)
                    set(handles.tuneTube, 'Enable', 'on');
                    set(handles.menuTuneTube, 'Enable', 'on');
                end
                
                % longitudinal button (only available when there more than file)
                
                if currentPatient.getNumFilesInSeries > 1
                    set(handles.calcLongitudinal, 'Enable', 'on');
                    set(handles.toggleLongitudinal, 'Enable', 'on');
                    
                    set(handles.menuCalcLongitudinal, 'Enable', 'on');
                    set(handles.menuToggleLongitudinal, 'Enable', 'on');
                end
                
                if currentPatient.longitudinalOn
                    set(handles.toggleLongitudinal, 'State', 'on');
                    set(handles.menuToggleLongitudinal, 'Checked', 'on');
                end
                
                % time moving buttons
                
                if currentPatient.getCurrentFileNumInSeries() ~= 1
                    set(handles.earlierImage, 'Enable', 'on');
                    set(handles.earliestImage, 'Enable', 'on');
                    
                    set(handles.menuEarlierImage, 'Enable', 'on');
                    set(handles.menuEarliestImage, 'Enable', 'on');
                end
                
                if currentPatient.getCurrentFileNumInSeries() ~= currentPatient.getNumFilesInSeries()
                    set(handles.laterImage, 'Enable', 'on');
                    set(handles.latestImage, 'Enable', 'on');
                    
                    set(handles.menuLaterImage, 'Enable', 'on');
                    set(handles.menuLatestImage, 'Enable', 'on');
                end
            end
        end
    end      
end