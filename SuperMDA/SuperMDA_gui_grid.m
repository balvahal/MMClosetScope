function varargout = SuperMDA_gui_grid(varargin)
% SUPERMDA_GUI_GRID MATLAB code for SuperMDA_gui_grid.fig
%      SUPERMDA_GUI_GRID, by itself, creates a new SUPERMDA_GUI_GRID or raises the existing
%      singleton*.
%
%      H = SUPERMDA_GUI_GRID returns the handle to a new SUPERMDA_GUI_GRID or the handle to
%      the existing singleton*.
%
%      SUPERMDA_GUI_GRID('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUPERMDA_GUI_GRID.M with the given input arguments.
%
%      SUPERMDA_GUI_GRID('Property','Value',...) creates a new SUPERMDA_GUI_GRID or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SuperMDA_gui_grid_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SuperMDA_gui_grid_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SuperMDA_gui_grid

% Last Modified by GUIDE v2.5 26-Feb-2014 14:41:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SuperMDA_gui_grid_OpeningFcn, ...
    'gui_OutputFcn',  @SuperMDA_gui_grid_OutputFcn, ...
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


% --- Executes just before SuperMDA_gui_grid is made visible.
function SuperMDA_gui_grid_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SuperMDA_gui_grid (see VARARGIN)

% Choose default command line output for SuperMDA_gui_grid
handles.output = hObject;

% add the main figure handles to the current figure handles
guiMainInputIndex = find(strcmp(varargin, 'gui_main'));
handles.gui_main = varargin{guiMainInputIndex+1};
mainHandles = guidata(handles.gui_main);
handles.mm = mainHandles.mm;
% remember the current figure handles
handles.gui_self = hObject;
% initialize the variables the grid making function
handles.number_of_images = [];
handles.number_of_columns = [];
handles.number_of_rows = [];
handles.centroid = [];
handles.upper_left_corner = [];
handles.lower_right_corner = [];
handles.overlap = 0;
handles.overlap_x = 0;
handles.overlap_y = 0;
handles.overlap_units = 'px';
handles.path_strategy = 'snake';
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SuperMDA_gui_grid wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SuperMDA_gui_grid_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox_numRow.
function checkbox_numRow_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_numRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_numRow


% --- Executes on button press in checkbox_cen.
function checkbox_cen_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_cen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_cen


% --- Executes on button press in checkbox_ulc.
function checkbox_ulc_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_ulc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ulc


% --- Executes on button press in checkbox_lrc.
function checkbox_lrc_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_lrc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_lrc


% --- Executes on button press in checkbox_numCol.
function checkbox_numCol_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_numCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_numCol


% --- Executes on button press in checkbox_numIm.
function checkbox_numIm_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_numIm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_numIm



function edit_numIm_Callback(hObject, eventdata, handles)
% hObject    handle to edit_numIm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_numIm as text
%        str2double(get(hObject,'String')) returns contents of edit_numIm as a double
mynum = str2double(get(hObject,'String'));
handles.number_of_images = mynum;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_numIm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_numIm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_numRow_Callback(hObject, eventdata, handles)
% hObject    handle to edit_numRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_numRow as text
%        str2double(get(hObject,'String')) returns contents of edit_numRow as a double
mynum = str2double(get(hObject,'String'));
handles.number_of_rows = mynum;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_numRow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_numRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_numCol_Callback(hObject, eventdata, handles)
% hObject    handle to edit_numCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_numCol as text
%        str2double(get(hObject,'String')) returns contents of edit_numCol as a double
mynum = str2double(get(hObject,'String'));
handles.number_of_columns = mynum;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_numCol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_numCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_snake.
function radiobutton_snake_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_snake (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_snake



function edit_overlapX_Callback(hObject, eventdata, handles)
% hObject    handle to edit_overlapX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_overlapX as text
%        str2double(get(hObject,'String')) returns contents of edit_overlapX as a double
mynum = str2double(get(hObject,'String'));
handles.overlap_x = mynum;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_overlapX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_overlapX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_overlapY_Callback(hObject, eventdata, handles)
% hObject    handle to edit_overlapY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_overlapY as text
%        str2double(get(hObject,'String')) returns contents of edit_overlapY as a double
mynum = str2double(get(hObject,'String'));
handles.overlap_y = mynum;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_overlapY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_overlapY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_cenY_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cenY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cenY as text
%        str2double(get(hObject,'String')) returns contents of edit_cenY as a double
mynum = str2double(get(hObject,'String'));
handles.centroid(2) = mynum;
set(handles.edit_cenY,'String',num2str(handles.centroid(2)));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_cenY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cenY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_cenZ_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cenZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cenZ as text
%        str2double(get(hObject,'String')) returns contents of edit_cenZ as a double
mynum = str2double(get(hObject,'String'));
handles.centroid(3) = mynum;
set(handles.edit_cenZ,'String',num2str(handles.centroid(3)));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_cenZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cenZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_cenX_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cenX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cenX as text
%        str2double(get(hObject,'String')) returns contents of edit_cenX as a double
mynum = str2double(get(hObject,'String'));
handles.centroid(1) = mynum;
set(handles.edit_cenX,'String',num2str(handles.centroid(1)));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_cenX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cenX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_setCEN.
function pushbutton_setCEN_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_setCEN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.centroid = handles.mm.getXYZ;
set(handles.edit_ulcX,'String',num2str(handles.centroid(1)));
set(handles.edit_ulcY,'String',num2str(handles.centroid(2)));
set(handles.edit_ulcZ,'String',num2str(handles.centroid(3)));
guidata(hObject, handles);

% --- Executes on button press in pushbutton_gotoCEN.
function pushbutton_gotoCEN_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_gotoCEN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mm.setXYZ(handles.centroid);


function edit_lrcY_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lrcY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lrcY as text
%        str2double(get(hObject,'String')) returns contents of edit_lrcY as a double
mynum = str2double(get(hObject,'String'));
handles.upper_left_corner(2) = mynum;
set(handles.edit_lrcY,'String',num2str(handles.lower_right_corner(2)));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_lrcY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lrcY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_lrcZ_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lrcZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lrcZ as text
%        str2double(get(hObject,'String')) returns contents of edit_lrcZ as a double
mynum = str2double(get(hObject,'String'));
handles.upper_left_corner(3) = mynum;
set(handles.edit_lrcZ,'String',num2str(handles.lower_right_corner(3)));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_lrcZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lrcZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_lrcX_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lrcX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lrcX as text
%        str2double(get(hObject,'String')) returns contents of edit_lrcX as a double
mynum = str2double(get(hObject,'String'));
handles.upper_left_corner(1) = mynum;
set(handles.edit_lrcX,'String',num2str(handles.lower_right_corner(1)));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_lrcX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lrcX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_setLRC.
function pushbutton_setLRC_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_setLRC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.lower_right_corner = handles.mm.getXYZ;
set(handles.edit_lrcX,'String',num2str(handles.lower_right_corner(1)));
set(handles.edit_lrcY,'String',num2str(handles.lower_right_corner(2)));
set(handles.edit_lrcZ,'String',num2str(handles.lower_right_corner(3)));
guidata(hObject, handles);

% --- Executes on button press in pushbutton_gotoLRC.
function pushbutton_gotoLRC_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_gotoLRC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mm.setXYZ(handles.lower_right_corner);

% --- Executes on button press in pushbutton_gotoULC.
function pushbutton_gotoULC_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_gotoULC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mm.setXYZ(handles.upper_left_corner);

% --- Executes on button press in pushbutton_setULC.
function pushbutton_setULC_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_setULC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.upper_left_corner = handles.mm.getXYZ;
set(handles.edit_ulcX,'String',num2str(handles.upper_left_corner(1)));
set(handles.edit_ulcY,'String',num2str(handles.upper_left_corner(2)));
set(handles.edit_ulcZ,'String',num2str(handles.upper_left_corner(3)));
guidata(hObject, handles);

function edit_ulcX_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ulcX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ulcX as text
%        str2double(get(hObject,'String')) returns contents of edit_ulcX as a double
mynum = str2double(get(hObject,'String'));
handles.upper_left_corner(1) = mynum;
set(handles.edit_ulcX,'String',num2str(handles.upper_left_corner(1)));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_ulcX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ulcX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ulcZ_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ulcZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ulcZ as text
%        str2double(get(hObject,'String')) returns contents of edit_ulcZ as a double
mynum = str2double(get(hObject,'String'));
handles.upper_left_corner(3) = mynum;
set(handles.edit_ulcZ,'String',num2str(handles.upper_left_corner(3)));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_ulcZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ulcZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ulcY_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ulcY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ulcY as text
%        str2double(get(hObject,'String')) returns contents of edit_ulcY as a double
mynum = str2double(get(hObject,'String'));
handles.upper_left_corner(2) = mynum;
set(handles.edit_ulcY,'String',num2str(handles.upper_left_corner(2)));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_ulcY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ulcY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_makegrid.
function pushbutton_makegrid_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_makegrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
methodname = get(get(handles.uipanel_methods,'SelectedObject'),'Tag');
mypositions = [];
switch methodname
    case 'radiobutton_case4'
        mypositions = super_mda_grid_maker(handles.mm,'upper_left_corner',handles.upper_left_corner,...
            'lower_right_corner',handles.lower_right_corner,...
            'overlap_x',handles.overlap_x,'overlap_y',handles.overlap_y,'path_strategy',handles.path_strategy,'overlap_units',handles.overlap_units);
    case 'radiobutton_case25'
        mypositions = super_mda_grid_maker(handles.mm,'lower_right_corner',handles.lower_right_corner,...
            'number_of_columns',handles.number_of_columns,...
            'number_of_rows',handles.number_of_rows,...
            'overlap_x',handles.overlap_x,'overlap_y',handles.overlap_y,'path_strategy',handles.path_strategy,'overlap_units',handles.overlap_units);
    case 'radiobutton_case26'
        mypositions = super_mda_grid_maker(handles.mm,'upper_left_corner',handles.upper_left_corner,...
            'number_of_columns',handles.number_of_columns,...
            'number_of_rows',handles.number_of_rows,...
            'overlap_x',handles.overlap_x,'overlap_y',handles.overlap_y,'path_strategy',handles.path_strategy,'overlap_units',handles.overlap_units);
    case 'radiobutton_case28'
        mypositions = super_mda_grid_maker(handles.mm,'centroid',handles.centroid,...
            'number_of_columns',handles.number_of_columns,...
            'number_of_rows',handles.number_of_rows,...
            'overlap_x',handles.overlap_x,'overlap_y',handles.overlap_y,'path_strategy',handles.path_strategy,'overlap_units',handles.overlap_units);
    case 'radiobutton_case33'
        mypositions = super_mda_grid_maker(handles.mm,'lower_right_corner',handles.lower_right_corner,...
            'number_of_images',handles.number_of_images,...
            'overlap_x',handles.overlap_x,'overlap_y',handles.overlap_y,'path_strategy',handles.path_strategy,'overlap_units',handles.overlap_units);
    case 'radiobutton_case34'
        mypositions = super_mda_grid_maker(handles.mm,'upper_left_corner',handles.upper_left_corner,...
            'number_of_images',handles.number_of_images,...
            'overlap_x',handles.overlap_x,'overlap_y',handles.overlap_y,'path_strategy',handles.path_strategy,'overlap_units',handles.overlap_units);
    case 'radiobutton_case35'
        mypositions = super_mda_grid_maker(handles.mm,'upper_left_corner',handles.upper_left_corner,...
            'lower_right_corner',handles.lower_right_corner,...
            'number_of_images',handles.number_of_images,...
            'overlap_x',handles.overlap_x,'overlap_y',handles.overlap_y,'path_strategy',handles.path_strategy,'overlap_units',handles.overlap_units);
    case 'radiobutton_case36'
        mypositions = super_mda_grid_maker(handles.mm,'centroid',handles.centroid,...
            'number_of_images',handles.number_of_images,...
            'overlap_x',handles.overlap_x,'overlap_y',handles.overlap_y,'path_strategy',handles.path_strategy,'overlap_units',handles.overlap_units);
end
mainHandles = guidata(handles.gui_main);
guidata(hObject, handles)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
%delete(hObject);
set(hObject,'visible','off');


% --- Executes when selected object is changed in uipanel_overlapUnits.
function uipanel_overlapUnits_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_overlapUnits
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'radiobutton_overlapUm'
        handles.overlap_units = 'um';
    case 'radiobutton_overlapPx'
        handles.overlap_units = 'px';
end
guidata(hObject, handles);

% --- Executes when selected object is changed in uipanel_pathStrategy.
function uipanel_pathStrategy_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_pathStrategy
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'radiobutton_snake'
        handles.path_strategy = 'snake';
    case 'radiobutton_crlf'
        handles.path_strategy = 'CRLF';
end
guidata(hObject, handles);


% --- Executes when selected object is changed in uipanel_methods.
function uipanel_methods_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_methods
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'radiobutton_case4'
        
    case 'radiobutton_case25'
        
    case 'radiobutton_case26'
        
    case 'radiobutton_case28'
        
    case 'radiobutton_case33'
        
    case 'radiobutton_case34'
        
    case 'radiobutton_case36'
        
    case 'radiobutton_case35'
end
guidata(hObject, handles)
