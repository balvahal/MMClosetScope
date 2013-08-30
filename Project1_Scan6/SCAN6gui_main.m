function varargout = SCAN6gui_main(varargin)
% SCAN6GUI_MAIN MATLAB code for SCAN6gui_main.fig
%      SCAN6GUI_MAIN, by itself, creates a new SCAN6GUI_MAIN or raises the existing
%      singleton*.
%
%      H = SCAN6GUI_MAIN returns the handle to a new SCAN6GUI_MAIN or the handle to
%      the existing singleton*.
%
%      SCAN6GUI_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCAN6GUI_MAIN.M with the given input arguments.
%
%      SCAN6GUI_MAIN('Property','Value',...) creates a new SCAN6GUI_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SCAN6gui_main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SCAN6gui_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SCAN6gui_main

% Last Modified by GUIDE v2.5 29-Aug-2013 23:31:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SCAN6gui_main_OpeningFcn, ...
    'gui_OutputFcn',  @SCAN6gui_main_OutputFcn, ...
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


% --- Executes just before SCAN6gui_main is made visible.
function SCAN6gui_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SCAN6gui_main (see VARARGIN)

% Choose default command line output for SCAN6gui_main
handles.output = hObject;

% Remember the figure that encompasses the gui
handles.gui_main = hObject;

% add mmhandle to the main figure handles
mmhandleInputIndex = find(strcmp(varargin, 'mmhandle'));
if isempty(mmhandleInputIndex)
    disp('*****');
    disp('Improper input arguments. Pass in mmhandle');
    disp('*****');
    %delete(hObject);
else
    handles.mmhandle = varargin{mmhandleInputIndex+1};
end

% SCAN6gui_main.fig is the parent gui. Launch the children guis and
% send the parent gui object to each child gui.
handles.gui_defineCoverslipArea = SCAN6gui_defineCoverslipArea('gui_main',handles.gui_main);
set(handles.gui_defineCoverslipArea,'visible','off'); % initially hide this gui from the user
handles.gui_stageMap = SCAN6gui_stageMap('gui_main',handles.gui_main);

% Variables
handles.sampleList = false(1,6); %Tallies the "wells" that have samples to be imaged.
handles.sampleIndex = []; %Identifies the "active well", the sample that is actively being defined or altered by the user.
handles.sampleInfo = struct('circumferencePts',{}...
    ,'center',{}...
    ,'radius',{}...
    ,'upperLeftCorner',{}...
    ,'lowerRightCorner',{}...
    );

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SCAN6gui_main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SCAN6gui_main_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listboxFalse.
function listboxFalse_Callback(hObject, eventdata, handles)
% hObject    handle to listboxFalse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxFalse contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxFalse


% --- Executes during object creation, after setting all properties.
function listboxFalse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxFalse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listboxTrue.
function listboxTrue_Callback(hObject, eventdata, handles)
% hObject    handle to listboxTrue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxTrue contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxTrue
clickType = get(handles.gui_main,'SelectionType');
switch clickType
    case 'normal'
        index_selected = get(hObject,'Value');
        if isempty(index_selected)
            %this is here as a precautionary measure. Trial and error
            %debugging the gui never led into this if statement.
            return;
        end
        selectedString = get(handles.listboxTrue,'String');
        handles.sampleIndex = str2double(regexp(selectedString{index_selected(1)},'\d+','match','once'));
end

% update the handles
guidata(handles.gui_main, handles);
% update other figures
stageMapHandles = guidata(handles.gui_stageMap);
stageMapHandles.updateInfo(handles.gui_main);

% --- Executes during object creation, after setting all properties.
function listboxTrue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxTrue (see GCBO)
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
% Find the selected samples from the listboxFalse
index_selected = get(handles.listboxFalse,'Value');
if isempty(index_selected)
    return;
end
listboxFalseContents = get(handles.listboxFalse,'String');
listboxFalseContentsSelected = listboxFalseContents(index_selected);
myBool = false(1,6);
sample_selected = cellfun(@(x) str2double(regexp(x,'\d+','match','once')),listboxFalseContentsSelected);
myBool(sample_selected) = true;
% rearrange the selected samples in listboxTrue to be in ascending order.
listboxFalseContentsOld = cell(6,1);
listboxFalseContentsOld(sample_selected) = listboxFalseContentsSelected;
listboxTrueContentsOld = cell(6,1);
listboxTrueContents = get(handles.listboxTrue,'String');
if ~isempty(listboxTrueContents)
    sample_selected = cellfun(@(x) str2double(regexp(x,'\d+','match','once')),listboxTrueContents);
    listboxTrueContentsOld(sample_selected) = listboxTrueContents;
end
listboxTrueContents = cell(sum(myBool)+sum(handles.sampleList),1);
mycounter = 0;
for i=1:length(handles.sampleList)
    if myBool(i)
        mycounter = mycounter + 1;
        listboxTrueContents(mycounter) = listboxFalseContentsOld(i);
    elseif handles.sampleList(i)
        mycounter = mycounter + 1;
        listboxTrueContents(mycounter) = listboxTrueContentsOld(i);
    end
end
set(handles.listboxTrue,'String',listboxTrueContents);
set(handles.listboxTrue,'Value',[]);
listboxFalseContents(index_selected) = [];
set(handles.listboxFalse,'String',listboxFalseContents);
set(handles.listboxFalse,'Value',[]);
handles.sampleList = handles.sampleList + myBool;
% update the handles
guidata(handles.gui_main, handles);

% --- Executes on button press in pushbuttonSubtract.
function pushbuttonSubtract_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSubtract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Find the selected samples from the listboxTrue
index_selected = get(handles.listboxTrue,'Value');
if isempty(index_selected)
    return;
end
listboxTrueContents = get(handles.listboxTrue,'String');
listboxTrueContentsSelected = listboxTrueContents(index_selected);
myBool = false(1,6);
sample_selected = cellfun(@(x) str2double(regexp(x,'\d+','match','once')),listboxTrueContentsSelected);
myBool(sample_selected) = true;
% rearrange the selected samples in listboxTrue to be in ascending order.
listboxTrueContentsOld = cell(6,1);
listboxTrueContentsOld(sample_selected) = listboxTrueContentsSelected;
listboxFalseContentsOld = cell(6,1);
listboxFalseContents = get(handles.listboxFalse,'String');
if ~isempty(listboxFalseContents)
    sample_selected = cellfun(@(x) str2double(regexp(x,'\d+','match','once')),listboxFalseContents);
    listboxFalseContentsOld(sample_selected) = listboxFalseContents;
end
listboxFalseContents = cell(sum(myBool)+sum(~handles.sampleList),1);
mycounter = 0;
for i=1:length(handles.sampleList)
    if myBool(i)
        mycounter = mycounter + 1;
        listboxFalseContents(mycounter) = listboxTrueContentsOld(i);
    elseif ~handles.sampleList(i)
        mycounter = mycounter + 1;
        listboxFalseContents(mycounter) = listboxFalseContentsOld(i);
    end
end
set(handles.listboxFalse,'String',listboxFalseContents);
set(handles.listboxFalse,'Value',[]);
listboxTrueContents(index_selected) = [];
set(handles.listboxTrue,'String',listboxTrueContents);
set(handles.listboxTrue,'Value',[]);
handles.sampleList = handles.sampleList - myBool;
% update the handles
guidata(handles.gui_main, handles);

% --- Executes on button press in pushbuttonDefineCoverslipArea.
function pushbuttonDefineCoverslipArea_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonDefineCoverslipArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.gui_defineCoverslipArea,'visible','on');


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
delete(handles.gui_defineCoverslipArea);
delete(handles.gui_stageMap);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over listboxTrue.
function listboxTrue_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to listboxTrue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
