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

% Last Modified by GUIDE v2.5 21-Jan-2014 14:24:52

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
%%%%%%%%%%% %%%%%%%%%%%
% % %
%%%%%%%%%%% %%%%%%%%%%%
% % %
%%%%%%%%%%% %%%%%%%%%%%
% This is ALPHA version 0.1 of SuperMDA
%%%%%%%%%%% %%%%%%%%%%%
% % %
%%%%%%%%%%% %%%%%%%%%%%
% % %
%%%%%%%%%%% %%%%%%%%%%%
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
% update the settings table options
myColumnFormat = get(handles.uitable_settings,'ColumnFormat');
myColumnFormat{1} = handles.mmhandle.Channel';
set(handles.uitable_settings,'ColumnFormat',myColumnFormat);
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
%%%%%%%%%%% %%%%%%%%%%%
% % %
%%%%%%%%%%% %%%%%%%%%%%
% % %
%%%%%%%%%%% %%%%%%%%%%% %%%%%%%%%%%
% % %
%%%%%%%%%%% %%%%%%%%%%%
% % %
%%%%%%%%%%% %%%%%%%%%%% %%%%%%%%%%%
% % %
%%%%%%%%%%% %%%%%%%%%%%
% % %
%%%%%%%%%%% %%%%%%%%%%%

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
%%%
%%% PRIMARY
%%%
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
%%%
%%% GROUP
%%%
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
    uitable_group_cell{j,1} = handles.mmhandle.SuperMDA.group(i).label;
    uitable_group_cell{j,2} = i;
    if handles.mmhandle.SuperMDA.group(i).travel_offset_bool
        uitable_group_cell{j,3} = 'yes';
    else
        uitable_group_cell{j,3} = 'no';
    end
    uitable_group_cell{j,4} = handles.mmhandle.SuperMDA.group(i).my_length;
    uitable_group_cell{j,5} = handles.mmhandle.SuperMDA.group(i).group_function_before_name;
    uitable_group_cell{j,6} = handles.mmhandle.SuperMDA.group(i).group_function_after_name;
    j=j+1;
end
set(handles.uitable_group,'Data',uitable_group_cell);
%%%
%%% POSITION
%%%
% uitable_position
if isempty(handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position_order) || ...
        ~isempty(setdiff(handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position_order,(1:handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).my_length))) || ...
        length(handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position_order)~=handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).my_length
    handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position_order = (1:handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).my_length);
end
uitable_position_cell = cell(handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).my_length,10);
j=1;
for i=handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position_order
    uitable_position_cell{j,1} = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(i).label;
    uitable_position_cell{j,2} = i;
    if handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(i).continuous_focus_bool
        uitable_position_cell{j,3} = 'yes';
    else
        uitable_position_cell{j,3} = 'no';
    end
    uitable_position_cell{j,4} = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(i).xyz(1);
    uitable_position_cell{j,5} = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(i).xyz(2);
    uitable_position_cell{j,6} = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(i).xyz(3);
    uitable_position_cell{j,7} = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(i).continuous_focus_offset;
    uitable_position_cell{j,8} = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(i).position_function_before_name;
    uitable_position_cell{j,9} = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(i).position_function_after_name;
    uitable_position_cell{j,10} = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(i).my_length;
    j=j+1;
end
set(handles.uitable_position,'Data',uitable_position_cell);
%%%
%%% SETTINGS
%%%
if isempty(handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order) || ...
        ~isempty(setdiff(handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order,(1:handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).my_length))) || ...
        length(handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order)~=handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).my_length
    handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order = (1:handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).my_length);
end
uitable_settings_cell = cell(handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).my_length,11);
j=1;
for i=handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order
    uitable_settings_cell{j,1} = handles.mmhandle.Channel{handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings(i).channel};
    uitable_settings_cell{j,2} = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings(i).exposure(1);
    uitable_settings_cell{j,3} = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings(i).binning;
    uitable_settings_cell{j,4} = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings(i).z_step_size;
    uitable_settings_cell{j,5} = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings(i).z_stack_upper_offset;
    uitable_settings_cell{j,6} = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings(i).z_stack_lower_offset;
    uitable_settings_cell{j,7} = length(handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings(i).z_stack);
    uitable_settings_cell{j,8} = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings(i).z_origin_offset;
    uitable_settings_cell{j,9} = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings(i).period_multiplier;
    uitable_settings_cell{j,10} = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings(i).settings_function_name;
    uitable_settings_cell{j,11} = i;
    j=j+1;
end
set(handles.uitable_settings,'Data',uitable_settings_cell);
%%%%%%%%%%% %%%%%%%%%%%
% % %
%%%%%%%%%%% %%%%%%%%%%%
% % %
%%%%%%%%%%% %%%%%%%%%%% %%%%%%%%%%%
% % %
%%%%%%%%%%% %%%%%%%%%%%
% % %
%%%%%%%%%%% %%%%%%%%%%% %%%%%%%%%%%
% % %
%%%%%%%%%%% %%%%%%%%%%%
% % %
%%%%%%%%%%% %%%%%%%%%%% %%%%%%%%%%%
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
handles.mmhandle.SuperMDA.new_group;
if handles.mmhandle.SuperMDA.group(end).my_length > 1
    handles.mmhandle.SuperMDA.group(end).position(2:end) = [];
    handles.mmhandle = Core_general_getXYZ(handles.mmhandle);
    handles.mmhandle.SuperMDA.group(end).position(1).xyz = handles.mmhandle.pos;
    handles.mmhandle.SuperMDA.group(end).position(1).continuous_focus_offset = str2double(handles.mmhandle.core.getProperty(handles.mmhandle.AutoFocusDevice,'Position'));
end
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);


% --- Executes on button press in pushbutton_group_drop.
function pushbutton_group_drop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_group_drop (see GCBO) eventdata  reserved
% - to be defined in a future version of MATLAB handles    structure with
% handles and user data (see GUIDATA)
myRow = get(handles.uitable_group,'UserData');
myDat = get(handles.uitable_group,'Data');
if size(myDat,1) == 1
    return;
end
if size(myDat,1) == length(myRow)
    myRow(1) = [];
end
group_number = cell2mat(myDat(myRow,2));
handles.mmhandle.SuperMDA.group(group_number) = [];
my_group_order_number = sort(handles.mmhandle.SuperMDA.group_order(myRow));
handles.mmhandle.SuperMDA.group_order(myRow) = [];
my_adjustment = zeros(size(handles.mmhandle.SuperMDA.group_order));
for i = 1:length(my_group_order_number)
    my_logic = handles.mmhandle.SuperMDA.group_order > my_group_order_number(i);
    my_adjustment = my_adjustment+ones(size(handles.mmhandle.SuperMDA.group_order))*-1.*my_logic;
end
handles.mmhandle.SuperMDA.group_order = handles.mmhandle.SuperMDA.group_order + my_adjustment;
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);

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
    handles.mmhandle.SuperMDA.change_all_group('group_function_before_name',regexp(filename,'.*(?=\.m)','match'));
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
    handles.mmhandle.SuperMDA.change_all_group('group_function_after_name',regexp(filename,'.*(?=\.m)','match'));
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
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).new_position(handles.mmhandle);
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);

% --- Executes on button press in pushbutton_position_drop.
function pushbutton_position_drop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_position_drop (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)
myRow = get(handles.uitable_position,'UserData');
myDat = get(handles.uitable_position,'Data');
if size(myDat,1) == 1
    return;
end
if size(myDat,1) == length(myRow)
    myRow(1) = [];
end
position_number = cell2mat(myDat(myRow,2));
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(position_number) = [];
my_position_order_number = sort(handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position_order(myRow));
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position_order(myRow) = [];
my_adjustment = zeros(size(handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position_order));
for i = 1:length(my_position_order_number)
    my_logic = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position_order > my_position_order_number(i);
    my_adjustment = my_adjustment+ones(size(handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position_order))*-1.*my_logic;
end
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position_order = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position_order + my_adjustment;
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);

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
mypwd = pwd;
cd(handles.mmhandle.SuperMDA.output_directory);
[filename,pathname] = uigetfile({'*.m'},'Choose the position-function-before');
if exist(fullfile(pathname,filename),'file')
    handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).change_all_position('position_function_before_name',regexp(filename,'.*(?=\.m)','match'));
else
    disp('The position-function-before selection was invalid.');
end
cd(mypwd);
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);



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
mypwd = pwd;
cd(handles.mmhandle.SuperMDA.output_directory);
[filename,pathname] = uigetfile({'*.m'},'Choose the position-function-after');
if exist(fullfile(pathname,filename),'file')
    handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).change_all_position('position_function_after_name',regexp(filename,'.*(?=\.m)','match'));
else
    disp('The position-function-after selection was invalid.');
end
cd(mypwd);
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);

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


% --- Executes on button press in pushbutton_position_update.
function pushbutton_position_update_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_position_update (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)
handles.mmhandle = Core_general_getXYZ(handles.mmhandle);
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).xyz = handles.mmhandle.pos;
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).continuous_focus_offset = str2double(handles.mmhandle.core.getProperty(handles.mmhandle.AutoFocusDevice,'Position'));
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);

% --- Executes on button press in pushbutton_position_goto.
function pushbutton_position_goto_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_position_goto (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)
handles.mmhandle = Core_general_setXYZ(handles.mmhandle, handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).xyz);
guidata(hObject, handles);

% --- Executes on button press in pushbutton_position_moveUp.
function pushbutton_position_moveUp_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_position_moveUp (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)
myRow = get(handles.uitable_position,'UserData');
if length(myRow) > 1
    myRow = myRow(1);
end
myDat = get(handles.uitable_position,'Data');
if size(myDat,1) == 1 || myRow == 1
    return;
end
my_order = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position_order;
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position_order(myRow-1) = my_order(myRow);
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position_order(myRow) = my_order(myRow-1);
set(handles.uitable_position,'UserData',myRow-1);
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);

% --- Executes on button press in pushbutton_position_moveDown.
function pushbutton_position_moveDown_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_position_moveDown (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)
myRow = get(handles.uitable_position,'UserData');
if length(myRow) > 1
    myRow = myRow(1);
end
myDat = get(handles.uitable_position,'Data');
if size(myDat,1) == 1 || myRow == size(myDat,1);
    return;
end
my_group_order = handles.mmhandle.group(handles.SuperMDA_index(1)).position_order;
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position_order(myRow+1) = my_group_order(myRow);
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position_order(myRow) = my_group_order(myRow+1);
set(handles.uitable_position,'UserData',myRow+1);
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);

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
mypwd = pwd;
cd(handles.mmhandle.SuperMDA.output_directory);
[filename,pathname] = uigetfile({'*.m'},'Choose the settings-function');
if exist(fullfile(pathname,filename),'file')
    handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).change_all_settings('settings_function_name',regexp(filename,'.*(?=\.m)','match'));
else
    disp('The settings-function selection was invalid.');
end
cd(mypwd);
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);

% --- Executes on button press in pushbutton_settings_add.
function pushbutton_settings_add_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_settings_add (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).new_settings;
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).change_all_position('settings',handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings);
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).change_all_position('settings_order',handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order);
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);

% --- Executes on button press in pushbutton_settings_drop.
function pushbutton_settings_drop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_settings_drop (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)
myRow = get(handles.uitable_settings,'UserData');
myDat = get(handles.uitable_settings,'Data');
if size(myDat,1) == 1
    return;
end
if size(myDat,1) == length(myRow)
    myRow(1) = [];
end
my_number = cell2mat(myDat(myRow,11));
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings(my_number) = [];
my_order_number = sort(handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order(myRow));
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order(myRow) = [];
my_adjustment = zeros(size(handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order));
for i = 1:length(my_order_number)
    my_logic = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order > my_order_number(i);
    my_adjustment = my_adjustment+ones(size(handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order))*-1.*my_logic;
end
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order + my_adjustment;
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).change_all_position('settings',handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings);
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).change_all_position('settings_order',handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order);
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);

% --- Executes on button press in pushbutton_settings_moveUp.
function pushbutton_settings_moveUp_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_settings_moveUp (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)
myRow = get(handles.uitable_settings,'UserData');
if length(myRow) > 1
    myRow = myRow(1);
end
myDat = get(handles.uitable_settings,'Data');
if size(myDat,1) == 1 || myRow == 1
    return;
end
my_order = handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order;
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order(myRow-1) = my_order(myRow);
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order(myRow) = my_order(myRow-1);
set(handles.uitable_settings,'UserData',myRow-1);
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).change_all_position('settings_order',handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order);
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);

% --- Executes on button press in pushbutton_settings_moveDown.
function pushbutton_settings_moveDown_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_settings_moveDown (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)
myRow = get(handles.uitable_settings,'UserData');
if length(myRow) > 1
    myRow = myRow(1);
end
myDat = get(handles.uitable_settings,'Data');
if size(myDat,1) == 1 || myRow == size(myDat,1);
    return;
end
my_group_order = handles.mmhandle.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order;
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order(myRow+1) = my_group_order(myRow);
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order(myRow) = my_group_order(myRow+1);
set(handles.uitable_settings,'UserData',myRow+1);
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).change_all_position('settings_order',handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order);
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);


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


% --- Executes on button press in pushbutton_awesomeAppsLaunch.
function pushbutton_awesomeAppsLaunch_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_awesomeAppsLaunch (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles
% structure with handles and user data (see GUIDATA)


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
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)
myRow = get(handles.uitable_group,'UserData');
if length(myRow) > 1
    myRow = myRow(1);
end
myDat = get(handles.uitable_group,'Data');
if size(myDat,1) == 1 || myRow == 1
    return;
end
my_group_order = handles.mmhandle.SuperMDA.group_order;
handles.mmhandle.SuperMDA.group_order(myRow-1) = my_group_order(myRow);
handles.mmhandle.SuperMDA.group_order(myRow) = my_group_order(myRow-1);
set(handles.uitable_group,'UserData',myRow-1);
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);


% --- Executes on button press in pushbutton_group_move_down.
function pushbutton_group_move_down_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_group_move_down (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles structure
% with handles and user data (see GUIDATA)
myRow = get(handles.uitable_group,'UserData');
if length(myRow) > 1
    myRow = myRow(1);
end
myDat = get(handles.uitable_group,'Data');
if size(myDat,1) == 1 || myRow == size(myDat,1);
    return;
end
my_group_order = handles.mmhandle.SuperMDA.group_order;
handles.mmhandle.SuperMDA.group_order(myRow+1) = my_group_order(myRow);
handles.mmhandle.SuperMDA.group_order(myRow) = my_group_order(myRow+1);
set(handles.uitable_group,'UserData',myRow+1);
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);

% --- Executes on button press in pushbutton_run_mfile.
function pushbutton_run_mfile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_run_mfile (see GCBO) eventdata  reserved
% - to be defined in a future version of MATLAB handles    structure with
% handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in uitable_group.
function uitable_group_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable_group (see GCBO) eventdata  structure with
% the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited PreviousData:
%	previous data for the cell(s) edited EditData: string(s) entered by the
%	user NewData: EditData or its converted form set on the Data property.
%	Empty if Data was not changed Error: error string when failed to
%	convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
myCol = eventdata.Indices(2);
myRow = eventdata.Indices(1);
myDat = get(handles.uitable_group,'Data');
group_number = myDat{myRow,2};
switch myCol
    case 1
        handles.mmhandle.SuperMDA.group(group_number).label = eventdata.NewData;
    case 3
        if strcmp(eventdata.NewData,'yes')
            handles.mmhandle.SuperMDA.group(group_number).travel_offset_bool=true;
        else
            handles.mmhandle.SuperMDA.group(group_number).travel_offset_bool=false;
        end
end
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);


% --- Executes when selected cell(s) is changed in uitable_group.
function uitable_group_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable_group (see GCBO) eventdata  structure with
% the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)\
myVal = get(hObject,'UserData');
% eventdata.Indices is empty when the data in the uigroup is changed
if isempty(eventdata.Indices) && (min(myVal) > size(get(handles.uitable_group,'Data'),1))
    myInd = size(get(handles.uitable_group,'Data'),1);
    set(hObject,'UserData',myInd);
elseif isempty(eventdata.Indices)
    if length(myVal) > 1
        myInd = min(myVal);
    else
        myInd = myVal;
    end
else
    myInd = unique(eventdata.Indices(:,1));
    set(hObject,'UserData',myInd);
    if length(myInd)>1
        myInd = myInd(1);
    end
end
handles.SuperMDA_index(1) = myInd;
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);


% --- Executes on button press in pushbutton_settings_setZUpper.
function pushbutton_settings_setZUpper_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_settings_setZUpper (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles
% structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_settings_setZLower.
function pushbutton_settings_setZLower_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_settings_setZLower (see GCBO) eventdata
% reserved - to be defined in a future version of MATLAB handles
% structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uitable_group_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable_group (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    empty - handles not
% created until after all CreateFcns called
set(hObject,'UserData',1);


% --- Executes when selected cell(s) is changed in uitable_position.
function uitable_position_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable_position (see GCBO) eventdata  structure
% with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
myVal = get(hObject,'UserData');
% eventdata.Indices is empty when the data in the uigroup is changed
if isempty(eventdata.Indices) && (min(myVal) > size(get(handles.uitable_position,'Data'),1))
    myInd = size(get(handles.uitable_position,'Data'),1);
    set(hObject,'UserData',myInd);
elseif isempty(eventdata.Indices)
    if length(myVal) > 1
        myInd = min(myVal);
    else
        myInd = myVal;
    end
else
    myInd = unique(eventdata.Indices(:,1));
    set(hObject,'UserData',myInd);
    if length(myInd)>1
        myInd = myInd(1);
    end
end
handles.SuperMDA_index(2) = myInd;
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);

% --- Executes during object creation, after setting all properties.
function uitable_position_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable_position (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'UserData',1);


% --- Executes during object creation, after setting all properties.
function uitable_settings_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable_settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'UserData',1);

% --- Executes when selected cell(s) is changed in uitable_settings.
function uitable_settings_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable_settings (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
myVal = get(hObject,'UserData');
% eventdata.Indices is empty when the data in the uigroup is changed
if isempty(eventdata.Indices) && (min(myVal) > size(get(handles.uitable_settings,'Data'),1))
    myInd = size(get(handles.uitable_settings,'Data'),1);
    set(hObject,'UserData',myInd);
elseif isempty(eventdata.Indices)
    if length(myVal) > 1
        myInd = min(myVal);
    else
        myInd = myVal;
    end
else
    myInd = unique(eventdata.Indices(:,1));
    set(hObject,'UserData',myInd);
    if length(myInd)>1
        myInd = myInd(1);
    end
end
handles.SuperMDA_index(3) = myInd;
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);


% --- Executes when entered data in editable cell(s) in uitable_position.
function uitable_position_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable_position (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
myCol = eventdata.Indices(2);
myRow = eventdata.Indices(1);
myDat = get(handles.uitable_position,'Data');
position_number = myDat{myRow,2};
switch myCol
    case 1
        handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(position_number).label = eventdata.NewData;
    case 3
        if strcmp(eventdata.NewData,'yes')
            handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(position_number).continuous_focus_bool=true;
        else
            handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(position_number).continuous_focus_bool=false;
        end
    case 4
        handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(position_number).xyz(1) = eventdata.NewData;
    case 5
        handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(position_number).xyz(2) = eventdata.NewData;
    case 6
        handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(position_number).xyz(3) = eventdata.NewData;
    case 7
        handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(position_number).continuous_focus_offset = eventdata.NewData;
end
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);


% --- Executes when entered data in editable cell(s) in uitable_settings.
function uitable_settings_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable_settings (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
myCol = eventdata.Indices(2);
myRow = eventdata.Indices(1);
myDat = get(handles.uitable_settings,'Data');
my_number = myDat{myRow,11};
switch myCol
    case 1
        handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings(my_number).channel = find(strcmp(eventdata.NewData,handles.mmhandle.Channel));
    case 2
        handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings(my_number).exposure = eventdata.NewData;
    case 3
        handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings(my_number).binning = eventdata.NewData;
    case 4
        handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings(my_number).z_step_size = eventdata.NewData;
    case 5
        handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings(my_number).z_stack_upper_offset = eventdata.NewData;
    case 6
        handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings(my_number).z_stack_lower_offset = eventdata.NewData;
    case 8
        handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings(my_number).z_origin_offset = eventdata.NewData;
    case 9
        handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings(my_number).period_multiplier = eventdata.NewData;
end
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).change_all_position('settings',handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings);
handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).change_all_position('settings_order',handles.mmhandle.SuperMDA.group(handles.SuperMDA_index(1)).position(handles.SuperMDA_index(2)).settings_order);
% Update handles structure
guidata(hObject, handles);
handles.updateInfo(handles.gui_main);


% --- Executes on button press in pushbutton_beginMDA.
function pushbutton_beginMDA_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_beginMDA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
super_mda_acquisition_start(handles.mmhandle);
