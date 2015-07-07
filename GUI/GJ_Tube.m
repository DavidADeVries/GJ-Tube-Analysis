function varargout = GJ_Tube(varargin)

% add needed librarys

addpath('../Image Processing');
addpath('../CircStat2012a');
addpath('../arrow');
addpath('/data/projects/GJtube/metadata/MATLAB Image Functions');
addpath('/data/projects/GJtube/metadata/Peter Kovesi Computer Vision Libraries/Feature Detection');
addpath(genpath('.')); %add all subfolders in the current directory

rmpath('./Old Stuff [Delete]'); %ignore old files

% GJ_TUBE MATLAB code for GJ_Tube.fig
%      GJ_TUBE, by itself, creates a new GJ_TUBE or raises the existing
%      singleton*.
%
%      H = GJ_TUBE returns the handle to a new GJ_TUBE or the handle to
%      the existing singleton*.
%
%      GJ_TUBE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GJ_TUBE.M with the given input arguments.
%
%      GJ_TUBE('Property','Value',...) creates a new GJ_TUBE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GJ_Tube_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GJ_Tube_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GJ_Tube

% Last Modified by GUIDE v2.5 06-Jul-2015 11:42:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GJ_Tube_OpeningFcn, ...
    'gui_OutputFcn',  @GJ_Tube_OutputFcn, ...
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


% --- Executes just before GJ_Tube is made visible.
function GJ_Tube_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GJ_Tube (see VARARGIN)

% Choose default command line output for GJ_Tube
handles.output = hObject;

handles.numPatients = 0; %records the number of images that are currently open
handles.currentPatientNum = 0; %the current image being displayed
handles.updateUndoCache = false; %tells upclick listener whether or not to save undo data

handles.patients = Patient.empty;

% empty handle structures
handles = emptyDisplayHandles(handles);


%clear axes

axes(handles.imageAxes);
imshow([],[]);
cla(handles.imageAxes); % clear axes

updateGui(File.empty, handles);

updateLongitudinalListbox(Patient.empty, handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GJ_Tube wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GJ_Tube_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function open_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to menuopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

allowedFileOptions = {...
    '*.mat','Patient Analysis Files (*.mat)'};
popupTitle = 'Select Patient Analysis Files';
startingDirectory = Constants.HOME_DIRECTORY;

[imageFilename, imagePath, ~] = uigetfile(allowedFileOptions, popupTitle, startingDirectory);

if imageFilename ~= 0 %user didn't click cancel!
    completeFilepath = strcat(imagePath, imageFilename);
    
    openCancelled = false;
    
    % load previous analysis file .mat
    loadedData = load(completeFilepath);
    
    patient = loadedData.patient;
    
    [patientNum, ~] = findPatient(handles.patients, patient.patientId);
    
    if patientNum == 0 % create new
        handles.numPatients = handles.numPatients + 1;
        patientNum = handles.numPatients;
    else %overwrite whatever patient with the same id was there before
        openCancelled = overwritePatientDialog(); %confirm with user that they want to overwrite
    end
    
    if ~openCancelled        
        handles.currentPatientNum = patientNum;
        
        currentFile = patient.getCurrentFile();
        
        handles = updatePatient(patient, handles);
        
        %update Gui
        updateGui(currentFile, handles);
        
        handles = drawAll(currentFile, handles, hObject);        
        
        % pushup changes
        guidata(hObject, handles);
    end
    
end

% --------------------------------------------------------------------
function exportAllPatients_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to menuExportPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exportPatients(handles.patients);


% --------------------------------------------------------------------
function exportPatient_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to exportPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exportPatients(getCurrentPatient(handles));


% --------------------------------------------------------------------
function closeAllPatients_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to closeAllPatients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for i=1:handles.numPatients
    patient = handles.patients(i);
    
    closeCancelled = false;
    saveFirst = false;
    
    if patient.changesPending;
        [closeCancelled, saveFirst] = pendingChangesDialog(); %prompts user if they want to save unsaved changes
    end
    
    if closeCancelled
        break;
    elseif saveFirst %user chose to save
        patient.saveToDisk();
    end  
end

if ~closeCancelled
    handles.patients = Patient.empty;
    handles.currentPatientNum = 0;
    handles.numPatients = 0;
    
    currentFile = File.empty;
    
    %GUI updated
    updateGui(currentFile, handles);
    
    %displayed imaged updated
    handles = drawAll(currentFile, handles, hObject);
    
    %push up changes
    guidata(hObject, handles);
end


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


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.updateUndoCache    
    currentFile = getCurrentFile(handles);
        
    %save changes
    updateUndo = true;
    pendingChanges = true;
    
    handles = updateFile(currentFile, updateUndo, pendingChanges, handles); %undo cache will be auto updated
    
    % reset updateUndoCache variable (will on go again when a callback is
    % triggered, not just any click)
    handles.updateUndoCache = false;
    
    updateToggleButtons(handles);
    
    %push up changes
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function selectContrast_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to selectContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

if currentFile.roiOn % the MATLAB contrast interface when the image isn't using enough of the range, so for ROI we max it out
    roiImage = imcrop(currentFile.image, currentFile.roiCoords);
    
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
handles = drawAll(currentFile, handles, hObject);
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
function selectRoi_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to selectRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

[xmin,ymin,width,height] = findRoi(currentFile.image); %gives an ROI estimation

currentFile.roiOn = false;

handles = drawAll(currentFile, handles, hObject);

cropWindow = imrect(handles.imageAxes, [xmin,ymin,width,height]);
cropCoords = wait(cropWindow);

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

currentFile = getCurrentFile(handles);

currentFile.waypointsOn = false; % need to clear the old ones off just in case

handles = deleteWaypoints(handles);

[x,y] = getptsCustom(handles.imageAxes, 'c'); %rip off of MATLAB fn, just needed to change the markers

waypoints = [x,y];

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

updateToggleButtons(handles);

% push up the changes
guidata(hObject, handles);

% --------------------------------------------------------------------
function segmentTube_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to segmentTube (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

image = currentFile.getAdjustedImage();

interpolConstrain = str2double(get(handles.interpolConstrain, 'String'));
priorConstrain = str2double(get(handles.priorConstrain, 'String'));
curveConstrain = str2double(get(handles.curveConstrain, 'String'));
radius = str2double(get(handles.radius, 'String'));
searchAngle = str2double(get(handles.searchAngle, 'String'));
width = str2double(get(handles.width, 'String'));
angularRes = str2double(get(handles.angularRes, 'String'));

waypoints = currentFile.getWaypoints();

[rawTubePoints, ~] = pathFinder(image, waypoints, interpolConstrain, priorConstrain, curveConstrain, radius, searchAngle, width, angularRes);

currentFile.tubeOn = true;

currentFile = currentFile.setTubePointsFromRaw(rawTubePoints);

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
    
    updateToggleButtons(handles);
    updateUnitPanel(currentFile, handles);
    
    % push up the changes
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function quickMeasure_ClickedCallback(hObject, eventdata, handles) %#ok<*INUSL>
% hObject    handle to quickMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
function undo_ClickedCallback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile = performUndo(currentFile);

% finalize changes
updateUndo = false;
pendingChanges = true; 
handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
handles = drawAll(currentFile, handles, hObject);

updateToggleButtons(handles);
updateUnitPanel(currentFile, handles);

% push up the changes
guidata(hObject, handles);

% --------------------------------------------------------------------
function redo_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to redo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFile = getCurrentFile(handles);

currentFile = performRedo(currentFile);

% finalize changes
updateUndo = false;
pendingChanges = true; 
handles = updateFile(currentFile, updateUndo, pendingChanges, handles);

% update display
handles = drawAll(currentFile, handles, hObject);

updateToggleButtons(handles);
updateUnitPanel(currentFile, handles);

% push up the changes
guidata(hObject, handles);

% --------------------------------------------------------------------
function earlierImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to earlierImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

currentPatient = currentPatient.earlierImage();

currentPatient.changesPending = true;

handles = updatePatient(currentPatient, handles);

currentFile = getCurrentFile(handles);

%update GUI
updateImageInfo(currentFile, handles);
updateToggleButtons(handles);
updateUnitPanel(currentFile, handles);

%draw new image
handles = drawAll(currentFile, handles, hObject);

%push up changes
guidata(hObject, handles);


% --------------------------------------------------------------------
function laterImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to laterImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

currentPatient = currentPatient.laterImage();

currentPatient.changesPending = true;

handles = updatePatient(currentPatient, handles);

currentFile = getCurrentFile(handles);

%update GUI
updateImageInfo(currentFile, handles);
updateToggleButtons(handles);
updateUnitPanel(currentFile, handles);

%draw new image
handles = drawAll(currentFile, handles, hObject);

%push up changes
guidata(hObject, handles);


% --------------------------------------------------------------------
function toggleLongitudinal_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toggleLongitudinal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

currentPatient.longitudinalOn = ~currentPatient.longitudinalOn;

handles = updatePatient(currentPatient, handles);

currentFile = getCurrentFile(handles);

%update GUI
updateToggleButtons(handles);

%draw new image
toggled = true;

handles = drawLongitudinalComparison(currentPatient, handles, toggled);

%push up changes
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

currentFile = getCurrentFile(handles);

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
function earliestImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to earliestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

currentPatient = currentPatient.earliestImage();

currentPatient.changesPending = true;

handles = updatePatient(currentPatient, handles);

currentFile = getCurrentFile(handles);

%update GUI
updateImageInfo(currentFile, handles);
updateToggleButtons(handles);
updateUnitPanel(currentFile, handles);

%draw new image
handles = drawAll(currentFile, handles, hObject);

%push up changes
guidata(hObject, handles);

% --------------------------------------------------------------------
function latestImage_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to latestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

currentPatient = currentPatient.latestImage();

currentPatient.changesPending = true;

handles = updatePatient(currentPatient, handles);

currentFile = getCurrentFile(handles);

%update GUI
updateImageInfo(currentFile, handles);
updateToggleButtons(handles);
updateUnitPanel(currentFile, handles);

%draw new image
handles = drawAll(currentFile, handles, hObject);

%push up changes
guidata(hObject, handles);

% --- Executes on selection change in patientSelector.
function patientSelector_Callback(hObject, eventdata, handles)
% hObject    handle to patientSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns patientSelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from patientSelector

handles.currentPatientNum = get(hObject,'Value');

currentFile = getCurrentFile(handles);

%update GUI
updateGui(currentFile, handles);

%draw new image
handles = drawAll(currentFile, handles, hObject);

%push up changes
guidata(hObject, handles);


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


% --------------------------------------------------------------------
function savePatient_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to savePatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

currentPatient = currentPatient.saveToDisk();

handles = updatePatient(currentPatient, handles);

updateToggleButtons(handles);

guidata(hObject, handles);


% --------------------------------------------------------------------
function saveAll_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to saveAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for i=1:handles.numPatients
    patient = handles.patients(i).saveToDisk();
        
    handles = updatePatient(patient, handles, i);    
end

updateToggleButtons(handles);

guidata(hObject, handles);

% --------------------------------------------------------------------
function closePatient_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to closeAllPatients (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

closeCancelled = false;
saveFirst = false;

if currentPatient.changesPending;
    [closeCancelled, saveFirst] = pendingChangesDialog(); %prompts user if they want to save unsaved changes
end

if ~closeCancelled
    if saveFirst %user chose to save
        currentPatient.saveToDisk();
    end
    
    handles = removeCurrentPatient(handles); %patient removed from patient list
    
    currentFile = getCurrentFile(handles);
    
    %GUI updated
    updateGui(currentFile, handles);
    
    %displayed imaged updated
    handles = drawAll(currentFile, handles, hObject);
    
    %push up changes
    guidata(hObject, handles);  
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


% --- Executes on mouse press over axes background.
function imageAxes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to imageAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function manualSegmentTube_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to manualSegmentTube (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --- Executes on selection change in studySelector.
function studySelector_Callback(hObject, eventdata, handles)
% hObject    handle to studySelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns studySelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from studySelector
currentPatient = getCurrentPatient(handles);

currentPatient.currentStudyNum = get(hObject,'Value');

handles = updatePatient(currentPatient, handles);

currentFile = getCurrentFile(handles);

%update GUI
updateGui(currentFile, handles);

%draw new image
handles = drawAll(currentFile, handles, hObject);

%push up changes
guidata(hObject, handles);

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

currentPatient = getCurrentPatient(handles);

currentPatient = currentPatient.setCurrentSeriesNum(get(hObject,'Value'));

handles = updatePatient(currentPatient, handles);

currentFile = getCurrentFile(handles);

%update GUI
updateGui(currentFile, handles);

%draw new image
handles = drawAll(currentFile, handles, hObject);

%push up changes
guidata(hObject, handles);

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


% --------------------------------------------------------------------
function addPatient_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to addPatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

patientId = patientIdDialog();

if ~isempty(patientId) %empty means user pressed cancel, do nothing
    [patientNum, ~] = findPatient(handles.patients, patientId); %see if the patient already exists
    
    openCancelled = false;
    
    if patientNum ~= 0 %ask user if they want to overwrite whatever patient with the same id was there before
        openCancelled = overwritePatientDialog(); %confirm with user that they want to overwrite
    else
        handles.numPatients = handles.numPatients + 1;
        patientNum = handles.numPatients;
    end
    
    if ~openCancelled %is not cancelled, assign new patient
        handles.currentPatientNum = patientNum;   
        
        newPatient = Patient(patientId, Study.empty);
        newPatient.changesPending = true;
        
        handles = updatePatient(newPatient, handles); %will automatically set newPatient into current patient spot
        
        currentFile = getCurrentFile(handles);
        
        %update GUI
        updateGui(currentFile, handles);
        
        %draw new image
        handles = drawAll(currentFile, handles, hObject);
        
        %push up changes
        guidata(hObject, handles);
    end
end

% --------------------------------------------------------------------
function addStudy_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to menuAddStudy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

studyName = studyNameDialog();

if ~isempty(studyName) %empty means user pressed cancel, do nothing
    currentPatient = getCurrentPatient(handles);
    
    newStudy = Study(studyName, Series.empty);
    
    currentPatient = currentPatient.addStudy(newStudy);
    
    currentPatient.changesPending = true;
    
    handles = updatePatient(currentPatient, handles);
    currentFile = getCurrentFile(handles);
    
    %update GUI
    updateGui(currentFile, handles);
    
    %draw new image
    handles = drawAll(currentFile, handles, hObject);
    
    %push up changes
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function addSeries_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to addSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

seriesName = seriesNameDialog();

if ~isempty(seriesName) %empty means user pressed cancel, do nothing
    currentPatient = getCurrentPatient(handles);

    newSeries = Series(seriesName, File.empty);
    
    currentPatient = currentPatient.addSeries(newSeries);
    
    currentPatient.changesPending = true;
    
    handles = updatePatient(currentPatient, handles);
    currentFile = getCurrentFile(handles);
    
    %update GUI
    updateGui(currentFile, handles);
    
    %draw new image
    handles = drawAll(currentFile, handles, hObject);
    
    %push up changes
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function addFile_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to addFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

allowedFileOptions = {...
    '*.dcm','DICOM Files (*.dcm)'};
popupTitle = 'Select Image';
startingDirectory = Constants.HOME_DIRECTORY;

[imageFilename, imagePath, ~] = uigetfile(allowedFileOptions, popupTitle, startingDirectory);

if imageFilename ~= 0 %user didn't click cancel!
    currentPatient = getCurrentPatient(handles);
    
    completeFilepath = strcat(imagePath, imageFilename);
    dicomInfo = dicominfo(completeFilepath);
    
    if strcmp(dicomInfo.PatientID, currentPatient.patientId) %double check sure patient is the same
        dicomImage = dicomread(completeFilepath);
        
        if (length(size(dicomImage)) == 2) %no multisplice support, sorry
            originalLimits = [min(min(dicomImage)), max(max(dicomImage))];
            
            newFile = File(imageFilename, dicomInfo, dicomImage, originalLimits);
            
            currentPatient = currentPatient.addFile(newFile);
            
            currentPatient.changesPending = true;
            
            handles = updatePatient(currentPatient, handles);
            
            currentFile = getCurrentFile(handles);
            
            %update view
            updateImageInfo(currentFile, handles);
            updateToggleButtons(handles);
            updateUnitPanel(currentFile, handles);
            
            handles = drawAll(currentFile, handles, hObject);
            
            %push up changes
            
            guidata(hObject, handles);
        else
            waitfor(msgbox('Multi-slice images are not supported!','Error','error'));
        end
    else
        waitfor(patientIdConflictDialog(currentPatient.patientId, dicomInfo.PatientID, completeFilepath));
    end
end

% --------------------------------------------------------------------
function removeStudy_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to removeStudy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

question = 'Are you sure you want to remove the current study and all contained series and files? This cannot be undone!';
title = 'Remove Current Study';

cancelled = confirmRemoveDialog(question, title);

if ~cancelled
    currentPatient = getCurrentPatient(handles);
    
    currentPatient = currentPatient.removeCurrentStudy();
    currentPatient.changesPending = true;
    
    handles = updatePatient(currentPatient, handles);
    currentFile = getCurrentFile(handles);
    
    %update GUI
    updateGui(currentFile, handles);
    
    %draw new image
    handles = drawAll(currentFile, handles, hObject);
    
    %push up changes
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function removeSeries_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to removeSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

question = 'Are you sure you want to remove the current series and all contained files? This cannot be undone!';
title = 'Remove Current Series';

cancelled = confirmRemoveDialog(question, title);

if ~cancelled
    currentPatient = getCurrentPatient(handles);
    
    currentPatient = currentPatient.removeCurrentSeries();
    currentPatient.changesPending = true;
    
    handles = updatePatient(currentPatient, handles);
    currentFile = getCurrentFile(handles);
    
    %update GUI
    updateGui(currentFile, handles);
    
    %draw new image
    handles = drawAll(currentFile, handles, hObject);
    
    %push up changes
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function removeFile_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to removeFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

question = 'Are you sure you want to remove the current file? This cannot be undone!';
title = 'Remove Current File';

cancelled = confirmRemoveDialog(question, title);

if ~cancelled    
    currentPatient = getCurrentPatient(handles);
    
    currentPatient = currentPatient.removeCurrentFile(); 
    
    currentPatient.changesPending = true;
    
    handles = updatePatient(currentPatient, handles);    
    currentFile = currentPatient.getCurrentFile();
    
    %GUI updated
    updateGui(currentFile, handles);
    
    %displayed imaged updated
    handles = drawAll(currentFile, handles, hObject);
    
    %push up changes
    guidata(hObject, handles);  
end

% --------------------------------------------------------------------
function importPatientDirectory_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to importPatientDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

folderPath = uigetdir(Constants.HOME_DIRECTORY, 'Select Patient Directory');

if folderPath ~= 0 %didn't click cancel
    waitHandle = pleaseWaitDialog('importing directory.');
    
    [studies, patientId] = createStudies(folderPath); %recursively creates studies, containing series, containing files (dicoms)
        
    if ~isempty(patientId) %if empty, there must have been no files contained in the directories given
        [patientNum, ~] = findPatient(handles.patients, patientId); %see if the patient already exists
        
        openCancelled = false;
        
        if patientNum ~= 0 %ask user if they want to overwrite whatever patient with the same id was there before
            openCancelled = overwritePatientDialog(); %confirm with user that they want to overwrite
        else
            handles.numPatients = handles.numPatients + 1;
            patientNum = handles.numPatients;
        end
        
        if ~openCancelled %is not cancelled, assign new patient
            handles.currentPatientNum = patientNum;
            
            patient = Patient(patientId, studies);
            
            patient.changesPending = true;
            
            handles = updatePatient(patient, handles);
            
            currentFile = getCurrentFile(handles);
            
            %update view
            updateGui(currentFile, handles);
            
            handles = drawAll(currentFile, handles, hObject);
            
            %push up changes
            
            guidata(hObject, handles);
        end
    end
    
    delete(waitHandle);
end

% MENU CALLBACKS %%
% these simply call their clickable toolbar counterparts

% --------------------------------------------------------------------

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
function menuSavePatientAs_Callback(hObject, eventdata, handles)
% hObject    handle to menuSavePatientAs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentPatient = getCurrentPatient(handles);

currentPatient.savePath = ''; %clear it so that it will be redefined (save as)

currentPatient = currentPatient.saveToDisk();

handles = updatePatient(currentPatient, handles);

updateToggleButtons(currentPatient.getCurrentFile(), handles);

guidata(hObject, handles);

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















% Segmentation Parameters Callbacks

function interpolConstrain_Callback(hObject, eventdata, handles)
% hObject    handle to interpolConstrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interpolConstrain as text
%        str2double(get(hObject,'String')) returns contents of interpolConstrain as a double


% --- Executes during object creation, after setting all properties.
function interpolConstrain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interpolConstrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function priorConstrain_Callback(hObject, eventdata, handles)
% hObject    handle to priorConstrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of priorConstrain as text
%        str2double(get(hObject,'String')) returns contents of priorConstrain as a double


% --- Executes during object creation, after setting all properties.
function priorConstrain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to priorConstrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function curveConstrain_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to curveConstrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of curveConstrain as text
%        str2double(get(hObject,'String')) returns contents of curveConstrain as a double


% --- Executes during object creation, after setting all properties.
function curveConstrain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curveConstrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function width_Callback(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width as text
%        str2double(get(hObject,'String')) returns contents of width as a double


% --- Executes during object creation, after setting all properties.
function width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function radius_Callback(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of radius as text
%        str2double(get(hObject,'String')) returns contents of radius as a double


% --- Executes during object creation, after setting all properties.
function radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function searchAngle_Callback(hObject, eventdata, handles)
% hObject    handle to searchAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of searchAngle as text
%        str2double(get(hObject,'String')) returns contents of searchAngle as a double


% --- Executes during object creation, after setting all properties.
function searchAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to searchAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function angularRes_Callback(hObject, eventdata, handles)
% hObject    handle to angularRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angularRes as text
%        str2double(get(hObject,'String')) returns contents of angularRes as a double


% --- Executes during object creation, after setting all properties.
function angularRes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angularRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


