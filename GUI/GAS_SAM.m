function varargout = GAS_SAM(varargin)

% add needed librarys

addpath('../Vesselness Enhancement');
addpath('../arrow');
addpath('../MATLAB Image Functions');
addpath('../Peter Kovesi Computer Vision Libraries/Feature Detection');

addpath(genpath('.')); %add all subfolders in the current directory

addpath(genpath(strcat(Constants.GIANT_PATH, 'GIANT Code')));
addpath(strcat(Constants.GIANT_PATH, 'Common Module Functions/Quick Measure'));
addpath(strcat(Constants.GIANT_PATH,'Common Module Functions/Plot Impoint'));
addpath(strcat(Constants.GIANT_PATH,'Common Module Functions/Line Labels'));

% GAS_SAM MATLAB code for GAS_SAM.fig
%      GAS_SAM, by itself, creates a new GAS_SAM or raises the existing
%      singleton*.
%
%      H = GAS_SAM returns the handle to a new GAS_SAM or the handle to
%      the existing singleton*.
%
%      GAS_SAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GAS_SAM.M with the given input arguments.
%
%      GAS_SAM('Property','Value',...) creates a new GAS_SAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GAS_SAM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GAS_SAM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GAS_SAM

% Last Modified by GUIDE v2.5 30-Jul-2015 14:56:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GAS_SAM_OpeningFcn, ...
    'gui_OutputFcn',  @GAS_SAM_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GAS_SAM is made visible.
function GAS_SAM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GAS_SAM (see VARARGIN)

% Choose default command line output for GAS_SAM
giantOpeningFcn(hObject, handles);

% UIWAIT makes GAS_SAM wait for user response (see UIRESUME)
% uiwait(handles.mainPanel);


% --- Outputs from this function are returned to the command line.
function varargout = GAS_SAM_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close mainPanel.
function mainPanel_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to mainPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
%delete(hObject);

giantCloseRequestFcn(hObject, handles);

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function mainPanel_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to mainPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantWindowButtonUpFcn(hObject, handles);



% % % % % % % % % % % % % % % %
% % GIANT BASE UI FUNCTIONS % %
% % % % % % % % % % % % % % % %



% % FILE FUNCTIONS % %

% ONLY FUNCTION IN MENU
% --------------------------------------------------------------------
function menuSavePatientAs_Callback(hObject, eventdata, handles)
% hObject    handle to menuSavePatientAs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantSavePatientAs(hObject, handles);

% --------------------------------------------------------------------
function open_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to menuopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantOpen(hObject, handles);

% --------------------------------------------------------------------
function savePatient_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to savePatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantSavePatient(hObject, handles);

% --------------------------------------------------------------------
function saveAll_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to saveAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantSaveAll(hObject, handles);

% --------------------------------------------------------------------
function exportPatient_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to exportPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantExportPatient(hObject, handles);

% --------------------------------------------------------------------
function exportAllPatients_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to menuExportPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantExportAllPatients(hObject, handles);

% --------------------------------------------------------------------
function exportAsImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to exportAsImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantExportAsImage(hObject, handles);


% % EDIT FUNCTIONS % %


% --------------------------------------------------------------------
function undo_ClickedCallback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantUndo(hObject, handles);

% --------------------------------------------------------------------
function redo_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to redo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantRedo(hObject, handles);


% % PATIENT MANAGEMENT FUNCTIONS % %


% --------------------------------------------------------------------
function importPatientDirectory_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to importPatientDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantImportPatientDirectory(hObject, handles);

% --------------------------------------------------------------------
function addPatient_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to addPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantAddPatient(hObject, handles);

% --------------------------------------------------------------------
function addStudy_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to menuAddStudy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantAddStudy(hObject, handles);

% --------------------------------------------------------------------
function addSeries_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to addSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantAddSeries(hObject, handles);

% --------------------------------------------------------------------
function addFile_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to addFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantAddFile(hObject, handles);

% --------------------------------------------------------------------
function closePatient_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to closeAllPatients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantClosePatient(hObject, handles);

% --------------------------------------------------------------------
function closeAllPatients_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to closeAllPatients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantCloseAllPatients(hObject, handles);

% --------------------------------------------------------------------
function removeStudy_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to removeStudy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantRemoveStudy(hObject, handles);

% --------------------------------------------------------------------
function removeSeries_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to removeSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantRemoveSeries(hObject, handles);

% --------------------------------------------------------------------
function removeFile_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to removeFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantRemoveFile(hObject, handles);

% --------------------------------------------------------------------
function previousSeries_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to previousSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantPreviousSeries(hObject, handles);

% --------------------------------------------------------------------
function nextSeries_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to nextSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantNextSeries(hObject, handles);

% --------------------------------------------------------------------
function earlierImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to earlierImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantEarlierImage(hObject, handles);

% --------------------------------------------------------------------
function laterImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to laterImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantLaterImage(hObject, handles);

% --------------------------------------------------------------------
function earliestImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to earliestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantEarliestImage(hObject, handles);

% --------------------------------------------------------------------
function latestImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to latestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

giantLatestImage(hObject, handles);


% % DROP-DOWN SELECTORS % %


% --- Executes on selection change in patientSelector.
function patientSelector_Callback(hObject, eventdata, handles)
% hObject    handle to patientSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns patientSelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from patientSelector

giantPatientSelector(hObject, handles);

% --- Executes during object creation, after setting all properties.
function patientSelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to patientSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in studySelector.
function studySelector_Callback(hObject, eventdata, handles)
% hObject    handle to studySelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns studySelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from studySelector

giantStudySelector(hObject, handles);

% --- Executes during object creation, after setting all properties.
function studySelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to studySelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in seriesSelector.
function seriesSelector_Callback(hObject, eventdata, handles)
% hObject    handle to seriesSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seriesSelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seriesSelector

giantSeriesSelector(hObject, handles);

% --- Executes during object creation, after setting all properties.
function seriesSelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seriesSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

                    % % % % % % % % % % % % % % % % %
                    % % MODULE SPECIFIC FUNCTIONS % %
                    % % % % % % % % % % % % % % % % %

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 



% % % % % % % % % % % % %
% % ACTION CALLBACKS  % %
% % % % % % % % % % % % %



% --- Executes when selected object is changed in unitPanel.
function unitPanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in unitPanel
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

newValue = get(eventdata.NewValue, 'Tag');

currentFile = getCurrentFile(handles);

switch newValue
    case 'unitNone'
        currentFile.displayUnits = 'none';
    case 'unitRelative'
        currentFile.displayUnits = 'relative';
    case 'unitAbsolute'
        currentFile.displayUnits = 'absolute';
    case 'unitPixel'
        currentFile.displayUnits = 'pixel';
    otherwise
        currentFile.displayUnits = 'none';
end

% finalize changes
updateUndo = false;
pendingChanges = true;

handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
toggled = false;
handles = drawMetricLines(currentFile, handles, toggled);
handles = drawQuickMeasureWithCallback(currentFile, handles, hObject, toggled);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function selectContrast_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to selectContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disableAllToggles(handles);

currentFile = getCurrentFile(handles);

if currentFile.roiOn % the MATLAB contrast interface when the image isn't using enough of the range, so for ROI we max it out
    roiImage = imcrop(handles.currentImage, currentFile.roiCoords);
    
    cLim = [min(min(roiImage)), max(max(roiImage))];
    
    set(handles.imageAxes,'CLim',cLim);
end

uiwait(imcontrastCustom(handles.imageAxes));

currentFile.contrastLimits = get(handles.imageAxes, 'CLim');
currentFile.contrastOn = true;

% finalize changes
updateUndo = true;
pendingChanges = true;

handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
% -> Nothing to update on display itself
updateToggleButtons(handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function selectRoi_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to selectRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disableAllToggles(handles);

currentFile = getCurrentFile(handles);

currentFile.roiOn = false;

[xmin,ymin,width,height] = findRoi(currentFile.getAdjustedImage(handles.currentImage)); %gives an ROI estimation

handles = drawImage(currentFile, handles);

cropWindow = imrect(handles.imageAxes, [xmin,ymin,width,height]);
cropCoords = wait(cropWindow);
delete(cropWindow);

currentFile.roiCoords = cropCoords;
currentFile.roiOn = true;

% finalize changes
updateUndo = true;
pendingChanges = true;

handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
handles = drawAll(currentFile, handles, hObject);
updateToggleButtons(handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function selectWaypoints_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to selectWaypoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disableAllToggles(handles);

currentFile = getCurrentFile(handles);

currentFile.waypointsOn = false; % need to clear the old ones off just in case

handles = deleteWaypoints(handles);

[x,y] = getptsCustom(handles.imageAxes, 'c'); %rip off of MATLAB fn, just needed to change the markers

waypoints = [x,y];

if height(waypoints) < 2
    title = 'Waypoint Selection Error';
    message = 'More than one waypoint must be selected!';
    
    msgbox(message, title);
    
    % finalize changes
    updateUndo = true;
    pendingChanges = true;
    handles = updateFile(currentFile, updateUndo, pendingChanges, handles);
else
    currentFile = currentFile.setWaypoints(waypoints);
    currentFile.waypointsOn = true;
    
    currentFile.tubePoints = [];
    currentFile.tubeOn = false;
    
    % finalize changes
    updateUndo = true;
    pendingChanges = true;
    handles = updateFile(currentFile, updateUndo, pendingChanges, handles);
    
    % update display
    toggled = false;
    draggable = false;
    
    handles = drawWaypoints(currentFile, handles, toggled, draggable);
    
    % delete tube points and metric lines
    handles = deleteTube(handles);
end

updateToggleButtons(handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function segmentTube_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to segmentTube (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disableAllToggles(handles);

currentFile = getCurrentFile(handles);

image = currentFile.getAdjustedImage(handles.currentImage);

stepRadius = str2double(get(handles.stepRadius, 'String'));
searchAngle = str2double(get(handles.searchAngle, 'String'));
searchRadius = str2double(get(handles.searchRadius, 'String'));
angularRes = str2double(get(handles.angularRes, 'String'));

waypoints = currentFile.getWaypoints();

waitHandle = pleaseWaitDialog('segmenting tube.');

try
    if currentFile.roiOn
        waypoints = nonRoiToRoi(currentFile.roiCoords, waypoints);
    end
    
    [rawTubePoints, numTubes] = pathFinder3(image, waypoints, stepRadius, searchAngle, searchRadius, angularRes);
catch
    numTubes = 0;
end

delete(waitHandle); 

if numTubes == 0
    title = 'Tube Segmentation Error';
    message = 'No tubes were found matching your current waypoints. Please redefine waypoints, check the segmentation parameters, or perform manual segmentation.';
    
    msgbox(message, title);       
elseif numTubes > 1
    title = 'Tube Segmentation Error';
    message = 'Multiple tubes were found matching your current waypoints. Please redefine waypoints to define a unique path or perform manual segmentation.';
    
    msgbox(message, title);   
else
    if currentFile.roiOn
        rawTubePoints = roiToNonRoi(currentFile.roiCoords, rawTubePoints);
    end
    
    currentFile.tubeOn = true;
    currentFile.metricPoints = MetricPoints.empty;
    currentFile.metricsOn = false;
    
    currentFile = currentFile.setTubePointsFromRaw(rawTubePoints);
    
    % finalize changes
    updateUndo = true;
    pendingChanges = true;
    handles = updateFile(currentFile, updateUndo, pendingChanges, handles);
    
    % update display
    handles = drawAll(currentFile, handles, hObject); %layering is usually screwed up by this point, so we fix it by redrawing everything
    
end

updateToggleButtons(handles);
    
% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function manualSegmentTube_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to manualSegmentTube (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disableAllToggles(handles);

currentFile = getCurrentFile(handles);

% imfreehand returns a jagged ROI, so we will take the points from
% imfreehand, choose a uniform number of points from these.

% STEP 1: get imfreehand points
tubeHandle = imfreehand(handles.imageAxes);

rawTubePoints = getPosition(tubeHandle);
delete(tubeHandle); %don't need it no more, going draw some splines instead

currentFile = currentFile.setWaypoints([]); % no waypoints are needed when manual segmentation is done
currentFile.waypointsOn = false;

currentFile = currentFile.setTubePointsFromRaw(rawTubePoints);
currentFile.tubeOn = true;

% finalize changes
updateUndo = true;
pendingChanges = true; 
handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
handles = drawAll(currentFile, handles, hObject); %layering is usually screwed up by this point, so we fix it by redrawing everything

updateToggleButtons(handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function tuneTube_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to tuneTube (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

handles = deleteWaypoints(handles);

handles = drawTubePointsWithCallbacks(currentFile, handles, hObject);

% no changes to finalize (using general accept/decline buttons)

% update display
% set up accept/decline buttons. UserData holds what the confirm/decline is
% for
disableAllToggles(handles);

set(handles.generalAccept, 'Visible', 'on', 'TooltipString', 'Confirm New Waypoints', 'UserData', 'Tube Tune');
set(handles.generalDecline, 'Visible', 'on', 'TooltipString', 'Decline New Waypoints', 'UserData', 'Tube Tune');

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function selectReference_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to selectReference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disableAllToggles(handles);

lineHandle = imline(handles.imageAxes);

refPoints = lineHandle.getPosition;

delete(lineHandle); %will be redrawn shortly, with proper formatting

currentFile = getCurrentFile(handles);

currentFile = currentFile.setRefPoints(refPoints);
currentFile.refOn = true;

% finalize changes
updateUndo = true;
pendingChanges = true; 
handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
toggled = false;
handles = drawRefLineWithCallback(currentFile, handles, hObject, toggled);

updateToggleButtons(handles);
updateUnitPanel(currentFile, handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function selectMidline_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to selectMidline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disableAllToggles(handles);

lineHandle = imline(handles.imageAxes);

midlinePoints = lineHandle.getPosition;

delete(lineHandle); %will be redrawn shortly, with proper formatting

currentFile = getCurrentFile(handles);

currentFile = currentFile.setMidlinePoints(midlinePoints);
currentFile.midlineOn = true;

% finalize changes
updateUndo = true;
pendingChanges = true; 
handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
toggled = false;
handles = drawMidlineWithCallback(currentFile, handles, hObject, toggled);

updateToggleButtons(handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function calcMetrics_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to calcMetrics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disableAllToggles(handles);

currentFile = getCurrentFile(handles);

%note that findMetricPoints does manipulate the display. It will delete any
%existing metric points/lines that are drawn
[metricPoints, handles] = findMetricsPoints(currentFile, handles, hObject );

if ~isempty(metricPoints) %if empty means user cancelled along the way
    currentFile.metricPoints = metricPoints;
    currentFile.metricsOn = true;
    currentFile = currentFile.chooseDisplayUnits();
    
    %update file into handles
    updateUndo = true;
    pendingChanges = true;
    
    handles = updateFile(currentFile, updateUndo, pendingChanges, handles);
    
    %draw the new points
    toggled = false;
    labelsOn = true;
    
    handles = drawMetricLines(currentFile, handles, toggled);
    handles = drawMetricPointsWithCallback(currentFile, handles, hObject, toggled, labelsOn);
        
    updateUnitPanel(currentFile, handles);
end

updateToggleButtons(handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function quickMeasure_ClickedCallback(hObject, eventdata, handles) %#ok<*INUSL>
% hObject    handle to quickMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disableAllToggles(handles);

lineHandle = imline(handles.imageAxes);

quickMeasurePoints = lineHandle.getPosition;

delete(lineHandle); %will be redrawn shortly, with proper formatting

currentFile = getCurrentFile(handles);

currentFile = currentFile.setQuickMeasurePoints(quickMeasurePoints);
currentFile.quickMeasureOn = true;
currentFile = currentFile.chooseDisplayUnits();

% finalize changes
updateUndo = true;
pendingChanges = true; 
handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
toggled = false;
handles = deleteQuickMeasure(handles);
handles = drawQuickMeasureWithCallback(currentFile, handles, hObject, toggled);

updateToggleButtons(handles);
updateUnitPanel(currentFile, handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function calcLongitudinal_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to calcLongitudinal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

currentPatient.longitudinalOn = true;

%set up files that will be included, and list them for selection in a
%listbox
currentPatient = currentPatient.updateLongitudinalFileNumbers();

%push back changes
handles = updatePatient(currentPatient, handles);

%update GUI
updateToggleButtons(handles);
updateLongitudinalListbox(currentPatient, handles);

%draw new image
toggled = false;

handles = drawLongitudinalComparison(currentPatient, handles, toggled);

%push up changes
guidata(hObject, handles);



% --- Executes on selection change in longitudinalListbox.
function longitudinalListbox_Callback(hObject, eventdata, handles)
% hObject    handle to longitudinalListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns longitudinalListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from longitudinalListbox

clickedValue = get(hObject,'Value');

currentPatient = getCurrentPatient(handles);

clickedFileNumber = currentPatient.longitudinalFileNumbers(clickedValue);

clickedFile = currentPatient.files(clickedFileNumber);

clickedFile.longitudinalOverlayOn = ~clickedFile.longitudinalOverlayOn;

updateUndo = false;
pendingChanges = true;

handles = updateFile(clickedFile, updateUndo, pendingChanges, handles, clickedFileNumber);

currentPatient = getCurrentPatient(handles);

currentPatient = currentPatient.updateLongitudinalFileNumbers();

handles = updatePatient(currentPatient, handles);

currentFile = getCurrentFile(handles);

%update GUI
updateToggleButtons(handles);
updateLongitudinalListbox(currentPatient, handles);

%draw new image
handles = drawAll(currentFile, handles, hObject);%drawLongitudinalComparison(currentPatient, handles);

%push up changes
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function longitudinalListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to longitudinalListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function generalAccept_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to generalAccept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

func = get(handles.generalAccept, 'UserData');

switch func
    case 'Tube Tune'
        currentFile = getCurrentFile(handles);
        
        tubePointHandles = handles.tubePointHandles;
        numTubePoints = length(tubePointHandles);
        
        tubePoints = zeros(numTubePoints, 2);
        
        for i=1:numTubePoints
            tubePoints(i,:) = tubePointHandles(i).getPosition();
        end
        
        currentFile = currentFile.setTubePoints(tubePoints);
                  
        %save changes
        updateUndo = true;
        pendingChanges = true;
        
        handles = updateFile(currentFile, updateUndo, pendingChanges, handles);
        
        %turn-off accept/decline buttons
        set(handles.generalAccept, 'Visible', 'off', 'TooltipString', '', 'UserData', '');
        set(handles.generalDecline, 'Visible', 'off', 'TooltipString', '', 'UserData', '');
        
        %GUI updated
        updateToggleButtons(handles);
        
        %displayed imaged updated
        % delete tube points dragging points
        handles = deleteTubePoints(handles);        
                
        %push up changes
        guidata(hObject, handles);
        
    otherwise
        warning('Invalid UserData setting for generalAccept');
end



% --------------------------------------------------------------------
function generalDecline_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to generalDecline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

func = get(handles.generalAccept, 'UserData');

switch func
    case 'Tube Tune'
        currentFile = getCurrentFile(handles);
                
        %turn-off accept/decline buttons
        set(handles.generalAccept, 'Visible', 'off', 'TooltipString', '', 'UserData', '');
        set(handles.generalDecline, 'Visible', 'off', 'TooltipString', '', 'UserData', '');
        
        handles = deleteTubePoints(handles);
        
        toggled = false;
        handles = drawTube(currentFile, handles, toggled);
        
        updateToggleButtons(handles);
        
        guidata(hObject, handles);
    otherwise
        warning('Invalid UserData setting for generalDecline');
end



% % % % % % % % % % % % %
% % TOGGLE CALLBACKS  % %
% % % % % % % % % % % % %



% --------------------------------------------------------------------
function toggleContrast_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.contrastOn = ~currentFile.contrastOn;
        
% finalize changes
updateUndo = false;
pendingChanges = true; 
handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
handles = drawContrast(currentFile, handles);
updateToggleButtons(handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function toggleRoi_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);
    
currentFile.roiOn = ~currentFile.roiOn;

% finalize changes
updateUndo = false;
pendingChanges = true; 
handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
handles = drawImage(currentFile, handles);
updateToggleButtons(handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function toggleWaypoints_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleWaypoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.waypointsOn = ~currentFile.waypointsOn;

% finalize changes
updateUndo = false;
pendingChanges = true; 
handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
toggled = true;
draggable = false;

handles = drawWaypoints(currentFile, handles, toggled, draggable);
updateToggleButtons(handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function toggleTube_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleTube (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.tubeOn = ~currentFile.tubeOn;

% finalize changes
updateUndo = false;
pendingChanges = true; 
handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
toggled = true;

handles = drawTube(currentFile, handles, toggled);
updateToggleButtons(handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function toggleReference_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleReference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.refOn = ~currentFile.refOn;

% finalize changes
updateUndo = false;
pendingChanges = true; 
handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
toggled = true;

handles = drawRefLineWithCallback(currentFile, handles, hObject, toggled);
updateToggleButtons(handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function toggleMidline_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleMidline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.midlineOn = ~currentFile.midlineOn;

% finalize changes
updateUndo = false;
pendingChanges = true; 
handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
toggled = true;

handles = drawMidlineWithCallback(currentFile, handles, hObject, toggled);
updateToggleButtons(handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function toggleMetrics_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleMetrics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.metricsOn = ~currentFile.metricsOn;

% finalize changes
updateUndo = false;
pendingChanges = true; 
handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
toggled = true;
labelsOn = true;

handles = drawMetricLines(currentFile, handles, toggled);
handles = drawMetricPointsWithCallback(currentFile, handles, hObject, toggled, labelsOn);

updateToggleButtons(handles);
updateUnitPanel(currentFile, handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function toggleQuickMeasure_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleQuickMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile.quickMeasureOn = ~currentFile.quickMeasureOn;

% finalize changes
updateUndo = false;
pendingChanges = true; 
handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
toggled = true;
handles = drawQuickMeasureWithCallback(currentFile, handles, hObject, toggled);

updateToggleButtons(handles);
updateUnitPanel(currentFile, handles);

% push up the changes
guidata(hObject, handles);



% --------------------------------------------------------------------
function toggleLongitudinal_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleLongitudinal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

currentPatient.longitudinalOn = ~currentPatient.longitudinalOn;

handles = updatePatient(currentPatient, handles);

%update GUI
updateToggleButtons(handles);

%draw new image
toggled = true;

handles = drawLongitudinalComparison(currentPatient, handles, toggled);

%push up changes
guidata(hObject, handles);




% % % % % % % % % % % %
% % MENU CALLBACKS  % %
% % % % % % % % % % % %




% these simply call their clickable toolbar counterparts



% MENU FILE CALLBACKS



% --------------------------------------------------------------------
function menuFile_Callback(hObject, eventdata, handles)
% hObject    handle to menuFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menuOpen_Callback(hObject, eventdata, handles)
% hObject    handle to menuOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

open_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuSavePatient_Callback(hObject, eventdata, handles)
% hObject    handle to menuSavePatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

savePatient_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuSaveAll_Callback(hObject, eventdata, handles)
% hObject    handle to menuSaveAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

saveAll_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuExportPatient_Callback(hObject, eventdata, handles)
% hObject    handle to menuExportPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exportPatient_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuExportAllPatients_Callback(hObject, eventdata, handles)
% hObject    handle to menuExportAllPatients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exportAllPatients_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuExportAsImage_Callback(hObject, eventdata, handles)
% hObject    handle to menuExportAsImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exportAsImage_ClickedCallback(hObject, eventdata, handles);



% MENU PATIENT MANAGMENT CALLBACKS



% --------------------------------------------------------------------
function menuPatientManagement_Callback(hObject, eventdata, handles)
% hObject    handle to menuPatientManagement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menuImportPatientDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to menuImportPatientDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

importPatientDirectory_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuAddPatient_Callback(hObject, eventdata, handles)
% hObject    handle to menuAddPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

addPatient_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuAddStudy_Callback(hObject, eventdata, handles)
% hObject    handle to menuAddStudy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

addStudy_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuAddSeries_Callback(hObject, eventdata, handles)
% hObject    handle to menuAddSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

addSeries_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuAddFile_Callback(hObject, eventdata, handles)
% hObject    handle to menuAddFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

addFile_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuClosePatient_Callback(hObject, eventdata, handles)
% hObject    handle to menuClosePatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

closePatient_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuCloseAllPatients_Callback(hObject, eventdata, handles)
% hObject    handle to menuCloseAllPatients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

closeAllPatients_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuRemoveStudy_Callback(hObject, eventdata, handles)
% hObject    handle to menuRemoveStudy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

removeStudy_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuRemoveSeries_Callback(hObject, eventdata, handles)
% hObject    handle to menuRemoveSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

removeSeries_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuRemoveFile_Callback(hObject, eventdata, handles)
% hObject    handle to menuRemoveFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

removeFile_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuPreviousSeries_Callback(hObject, eventdata, handles)
% hObject    handle to menuPreviousSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

previousSeries_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuNextSeries_Callback(hObject, eventdata, handles)
% hObject    handle to menuNextSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

nextSeries_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuEarlierImage_Callback(hObject, eventdata, handles)
% hObject    handle to menuEarlierImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

earlierImage_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuLaterImage_Callback(hObject, eventdata, handles)
% hObject    handle to menuLaterImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

laterImage_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuEarliestImage_Callback(hObject, eventdata, handles)
% hObject    handle to menuEarliestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

earliestImage_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuLatestImage_Callback(hObject, eventdata, handles)
% hObject    handle to menuLatestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

latestImage_ClickedCallback(hObject, eventdata, handles);



% MENU EDIT CALLBACKS



% --------------------------------------------------------------------
function menuEdit_Callback(hObject, eventdata, handles)
% hObject    handle to menuEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menuUndo_Callback(hObject, eventdata, handles)
% hObject    handle to menuUndo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

undo_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuRedo_Callback(hObject, eventdata, handles)
% hObject    handle to menuRedo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

redo_ClickedCallback(hObject, eventdata, handles);



% MENU TOOLS CALLBACKS



% --------------------------------------------------------------------
function menuTools_Callback(hObject, eventdata, handles)
% hObject    handle to menuTools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menuSelectReference_Callback(hObject, eventdata, handles)
% hObject    handle to menuSelectReference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectReference_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuCalcMetrics_Callback(hObject, eventdata, handles)
% hObject    handle to menuCalcMetrics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

calcMetrics_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuQuickMeasure_Callback(hObject, eventdata, handles)
% hObject    handle to menuQuickMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

quickMeasure_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuSelectMidline_Callback(hObject, eventdata, handles)
% hObject    handle to menuSelectMidline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectMidline_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuSelectWaypoints_Callback(hObject, eventdata, handles)
% hObject    handle to menuSelectWaypoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectWaypoints_ClickedCallback(hObject, eventdata, handles);

function menuManualSegmentTube_Callback(hObject, eventdata, handles)
% hObject    handle to menuManualSegmentTube (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

manualSegmentTube_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuCalcLongitudinal_Callback(hObject, eventdata, handles)
% hObject    handle to menuCalcLongitudinal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

calcLongitudinal_ClickedCallback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function menuSelectContrast_Callback(hObject, eventdata, handles)
% hObject    handle to menuSelectContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectContrast_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuSelectRoi_Callback(hObject, eventdata, handles)
% hObject    handle to menuSelectRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectRoi_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuSegmentTube_Callback(hObject, eventdata, handles)
% hObject    handle to menuSegmentTube (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

segmentTube_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuTuneTube_Callback(hObject, eventdata, handles)
% hObject    handle to menuTuneTube (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tuneTube_ClickedCallback(hObject, eventdata, handles);



% MENU VIEW (TOGGLE) CALLBACKS



% --------------------------------------------------------------------
function menuView_Callback(hObject, eventdata, handles)
% hObject    handle to menuView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menuToggleContrast_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleContrast_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuToggleRoi_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleRoi_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuToggleWaypoints_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleWaypoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleWaypoints_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuToggleTube_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleTube (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleTube_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuToggleReference_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleReference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleReference_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuToggleMidline_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleMidline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleMidline_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuToggleMetrics_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleMetrics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleMetrics_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuToggleQuickMeasure_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleQuickMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleQuickMeasure_ClickedCallback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuToggleLongitudinal_Callback(hObject, eventdata, handles)
% hObject    handle to menuToggleLongitudinal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toggleLongitudinal_ClickedCallback(hObject, eventdata, handles);






% Segmentation Parameter Create Fcns



% --- Executes during object creation, after setting all properties.
function stepRadius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to priorConstrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function searchAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to priorConstrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function searchRadius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to priorConstrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function angularRes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to priorConstrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to priorConstrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to priorConstrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function searchRadius_Callback(hObject, eventdata, handles)
% hObject    handle to searchRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of searchRadius as text
%        str2double(get(hObject,'String')) returns contents of searchRadius as a double



function stepRadius_Callback(hObject, eventdata, handles)
% hObject    handle to stepRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stepRadius as text
%        str2double(get(hObject,'String')) returns contents of stepRadius as a double



function searchAngle_Callback(hObject, eventdata, handles)
% hObject    handle to searchAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of searchAngle as text
%        str2double(get(hObject,'String')) returns contents of searchAngle as a double



function angularRes_Callback(hObject, eventdata, handles)
% hObject    handle to angularRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angularRes as text
%        str2double(get(hObject,'String')) returns contents of angularRes as a double


