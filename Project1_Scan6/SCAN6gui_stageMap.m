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

% Last Modified by GUIDE v2.5 03-Sep-2013 02:27:10

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
mainHandles = guidata(handles.gui_main);
% remember the current figure handles
handles.gui_self = hObject;

% Function Handles
handles.updateInfo = @stageMap_updateInfo;

% Resize axes so that the width and height are the same ratio as the
% physical xy stage
myPosition = get(handles.axesStageMap,'Position');
x_pixels = myPosition(3)*mainHandles.ppChar(1);
y_pixels = x_pixels*mainHandles.mmhandle.xyStageSize(2)/mainHandles.mmhandle.xyStageSize(1);
y_char = y_pixels/mainHandles.ppChar(2);
myPosition(4) = y_char;
set(handles.axesStageMap,'Position',myPosition);
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
stageMapHandles = guidata(handles.gui_stageMap);
hold on;
for i = 1:length(handles.sampleInfo)
    % plot a circle of the predicted coverslip area
    if ~isempty(handles.sampleInfo(i).center)&&...
            ~isempty(handles.sampleInfo(i).radius)&&...
            ~isnan(handles.sampleInfo(i).radius)
        viscircles(stageMapHandles.axesStageMap,handles.sampleInfo(i).center,handles.sampleInfo(i).radius,'LineWidth',1.5);
    end
    % plot an 'x' at each user generated point
    if ~isempty(handles.sampleInfo(i).circumferencePts)
        scatter(stageMapHandles.axesStageMap,handles.sampleInfo(i).circumferencePts(:,1),handles.sampleInfo(i).circumferencePts(:,2),'x','sizedata',100,'CData',[0 0 0],'LineWidth',1.5);
    end
end
hold off;
% Format the axes to reflect the layout of the stage
set(stageMapHandles.axesStageMap,'YDir','reverse');
set(stageMapHandles.axesStageMap,'XLim',[0 handles.mmhandle.xyStageSize(1)]);
set(stageMapHandles.axesStageMap,'YLim',[0 handles.mmhandle.xyStageSize(2)]);

% --- Executes during object creation, after setting all properties.
function axesStageMap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axesStageMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axesStageMap


% --- Executes on button press in pushbuttonRefresh.
function pushbuttonRefresh_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRefresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.updateInfo(handles.gui_main);