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

% Last Modified by GUIDE v2.5 29-Aug-2013 15:33:35

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


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
%delete(hObject);
set(hObject,'visible','off');
