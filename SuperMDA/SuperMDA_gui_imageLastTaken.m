function varargout = SuperMDA_gui_imageLastTaken(varargin)
% SUPERMDA_GUI_IMAGELASTTAKEN MATLAB code for SuperMDA_gui_imageLastTaken.fig
%      SUPERMDA_GUI_IMAGELASTTAKEN, by itself, creates a new SUPERMDA_GUI_IMAGELASTTAKEN or raises the existing
%      singleton*.
%
%      H = SUPERMDA_GUI_IMAGELASTTAKEN returns the handle to a new SUPERMDA_GUI_IMAGELASTTAKEN or the handle to
%      the existing singleton*.
%
%      SUPERMDA_GUI_IMAGELASTTAKEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUPERMDA_GUI_IMAGELASTTAKEN.M with the given input arguments.
%
%      SUPERMDA_GUI_IMAGELASTTAKEN('Property','Value',...) creates a new SUPERMDA_GUI_IMAGELASTTAKEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SuperMDA_gui_imageLastTaken_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SuperMDA_gui_imageLastTaken_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SuperMDA_gui_imageLastTaken

% Last Modified by GUIDE v2.5 24-Jan-2014 15:37:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SuperMDA_gui_imageLastTaken_OpeningFcn, ...
                   'gui_OutputFcn',  @SuperMDA_gui_imageLastTaken_OutputFcn, ...
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


% --- Executes just before SuperMDA_gui_imageLastTaken is made visible.
function SuperMDA_gui_imageLastTaken_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SuperMDA_gui_imageLastTaken (see VARARGIN)

% Choose default command line output for SuperMDA_gui_imageLastTaken
handles.output = hObject;
% add mmhandle to the figure handles
mmhandleInputIndex = find(strcmp(varargin, 'mmhandle'));
if isempty(mmhandleInputIndex)
    disp('*****');
    disp('Missing input argument. Pass in mmhandle');
    disp('*****');
    %delete(hObject);
else
    handles.mmhandle = varargin{mmhandleInputIndex+1};
end
% fix the aspect ratio of the axes to reflect the image size
myunits = get(0,'units');
set(0,'units','pixels');
Pix_SS = get(0,'screensize');
set(0,'units','characters');
Char_SS = get(0,'screensize');
ppChar = Pix_SS./Char_SS;
handles.ppChar = ppChar(3:4);
set(0,'units',myunits);

pixWidth = handles.mmhandle.core.getImageWidth;
pixHeight = handles.mmhandle.core.getImageHeight;

myPosition = get(handles.axes_imageLastTaken,'Position');
y_pixels = myPosition(4)*handles.ppChar(2);
x_pixels = y_pixels*pixWidth/pixHeight;
x_char = x_pixels/handles.ppChar(1);
myPosition(3) =  x_char;
set(handles.axes_imageLastTaken,'Position',myPosition);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SuperMDA_gui_imageLastTaken wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SuperMDA_gui_imageLastTaken_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
