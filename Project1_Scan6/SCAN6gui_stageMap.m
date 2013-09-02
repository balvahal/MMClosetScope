function varargout = SCAN6gui_stageMap(varargin)
% SCAN6GUI_STAGEMAP MATLAB code for SCAN6gui_stageMap.fig
%      SCAN6GUI_STAGEMAP, by itself, creates a new SCAN6GUI_STAGEMAP or raises the existing
%      singleton*.
%
%      H = SCAN6GUI_STAGEMAP returns the handle to a new SCAN6GUI_STAGEMAP or the handle to
%      the existing singleton*.
%
%      SCAN6GUI_STAGEMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCAN6GUI_STAGEMAP.M with the given input arguments.
%
%      SCAN6GUI_STAGEMAP('Property','Value',...) creates a new SCAN6GUI_STAGEMAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SCAN6gui_stageMap_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SCAN6gui_stageMap_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SCAN6gui_stageMap

% Last Modified by GUIDE v2.5 01-Sep-2013 22:32:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SCAN6gui_stageMap_OpeningFcn, ...
                   'gui_OutputFcn',  @SCAN6gui_stageMap_OutputFcn, ...
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


% --- Executes just before SCAN6gui_stageMap is made visible.
function SCAN6gui_stageMap_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SCAN6gui_stageMap (see VARARGIN)

% Choose default command line output for SCAN6gui_stageMap
handles.output = hObject;

% add the main figure handles to the current figure handles
guiMainInputIndex = find(strcmp(varargin, 'gui_main'));
handles.gui_main = varargin{guiMainInputIndex+1};
% remember the current figure handles
handles.gui_self = hObject;

% Function Handles
handles.updateInfo = @stageMap_updateInfo;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SCAN6gui_stageMap wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SCAN6gui_stageMap_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
%delete(hObject);

% --- Updates the information displayed on the stageMap whenever the
% sampleIndex is changed
function stageMap_updateInfo(hObject)
% hObject   handle to the main figure
handles = guidata(hObject);


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
