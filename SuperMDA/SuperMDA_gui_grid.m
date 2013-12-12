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

% Last Modified by GUIDE v2.5 11-Dec-2013 23:07:14

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
%guiMainInputIndex = find(strcmp(varargin, 'gui_main'));
%handles.gui_main = varargin{guiMainInputIndex+1};
%mainHandles = guidata(handles.gui_main);
% remember the current figure handles
handles.gui_self = hObject;

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



function edit_lrcY_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lrcY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lrcY as text
%        str2double(get(hObject,'String')) returns contents of edit_lrcY as a double


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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_ulcX_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ulcX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ulcX as text
%        str2double(get(hObject,'String')) returns contents of edit_ulcX as a double


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
