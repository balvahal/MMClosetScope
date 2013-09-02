function varargout = SCAN6gui_defineCoverslipArea(varargin)
% SCAN6GUI_DEFINECOVERSLIPAREA MATLAB code for SCAN6gui_defineCoverslipArea.fig
%      SCAN6GUI_DEFINECOVERSLIPAREA, by itself, creates a new SCAN6GUI_DEFINECOVERSLIPAREA or raises the existing
%      singleton*.
%
%      H = SCAN6GUI_DEFINECOVERSLIPAREA returns the handle to a new SCAN6GUI_DEFINECOVERSLIPAREA or the handle to
%      the existing singleton*.
%
%      SCAN6GUI_DEFINECOVERSLIPAREA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCAN6GUI_DEFINECOVERSLIPAREA.M with the given input arguments.
%
%      SCAN6GUI_DEFINECOVERSLIPAREA('Property','Value',...) creates a new SCAN6GUI_DEFINECOVERSLIPAREA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SCAN6gui_defineCoverslipArea_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SCAN6gui_defineCoverslipArea_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SCAN6gui_defineCoverslipArea

% Last Modified by GUIDE v2.5 30-Aug-2013 10:18:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SCAN6gui_defineCoverslipArea_OpeningFcn, ...
                   'gui_OutputFcn',  @SCAN6gui_defineCoverslipArea_OutputFcn, ...
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


% --- Executes just before SCAN6gui_defineCoverslipArea is made visible.
function SCAN6gui_defineCoverslipArea_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SCAN6gui_defineCoverslipArea (see VARARGIN)

% Choose default command line output for SCAN6gui_defineCoverslipArea
handles.output = hObject;

% add the main figure handles to the current figure handles
guiMainInputIndex = find(strcmp(varargin, 'gui_main'));
handles.gui_main = varargin{guiMainInputIndex+1};
% remember the current figure handles
handles.gui_self = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SCAN6gui_defineCoverslipArea wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SCAN6gui_defineCoverslipArea_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listboxPts.
function listboxPts_Callback(hObject, eventdata, handles)
% hObject    handle to listboxPts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxPts contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxPts


% --- Executes during object creation, after setting all properties.
function listboxPts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxPts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonAdd.
function pushbuttonAdd_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonAdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% retrieve the mmhandles and get the stage position from the microscope
mainHandles = guidata(handles.gui_main);
if isempty(mainHandles.sampleIndex)
    return;
end
mainHandles.mmhandle = SCAN6general_getXYZ(mainHandles.mmhandle);
mainHandles.sampleInfo(mainHandles.sampleIndex).circumferencePts(end+1,1:2) = mainHandles.mmhandle.pos(1:2);
% estimate the size of the coverslip area using this new information
[xc,yc,r] = SCAN6config_estimateCircle(mainHandles.sampleInfo(mainHandles.sampleIndex).circumferencePts);
mainHandles.sampleInfo(mainHandles.sampleIndex).center = [xc,yc];
mainHandles.sampleInfo(mainHandles.sampleIndex).radius = r;
% add this position data to the listboxPts
listboxPtsContents = get(handles.listboxPts,'String');
listboxPtsContents{end+1} = sprintf('%2d.%7.0f || %7.0f',length(listboxPtsContents),xc,yc);
set(handles.listboxPts,'String',listboxPtsContents);
% update the handles
guidata(handles.gui_main, mainHandles);
guidata(handles.gui_self, handles);

% --- Executes on button press in pushbuttonSubtract.
function pushbuttonSubtract_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSubtract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(handles.listboxPts,'Value');
if isempty(index_selected)
    return;
end
% retrieve the main handles
mainHandles = guidata(handles.gui_main);
if isempty(mainHandles.sampleIndex)
    return;
end
% remove selected data point from the main handles struct and the
% listboxPts
mainHandles.sampleInfo(mainHandles.sampleIndex).circumferencePts(index_selected,:) = [];
%
listboxPtsContents = get(handles.listboxPts,'String');
listboxPtsContents(index_selected) = [];
if isempty(listboxPtsContents)
    set(handles.listboxPts,'Value',[]);
elseif length(listboxPtsContents)<index_selected
    set(handles.listboxPts,'Value',length(listboxPtsContents));
end
set(handles.listboxPts,'String',listboxPtsContents);
% estimate the size of the coverslip area after removing this information
[xc,yc,r] = SCAN6config_estimateCircle(mainHandles.sampleInfo(mainHandles.sampleIndex).circumferencePts);
mainHandles.sampleInfo(mainHandles.sampleIndex).center = [xc,yc];
mainHandles.sampleInfo(mainHandles.sampleIndex).radius = r;
% update the handles
guidata(handles.gui_main, mainHandles);
guidata(handles.gui_self, handles);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
%delete(hObject);
set(hObject,'visible','off');
