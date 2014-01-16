function varargout = SuperMDA_gui_main(varargin)
% SUPERMDA_FIGURE_MAIN MATLAB code for SuperMDA_figure_main.fig
%      SUPERMDA_FIGURE_MAIN, by itself, creates a new SUPERMDA_FIGURE_MAIN
%      or raises the existing singleton*.
%
%      H = SUPERMDA_FIGURE_MAIN returns the handle to a new
%      SUPERMDA_FIGURE_MAIN or the handle to the existing singleton*.
%
%      SUPERMDA_FIGURE_MAIN('CALLBACK',hObject,eventData,handles,...) calls
%      the local function named CALLBACK in SUPERMDA_FIGURE_MAIN.M with the
%      given input arguments.
%
%      SUPERMDA_FIGURE_MAIN('Property','Value',...) creates a new
%      SUPERMDA_FIGURE_MAIN or raises the existing singleton*.  Starting
%      from the left, property value pairs are applied to the GUI before
%      SuperMDA_figure_main_OpeningFcn gets called.  An unrecognized
%      property name or invalid value makes property application stop.  All
%      inputs are passed to SuperMDA_figure_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SuperMDA_figure_main

% Last Modified by GUIDE v2.5 16-Jan-2014 03:50:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SuperMDA_figure_main_OpeningFcn, ...
    'gui_OutputFcn',  @SuperMDA_figure_main_OutputFcn, ...
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


% --- Executes just before SuperMDA_figure_main is made visible.
function SuperMDA_figure_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn. hObject    handle to
% figure eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA) varargin
% command line arguments to SuperMDA_figure_main (see VARARGIN)

% Choose default command line output for SuperMDA_figure_main
handles.output = hObject;

% Remember the figure that encompasses the gui
handles.gui_main = hObject;

% add mmhandle to the main figure handles
mmhandleInputIndex = find(strcmp(varargin, 'mmhandle'));
if isempty(mmhandleInputIndex)
    disp('*****');
    disp('Missing input argument. Pass in mmhandle');
    disp('*****');
    %delete(hObject);
else
    handles.mmhandle = varargin{mmhandleInputIndex+1};
end
% ----- Variables
%
%
handles.SuperMDA_index = [1,1,1]; %[group, position, setting]
handles.primary_timepoints_UoT = get(handles.popupmenu_primary_time_points_units_of_time,'Value'); %this variable must be set, so the prior value is known when a conversion is requested.
% ----- Function Handles
%
%
handles.updateInfo = @main_updateInfo;
handles.load_super_mda = @main_load_super_mda;

% initialize a SuperMDA object
handles.mmhandle.SuperMDA = SuperMDALevel1Primary(handles.mmhandle);
handles.mmhandle.SuperMDA.output_directory = pwd;
% Update handles structure to reflect the new variables and functions
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);
% SCAN6gui_main.fig is the parent gui. Launch the children guis and send
% the parent gui object to each child gui.
handles.gui_grid = SuperMDA_gui_grid('gui_main',handles.gui_main);
set(handles.gui_grid,'visible','off'); % initially hide this gui from the user
%handles.gui_stageMap = SCAN6gui_stageMap('gui_main',handles.gui_main);
%handles.gui_stage_list; handles.gui_custom_timepoints;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SuperMDA_figure_main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SuperMDA_figure_main_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT); hObject
% handle to figure eventdata  reserved - to be defined in a future version
% of MATLAB handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox_primary.
function listbox_primary_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_primary (see GCBO) eventdata  reserved - to
% be defined in a future version of MATLAB handles    structure with
% handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_primary
% contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        listbox_primary


% --- Executes during object creation, after setting all properties.
function listbox_primary_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_primary (see GCBO) eventdata  reserved - to
% be defined in a future version of MATLAB handles    empty - handles not
% created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in
% popupmenu_primary_time_points_units_of_time.
function popupmenu_primary_time_points_units_of_time_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_primary_time_points_units_of_time (see
% GCBO) eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
units_of_time_conversion = [1, 1/60, 1/3600, 1/86400;... % from seconds to
    60, 1, 1/60, 1/1440;... % from minutes to
    3600, 60, 1, 1/24;... % from hours to
    86400, 1440, 24, 1]; % from days to
my_value = handles.mmhandle.SuperMDA.fundamental_period;
my_value = my_value*units_of_time_conversion(1,get(hObject,'Value'));
set(handles.edit_primary_time_points_period,'String',num2str(my_value));

my_value = handles.mmhandle.SuperMDA.duration;
my_value = my_value*units_of_time_conversion(1,get(hObject,'Value'));
set(handles.edit_primary_time_points_duration,'String',num2str(my_value));
handles.primary_timepoints_UoT = get(hObject,'Value');
% Update handles structure
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns
% popupmenu_primary_time_points_units_of_time contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        popupmenu_primary_time_points_units_of_time


% --- Executes during object creation, after setting all properties.
function popupmenu_primary_time_points_units_of_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_primary_time_points_units_of_time (see
% GCBO) eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_primary_time_points_period_Callback(hObject, eventdata, handles)
% hObject    handle to edit_primary_time_points_period (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of
% edit_primary_time_points_period as text
%        str2double(get(hObject,'String')) returns contents of
%        edit_primary_time_points_period as a double
units_of_time_conversion = [1, 1/60, 1/3600, 1/86400;... % from seconds to
    60, 1, 1/60, 1/1440;... % from minutes to
    3600, 60, 1, 1/24;... % from hours to
    86400, 1440, 24, 1]; % from days to
my_value = str2double(get(hObject,'String'));
my_value = my_value*units_of_time_conversion(get(handles.popupmenu_primary_time_points_units_of_time,'Value'),1);
handles.mmhandle.SuperMDA.fundamental_period = my_value;

%my_value =
%handles.mmhandle.SuperMDA.duration*units_of_time_conversion(1,get(handles.popupmenu_primary_time_points_units_of_time,'Value'));
%set(handles.edit_primary_time_points_duration,'String',num2str(my_value));

% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);

% --- Executes during object creation, after setting all properties.
function edit_primary_time_points_period_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_primary_time_points_period (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles    empty -
% handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_primary_time_points_duration_Callback(hObject, eventdata, handles)
% hObject    handle to edit_primary_time_points_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB handles
% structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of
% edit_primary_time_points_duration as text
%        str2double(get(hObject,'String')) returns contents of
%        edit_primary_time_points_duration as a double
units_of_time_conversion = [1, 1/60, 1/3600, 1/86400;... % from seconds to
    60, 1, 1/60, 1/1440;... % from minutes to
    3600, 60, 1, 1/24;... % from hours to
    86400, 1440, 24, 1]; % from days to
my_value = str2double(get(hObject,'String'));
my_value = my_value*units_of_time_conversion(get(handles.popupmenu_primary_time_points_units_of_time,'Value'),1);
handles.mmhandle.SuperMDA.duration = my_value;
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);


% --- Executes during object creation, after setting all properties.
function edit_primary_time_points_duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_primary_time_points_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB handles
% empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_time_points_customize.
function pushbutton_time_points_customize_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_time_points_customize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB handles
% structure with handles and user data (see GUIDATA)

% A PLACE FOR FUNCTIONS!!!
%
%
%%%%%%%%%%%
%
%
%%%%%%%%%%%

% --- Updates the information displayed on the main figure whenever the
% sampleIndex is changed
function main_load_super_mda(hObject)
% hObject   handle to the main figure
handles = guidata(hObject);

if handles.sampleInfo(handles.sampleIndex).isMaxImages
    set(handles.checkboxMaxImages,'Value',get(handles.checkboxMaxImages,'Max'));
else
    set(handles.checkboxMaxImages,'Value',get(handles.checkboxMaxImages,'Min'));
end

% --- Updates the information displayed on the main figure whenever the
% sampleIndex is changed
function main_updateInfo(hObject)
% hObject   handle to the main figure primary time points
handles = guidata(hObject);
units_of_time_conversion = [1, 1/60, 1/3600, 1/86400;... % from seconds to
    60, 1, 1/60, 1/1440;... % from minutes to
    3600, 60, 1, 1/24;... % from hours to
    86400, 1440, 24, 1]; % from days to
% edit_primary_time_points_duration
my_value = handles.mmhandle.SuperMDA.duration*units_of_time_conversion(1,get(handles.popupmenu_primary_time_points_units_of_time,'Value'));
set(handles.edit_primary_time_points_duration,'String',num2str(my_value));
% edit_primary_numberOfTmpts
set(handles.edit_primary_numberOfTmpts,'String',num2str(handles.mmhandle.SuperMDA.number_of_timepoints));
% edit_primary_outputDirectory
set(handles.edit_primary_outputDirectory,'String',handles.mmhandle.SuperMDA.output_directory);
% edit_group_travel_offset
set(handles.edit_group_travel_offset,'String',num2str(handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).travel_offset));
% uitable_group
if isempty(handles.mmhandle.SuperMDA.group_order) || ...
        ~isempty(setdiff(handles.mmhandle.SuperMDA.group_order,(1:handles.mmhandle.SuperMDA.my_length))) || ...
        length(handles.mmhandle.SuperMDA.group_order)~=handles.mmhandle.SuperMDA.my_length
    handles.mmhandle.SuperMDA.group_order = (1:handles.mmhandle.SuperMDA.my_length);
end
uitable_group_cell = cell(handles.mmhandle.SuperMDA.my_length,6);
j=1;
for i=handles.mmhandle.SuperMDA.group_order
    uitable_group_cell(j,1) = handles.mmhandle.SuperMDA.group(i).label;
    uitable_group_cell(j,2) = handles.mmhandle.SuperMDA.group(i).travel_offset;
    uitable_group_cell(j,3) = handles.mmhandle.SuperMDA.group(i).my_length;
    uitable_group_cell(j,4) = handles.mmhandle.SuperMDA.group(i).group_function_before_name;
    uitable_group_cell(j,5) = handles.mmhandle.SuperMDA.group(i).group_function_after_name;
    uitable_group_cell(j,6) = i;
    j=j+1;
end
set(handles.uitable_group,'Data',uitable_group_cell);
%%%%%%%%%%% %%%%%%%%%%%
% % %
%%%%%%%%%%% %%%%%%%%%%%
% % %
%%%%%%%%%%% %%%%%%%%%%%


% --- Executes on button press in pushbutton_primary_load_mda.
function pushbutton_primary_load_mda_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_primary_load_mda (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)
uiwait(warndlg('The current SuperMDA will be erased!','Load a SuperMDA','modal'));
mypwd = pwd;
cd(handles.mmhandle.SuperMDA.output_directory);
[filename,pathname] = uigetfile({'*.mat'},'Load a SuperMDA');
if exist(fullfile(pathname,filename),'file')
    load(fullfile(pathname,filename),'SuperMDA');
    handles.mmhandle.SuperMDA = SuperMDA;
else
    disp('The SuperMDA file selected was invalid.');
end
cd(mypwd);
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);

function edit_primary_outputDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to edit_primary_outputDirectory (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of
% edit_primary_outputDirectory as text
%        str2double(get(hObject,'String')) returns contents of
%        edit_primary_outputDirectory as a double
folder_name = get(hObject,'String');
if exist(folder_name,'dir')
    handles.mmhandle.SuperMDA.output_directory = folder_name;
else
    str = sprintf('''%s'' is not a directory',folder_name);
    disp(str);
    set(hObject,'String',fullfile(folder_name,'not a valid dir'));
    return;
end
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);

% --- Executes during object creation, after setting all properties.
function edit_primary_outputDirectory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_primary_outputDirectory (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles    empty -
% handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_find_output_dir.
function pushbutton_find_output_dir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_find_output_dir (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)
folder_name = uigetdir;
if exist(folder_name,'dir')
    handles.mmhandle.SuperMDA.output_directory = folder_name;
else
    str = sprintf('''%s'' is not a directory',foldername);
    disp(str);
    return;
end
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);

function edit_primary_numberOfTmpts_Callback(hObject, eventdata, handles)
% hObject    handle to edit_primary_numberOfTmpts (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of
% edit_primary_numberOfTmpts as text
%        str2double(get(hObject,'String')) returns contents of
%        edit_primary_numberOfTmpts as a double
my_value = str2double(get(hObject,'String'));
if my_value < 1
    my_value = 1;
end
handles.mmhandle.SuperMDA.duration = (my_value-1)*handles.mmhandle.SuperMDA.fundamental_period;
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);

% --- Executes during object creation, after setting all properties.
function edit_primary_numberOfTmpts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_primary_numberOfTmpts (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles    empty -
% handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_group_add.
function pushbutton_group_add_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_group_add (see GCBO) eventdata  reserved
% - to be defined in a future version of MATLAB handles    structure with
% handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_group_drop.
function pushbutton_group_drop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_group_drop (see GCBO) eventdata  reserved
% - to be defined in a future version of MATLAB handles    structure with
% handles and user data (see GUIDATA)



function edit_group_functionBefore_Callback(hObject, eventdata, handles)
% hObject    handle to edit_group_functionBefore (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of
% edit_group_functionBefore as text
%        str2double(get(hObject,'String')) returns contents of
%        edit_group_functionBefore as a double


% --- Executes during object creation, after setting all properties.
function edit_group_functionBefore_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_group_functionBefore (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles    empty -
% handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_group_findBeforeFunction.
function pushbutton_group_findBeforeFunction_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_group_findBeforeFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB handles
% structure with handles and user data (see GUIDATA)
mypwd = pwd;
cd(handles.mmhandle.SuperMDA.output_directory);
[filename,pathname] = uigetfile({'*.m'},'Choose the group-function-before');
if exist(fullfile(pathname,filename),'file')
    handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).group_function_before_name = regexp(filename,'.*(?=\.m)','match');
else
    disp('The group-function-before selection was invalid.');
end
cd(mypwd);
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);


function edit_group_function_after_Callback(hObject, eventdata, handles)
% hObject    handle to edit_group_function_after (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of
% edit_group_function_after as text
%        str2double(get(hObject,'String')) returns contents of
%        edit_group_function_after as a double


% --- Executes during object creation, after setting all properties.
function edit_group_function_after_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_group_function_after (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles    empty -
% handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_group_findAfterFunction.
function pushbutton_group_findAfterFunction_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_group_findAfterFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB handles
% structure with handles and user data (see GUIDATA)
mypwd = pwd;
cd(handles.mmhandle.SuperMDA.output_directory);
[filename,pathname] = uigetfile({'*.m'},'Choose the group-function-after');
if exist(fullfile(pathname,filename),'file')
    handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).group_function_after_name = regexp(filename,'.*(?=\.m)','match');
else
    disp('The group-function-before selection was invalid.');
end
cd(mypwd);
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);



function edit_group_travel_offset_Callback(hObject, eventdata, handles)
% hObject    handle to edit_group_travel_offset (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_group_travel_offset
% as text
%        str2double(get(hObject,'String')) returns contents of
%        edit_group_travel_offset as a double
my_travelOffset = str2double(get(hObject,'String'));
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).travel_offset = my_travelOffset;
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);

% --- Executes during object creation, after setting all properties.
function edit_group_travel_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_group_travel_offset (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles    empty -
% handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_position_Add.
function pushbutton_position_Add_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_position_Add (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_position_drop.
function pushbutton_position_drop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_position_drop (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_position_addGrid.
function pushbutton_position_addGrid_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_position_addGrid (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)
set(handles.gui_grid,'visible','on');


function edit_position__functionBefore_Callback(hObject, eventdata, handles)
% hObject    handle to edit_position__functionBefore (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of
% edit_position__functionBefore as text
%        str2double(get(hObject,'String')) returns contents of
%        edit_position__functionBefore as a double


% --- Executes during object creation, after setting all properties.
function edit_position__functionBefore_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_position__functionBefore (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles    empty -
% handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_position_findBeforeFunction.
function pushbutton_position_findBeforeFunction_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_position_findBeforeFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB handles
% structure with handles and user data (see GUIDATA)



function edit_position__functionAfter_Callback(hObject, eventdata, handles)
% hObject    handle to edit_position__functionAfter (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of
% edit_position__functionAfter as text
%        str2double(get(hObject,'String')) returns contents of
%        edit_position__functionAfter as a double


% --- Executes during object creation, after setting all properties.
function edit_position__functionAfter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_position__functionAfter (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles    empty -
% handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_position_findAfterFunction.
function pushbutton_position_findAfterFunction_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_position_findAfterFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB handles
% structure with handles and user data (see GUIDATA)


% --- Executes on button press in togglebutton_position_changeAll.
function togglebutton_position_changeAll_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_position_changeAll (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of
% togglebutton_position_changeAll


% --- Executes on button press in togglebutton_group_changeAll.
function togglebutton_group_changeAll_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_group_changeAll (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of
% togglebutton_group_changeAll


% --- Executes on button press in pushbutton_position_reset.
function pushbutton_position_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_position_reset (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_position_goto.
function pushbutton_position_goto_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_position_goto (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_position_moveUp.
function pushbutton_position_moveUp_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_position_moveUp (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_position_moveDown.
function pushbutton_position_moveDown_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_position_moveDown (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)


% --- Executes on button press in togglebutton_settings_changeAll.
function togglebutton_settings_changeAll_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_settings_changeAll (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of
% togglebutton_settings_changeAll



function edit_settings_function_Callback(hObject, eventdata, handles)
% hObject    handle to edit_settings_function (see GCBO) eventdata reserved
% - to be defined in a future version of MATLAB handles structure with
% handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_settings_function
% as text
%        str2double(get(hObject,'String')) returns contents of
%        edit_settings_function as a double


% --- Executes during object creation, after setting all properties.
function edit_settings_function_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_settings_function (see GCBO) eventdata reserved
% - to be defined in a future version of MATLAB handles    empty - handles
% not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_settings_findFunction.
function pushbutton_settings_findFunction_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_settings_findFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB handles
% structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_settings_add.
function pushbutton_settings_add_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_settings_add (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_settings_drop.
function pushbutton_settings_drop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_settings_drop (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_settings_moveUp.
function pushbutton_settings_moveUp_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_settings_moveUp (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_settings_moveDown.
function pushbutton_settings_moveDown_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_settings_moveDown (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_settings_pull.
function pushbutton_settings_pull_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_settings_pull (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_settings_push.
function pushbutton_settings_push_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_settings_push (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in pushbutton_position_copySettings1to1.
function pushbutton_position_copySettings1to1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_position_copySettings1to1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB handles
% structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_position_copySettings1toAll.
function pushbutton_position_copySettings1toAll_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_position_copySettings1toAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB handles
% structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2
% contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    empty - handles not
% created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)


% --- Executes on button press in pushbutton_primary_save_mda.
function pushbutton_primary_save_mda_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_primary_save_mda (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)
mypwd = pwd;
cd(handles.mmhandle.SuperMDA.output_directory);
SuperMDA = handles.mmhandle.SuperMDA;
[filename,pathname] = uiputfile({'*.mat'},'Save a SuperMDA','mySuperMDA.mat');
save(fullfile(pathname,filename),'SuperMDA');
cd(mypwd);


% --- Executes on button press in pushbutton_group_move_up.
function pushbutton_group_move_up_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_group_move_up (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles
% structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_group_move_down.
function pushbutton_group_move_down_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_group_move_down (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles
% structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_run_mfile.
function pushbutton_run_mfile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_run_mfile (see GCBO) eventdata  reserved
% - to be defined in a future version of MATLAB handles    structure with
% handles and user data (see GUIDATA)
