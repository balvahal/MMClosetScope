function varargout = StageMap_gui_main(varargin)
% STAGEMAP_GUI_MAIN MATLAB code for StageMap_gui_main.fig
%      STAGEMAP_GUI_MAIN, by itself, creates a new STAGEMAP_GUI_MAIN or raises the existing
%      singleton*.
%
%      H = STAGEMAP_GUI_MAIN returns the handle to a new STAGEMAP_GUI_MAIN or the handle to
%      the existing singleton*.
%
%      STAGEMAP_GUI_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STAGEMAP_GUI_MAIN.M with the given input arguments.
%
%      STAGEMAP_GUI_MAIN('Property','Value',...) creates a new STAGEMAP_GUI_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StageMap_gui_main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StageMap_gui_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StageMap_gui_main

% Last Modified by GUIDE v2.5 06-Feb-2014 15:54:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StageMap_gui_main_OpeningFcn, ...
                   'gui_OutputFcn',  @StageMap_gui_main_OutputFcn, ...
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


% --- Executes just before StageMap_gui_main is made visible.
function StageMap_gui_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StageMap_gui_main (see VARARGIN)

% Choose default command line output for StageMap_gui_main
handles.output = hObject;

%%%%%%% USER ADDED START
% add mm to the main figure handles
mmInputIndex = find(strcmp(varargin, 'mm'));
if isempty(mmInputIndex)
    disp('*****');
    disp('Improper input arguments. Pass in mm');
    disp('*****');
    %delete(hObject);
else
    handles.mm = varargin{mmInputIndex+1};
end
% remember the handles to itself
handles.StageMap_gui_main = hObject;
handles.mm.gui_StageMap = handles.StageMap_gui_main;
% add function handles
handles.update = @StageMap_gui_main_update_infig;

% Get the pixels per character for this monitor and computer system
% This information is vital for displaying properly proportioned
% information when the units of the gui dimensions are characters.
myunits = get(0,'units');
set(0,'units','pixels');
Pix_SS = get(0,'screensize');
set(0,'units','characters');
Char_SS = get(0,'screensize');
ppChar = Pix_SS./Char_SS;
handles.ppChar = ppChar(3:4);
set(0,'units',myunits);

% Get the image size in micrometers to help define the upperleft and
% lowerright corners of the imaging rectangle
pixelSize = handles.mm.core.getPixelSizeUm;
pixWidth = handles.mm.core.getImageWidth;
pixHeight = handles.mm.core.getImageHeight;
handles.imageWidth = pixWidth*pixelSize; % in micrometers
handles.imageHeight = pixHeight*pixelSize; % in micrometers

% Resize axes so that the width and height are the same ratio as the
% physical xy stage
myPosition = get(handles.axes_StageMap,'Position');
x_pixels = myPosition(3)*handles.ppChar(1);
y_pixels = x_pixels*(handles.mm.xyStageLimits(4)-handles.mm.xyStageLimits(3))/(handles.mm.xyStageLimits(2)-handles.mm.xyStageLimits(1));
y_char = y_pixels/handles.ppChar(2);
myPosition(4) = y_char;
set(handles.axes_StageMap,'Position',myPosition);
set(handles.axes_StageMap,'YDir','reverse');
set(handles.axes_StageMap,'XLim',[handles.mm.xyStageLimits(1),handles.mm.xyStageLimits(2)]);
set(handles.axes_StageMap,'YLim',[handles.mm.xyStageLimits(3),handles.mm.xyStageLimits(4)]);
set(handles.axes_StageMap,'XAxisLocation','top');
set(handles.axes_StageMap,'TickDir','out');
%%%%%%% USER ADDED END

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes StageMap_gui_main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = StageMap_gui_main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function StageMap_gui_main_update_infig(hObject)
StageMap_gui_main_update(hObject);
