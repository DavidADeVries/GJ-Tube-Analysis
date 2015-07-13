function [ ] = disableAllToggles( handles )
%disableAllToggles used when no patients are open to just lock everything
%down

disableAllGiantToggleButtons(handles);

%toolbar options

set(handles.selectContrast, 'Enable', 'off');
set(handles.selectRoi, 'Enable', 'off');
set(handles.selectWaypoints, 'Enable', 'off');
set(handles.segmentTube, 'Enable', 'off');
set(handles.manualSegmentTube, 'Enable', 'off');
set(handles.tuneTube, 'Enable', 'off');
set(handles.selectReference, 'Enable', 'off');
set(handles.selectMidline, 'Enable', 'off');
set(handles.calcMetrics, 'Enable', 'off');
set(handles.calcLongitudinal, 'Enable', 'off');
set(handles.quickMeasure, 'Enable', 'off');

set(handles.toggleContrast, 'Enable', 'off');
set(handles.toggleRoi, 'Enable', 'off');
set(handles.toggleWaypoints, 'Enable', 'off');
set(handles.toggleTube, 'Enable', 'off');
set(handles.toggleReference, 'Enable', 'off');
set(handles.toggleMidline, 'Enable', 'off');
set(handles.toggleMetrics, 'Enable', 'off');
set(handles.toggleLongitudinal, 'Enable', 'off');
set(handles.toggleQuickMeasure, 'Enable', 'off');

set(handles.toggleContrast, 'State', 'off');
set(handles.toggleRoi, 'State', 'off');
set(handles.toggleWaypoints, 'State', 'off');
set(handles.toggleTube, 'State', 'off');
set(handles.toggleReference, 'State', 'off');
set(handles.toggleMidline, 'State', 'off');
set(handles.toggleMetrics, 'State', 'off');
set(handles.toggleLongitudinal, 'State', 'off');
set(handles.toggleQuickMeasure, 'State', 'off');

% don't even want to see these ones
set(handles.generalAccept, 'Visible', 'off');
set(handles.generalDecline, 'Visible', 'off');

%menu options

set(handles.menuSelectContrast, 'Enable', 'off');
set(handles.menuSelectRoi, 'Enable', 'off');
set(handles.menuSelectWaypoints, 'Enable', 'off');
set(handles.menuSegmentTube, 'Enable', 'off');
set(handles.menuManualSegmentTube, 'Enable', 'off');
set(handles.menuTuneTube, 'Enable', 'off');
set(handles.menuSelectReference, 'Enable', 'off');
set(handles.menuSelectMidline, 'Enable', 'off');
set(handles.menuCalcMetrics, 'Enable', 'off');
set(handles.menuCalcLongitudinal, 'Enable', 'off');
set(handles.menuQuickMeasure, 'Enable', 'off');

set(handles.menuToggleContrast, 'Enable', 'off');
set(handles.menuToggleRoi, 'Enable', 'off');
set(handles.menuToggleWaypoints, 'Enable', 'off');
set(handles.menuToggleTube, 'Enable', 'off');
set(handles.menuToggleReference, 'Enable', 'off');
set(handles.menuToggleMidline, 'Enable', 'off');
set(handles.menuToggleMetrics, 'Enable', 'off');
set(handles.menuToggleLongitudinal, 'Enable', 'off');
set(handles.menuToggleQuickMeasure, 'Enable', 'off');

set(handles.menuToggleContrast, 'Checked', 'off');
set(handles.menuToggleRoi, 'Checked', 'off');
set(handles.menuToggleWaypoints, 'Checked', 'off');
set(handles.menuToggleTube, 'Checked', 'off');
set(handles.menuToggleReference, 'Checked', 'off');
set(handles.menuToggleMidline, 'Checked', 'off');
set(handles.menuToggleMetrics, 'Checked', 'off');
set(handles.menuToggleLongitudinal, 'Checked', 'off');
set(handles.menuToggleQuickMeasure, 'Checked', 'off');

end

