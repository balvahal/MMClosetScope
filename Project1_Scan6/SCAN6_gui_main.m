%% SCAN6_gui_main
% a simple gui to pause, stop, and resume a running MDA
function [f] = SCAN6_gui_main(scan6)
%% Create the figure
%
myunits = get(0,'units');
set(0,'units','pixels');
Pix_SS = get(0,'screensize');
set(0,'units','characters');
Char_SS = get(0,'screensize');
ppChar = Pix_SS./Char_SS;
set(0,'units',myunits);
fwidth = 136.6; %683/ppChar(3);
fheight = 70; %910/ppChar(4);
fx = Char_SS(3) - (Char_SS(3)*.1 + fwidth);
fy = Char_SS(4) - (Char_SS(4)*.1 + fheight);
f = figure('Visible','off','Units','characters','MenuBar','none','Position',[fx fy fwidth fheight],...
    'CloseRequestFcn',{@fDeleteFcn},'Name','Scan6 Main');

textBackgroundColorRegion1 = [176 224 230]/255; %PowderBlue
buttonBackgroundColorRegion1 = [135 206 235]/255; %SkyBlue
textBackgroundColorRegion2 = [144 238 144]/255; %LightGreen
buttonBackgroundColorRegion2 = [50 205  50]/255; %LimeGreen
textBackgroundColorRegion3 = [255 250 205]/255; %LemonChiffon
buttonBackgroundColorRegion3 = [255 215 0]/255; %Gold
textBackgroundColorRegion4 = [255 192 203]/255; %Pink
buttonBackgroundColorRegion4 = [255 160 122]/255; %Salmon
buttonSize = [20 3.0769]; %[100/ppChar(3) 40/ppChar(4)];
region1 = [0 52]; %[0 676/ppChar(4)]; %180 pixels
region2 = [0 34]; %[0 442/ppChar(4)]; %180 pixels
region3 = [0 0]; %[0 182/ppChar(4)]; %370 pixels
region4 = [0 0]; %180 pixels

%% Assemble Region 1
%
%%
%
hlistboxFalse = uicontrol('Style','Listbox','Units','characters',...
    'FontSize',14,'FontName','Verdana',...
    'String',{'s1 xy(1,1)','s2 xy(1,2)','s3 xy(1,3)','s4 xy(2,3)','s5 xy(2,2)','s6 xy(2,1)'},...
    'Position',[region1(1)+2, region1(2)+4, 30,11]);

hpushbuttonFalse2True = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion1,...
    'String','>>',...
    'Position',[region1(1)+2, region1(2)+1, 30,2],...
    'Callback',{@pushbuttonFalse2True_Callback});

hlistboxTrue = uicontrol('Style','Listbox','Units','characters',...
    'FontSize',14,'FontName','Verdana',...
    'String',{},...
    'Position',[region1(1)+34, region1(2)+4, 30,11],...
    'Callback',{@listboxTrue_Callback});

hpushbuttonTrue2False = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
    'String','<<',...
    'Position',[region1(1)+34, region1(2)+1, 30,2],...
    'Callback',{@pushbuttonTrue2False_Callback});

heditNumS = uicontrol('Style','edit','Units','characters','String','0',...
    'FontSize',16,'FontName','Verdana',...
    'Position',[region1(1)+66, region1(2)+4, 10,4],...
    'Callback',{@editNumS_Callback});

hpushbuttonMakeGrids = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
    'String','MAKE GRIDS',...
    'Position',[region1(1)+78, region1(2)+4, 30,4],...
    'Callback',{@pushbuttonMakeGrids_Callback});

hpopupGridStyle = uicontrol('Style', 'popup','Units','characters',...
    'String', 'movie|IF',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
    'Position', [region1(1)+78, region1(2)+10, 30,4]);

hpushbuttonFlatfield = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
    'String','Flatfield',...
    'Position',[region1(1)+110, region1(2)+4, 20,4],...
    'Callback',{@pushbuttonFlatfield_Callback});
% The popup function handle callback
% is implemented as a local function
%% Assemble Region 2
%
%%
%
hlistboxXY = uicontrol('Style','Listbox','Units','characters',...
    'FontSize',14,'FontName','Verdana',...
    'String',{},...
    'Position',[region2(1)+2, region2(2)+2, 60,11],...
    'Callback',{@listboxXY_Callback});

hpushbuttonXYAdd= uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion1,...
    'String','Add',...
    'Position',[region2(1)+64, region2(2)+10, 12,3],...
    'Callback',{@pushbuttonXYAdd_Callback});

hpushbuttonXYDrop = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
    'String','Drop',...
    'Position',[region2(1)+64, region2(2)+2, 12,3],...
    'Callback',{@pushbuttonXYDrop_Callback});

htextUserFeedback = uicontrol('Style','text','Units','characters','String','',...
    'FontSize',16,'FontName','Verdana',...
    'Position',[region2(1)+78, region2(2)+2, 50,14],...
    'Callback',{@editNumS_Callback});

%% Assemble Region 3
%
%%
%
% Resize axes so that the width and height are the same ratio as the
% physical xy stage
xyLim = scan6.mm.xyStageLimits;
axesRatio = (0.9*fwidth*ppChar(3))/(32*ppChar(4)); % based on space set aside for the map on the gui
if (xyLim(2)- xyLim(1)) > (xyLim(4) - xyLim(3)) && (xyLim(2)- xyLim(1))/(xyLim(4) - xyLim(3)) >= axesRatio
    smapWidth = 0.9*fwidth*ppChar(3);
    smapHeight = smapWidth*(xyLim(4) - xyLim(3))/(xyLim(2)- xyLim(1));
else
    smapHeight = 32*ppChar(4);
    smapWidth = smapHeight*(xyLim(2) - xyLim(1))/(xyLim(4)- xyLim(3));
end
%convert from pixels to characters
smapWidth = round(smapWidth)/ppChar(3);
smapHeight = round(smapHeight)/ppChar(4);

haxesStageMap = axes(...    % Axes for plotting location of dishes/groups and positions
    'Parent', f, ...
    'Units', 'characters', ...
    'HandleVisibility','callback', ...
    'XLim',[xyLim(1) xyLim(2)],...
    'YLim',[xyLim(3) xyLim(4)],...
    'YDir','reverse',...
    'TickDir','out',...
    'Position',[region3(1)+(fwidth-smapWidth)/2, region3(2) + (region2(2)-region3(2)-smapHeight)/2+1, smapWidth,smapHeight]);
%% Patches and Rectangles
% # current objective position is a rectangle
% # the perimeter of up to 6 dishes are rectangles made to be circles
% # the positions chosen for mda
mm = scan6.mm;
imageHeight = mm.core.getPixelSizeUm*mm.core.getImageHeight;
imageWidth = mm.core.getPixelSizeUm*mm.core.getImageWidth;
handles.colorDish = [176 224 230]/255;
handles.colorActiveDish = [255 99 71]/255;
handles.colorPerimeter = [105 105 105]/255;
handles.colorActivePerimeter = [0 0 0]/255;

hrectangleDishPerimeter = cell(6,1);
for ix = 1:length(hrectangleDishPerimeter)
    hrectangleDishPerimeter{ix} = rectangle('Parent',haxesStageMap,...
        'Position',[0,0,1,1],...
        'EdgeColor',handles.colorDish,...
        'FaceColor','none',...
        'Curvature',[1,1],...
        'LineWidth',3,...
        'Visible','off');
end

mm.getXYZ;
x = mm.pos(1);
y = mm.pos(2);

hpatchCurrentPosition1 = patch('Parent',haxesStageMap,...
    'XData',x,'YData',y,...
    'Marker','o',...
    'MarkerFaceColor','none',...
    'MarkerEdgeColor',[0 0 0]/255,...
    'MarkerSize',8,...
    'FaceColor','none',...
    'EdgeColor','none',...
    'LineWidth',1);

hpatchCurrentPosition2 = patch('Parent',haxesStageMap,...
    'XData',x,'YData',y,...
    'Marker','+',...
    'MarkerFaceColor','none',...
    'MarkerEdgeColor',[0 0 0]/255,...
    'MarkerSize',8,...
    'FaceColor','none',...
    'EdgeColor','none',...
    'LineWidth',1);

hrectangleCurrentPosition = rectangle('Parent',haxesStageMap,...
    'Position',[x-imageWidth/2,y-imageHeight/2,imageWidth,imageHeight],...
    'EdgeColor','none',...
    'FaceColor',[255 0  0]/255);

hpatchPerimeterPositions = cell(6,1);
for ix = 1:length(hpatchPerimeterPositions)
    hpatchPerimeterPositions{ix} = patch('Parent',haxesStageMap,...
        'XData',[],'YData',[],...
        'Marker','x',...
        'MarkerFaceColor','none',...
        'MarkerEdgeColor',handles.colorPerimeter,...
        'MarkerSize',8,...
        'FaceColor','none',...
        'EdgeColor','none',...
        'LineWidth',1.5,...
        'Visible','off');
end

%%
% store the uicontrol handles in the figure handles via guidata()
handles.axesStageMap = haxesStageMap;
handles.rectangleCurrentPosition = hrectangleCurrentPosition;
handles.patchCurrentPosition1 = hpatchCurrentPosition1;
handles.patchCurrentPosition2 = hpatchCurrentPosition2;
handles.rectangleDishPerimeter = hrectangleDishPerimeter;
handles.patchPerimeterPositions = hpatchPerimeterPositions;
%%
% store the uicontrol handles in the figure handles via guidata()
handles.listboxFalse = hlistboxFalse;
handles.listboxTrue = hlistboxTrue;
handles.listboxXY = hlistboxXY;
handles.editNumS = heditNumS;
handles.textUserFeedback = htextUserFeedback;
handles.axesStageMap = haxesStageMap;
handles.popupGridStyle = hpopupGridStyle;
guidata(f,handles);
%%
% make the gui visible
set(f,'Visible','on');

%% Callbacks
%
%%
%
    function fDeleteFcn(~,~)
        %do nothing. This means only the master object can close this
        %window.
    end
%%
%
    function pushbuttonFlatfield_Callback(~,~)
        str = sprintf('Flatfield correction images will now be acquired.\n\nDo you wish to proceed?');
        choice = questdlg(str, ...
            'Warning! Do you wish to proceed?', ...
            'Yes','No','No');
        % Handle response
        if strcmp(choice,'No')
            return;
        end
        
        str = sprintf('Bring the objective into focus on the top of the glass surface using the PFS.\n\nDo you wish to proceed?');
        choice = questdlg(str, ...
            'Warning! Do you wish to proceed?', ...
            'Yes','No','No');
        % Handle response
        if strcmp(choice,'No')
            return;
        end
        
        myCFO = str2double(mm.core.getProperty(mm.AutoFocusDevice,'Position'));
        
        gInd = 1;
        smdaITF2 = SuperMDAItineraryTimeFixed_object(scan6.mm);
        settingsInds = scan6.smdaI.indOfSettings(gInd);
        numberOfpositions = length(settingsInds)*16; % 16 exposures
        smdaITF2.newPositionNewSettings(gInd,numberOfpositions-1);
        exposureArray = [0,50,100,150,200,300,400,500,...
            600,700,800,900,1000,1300,1600,2000]; % 8 exposures
        for i = 1:length(settingsInds)
            myind = (1:16)+(i-1)*16;
            smdaITF2.settings_binning(myind) = scan6.smdaI.settings_binning(settingsInds(i));
            smdaITF2.settings_channel(myind) = scan6.smdaI.settings_channel(settingsInds(i));
            smdaITF2.settings_exposure(myind) = exposureArray;
            smdaITF2.settings_function(myind) = {'SuperMDA_function_settings_timeFixed'};
            smdaITF2.settings_gain(myind) = scan6.smdaI.settings_gain(settingsInds(i));
            smdaITF2.settings_logical(myind) = true;
            smdaITF2.settings_period_multiplier(myind) = 1;
            smdaITF2.settings_scratchpad = {};
            smdaITF2.settings_timepoints(myind) = 1;
            smdaITF2.settings_z_origin_offset(myind) = 0;
            smdaITF2.settings_z_stack_lower_offset(myind) = 0;
            smdaITF2.settings_z_stack_upper_offset(myind) = 0;
            smdaITF2.settings_z_step_size(myind) = 0.3;
        end
        
        %imageHeight = scan6.mm.core.getPixelSizeUm*mm.core.getImageHeight;
        %imageWidth = scan6.mm.core.getPixelSizeUm*mm.core.getImageWidth;
        %Use 2x image dimensions as a tolerance for the maximum
        %area. In otherwords, the square will be slightly smaller
        %than it could be.
        %tol = 2*(imageWidth+imageHeight);
        tol = 0.1*scan6.radius(1);
        %Find the corners of the square that maximizes the area
        %within the circular coverslip.
        ULC = ...
            [(scan6.center(1,1) - (cos(pi/4)*scan6.radius(1) - tol)),...
            (scan6.center(2,1) - (cos(pi/4)*scan6.radius(1) - tol)),...
            scan6.z(1)];
        LRC = ...
            [(scan6.center(1,1) + (cos(pi/4)*scan6.radius(1) - tol)),...
            (scan6.center(2,1) + (cos(pi/4)*scan6.radius(1) - tol)),...
            scan6.z(1)];
        grid = super_mda_grid_maker(scan6.mm,'upper_left_corner',ULC,'lower_right_corner',LRC,'number_of_images',numberOfpositions);
        n = 0;
        for i = 1:length(settingsInds)
            for j = 1:16
                n = n+1;
                smdaITF2.position_xyz(n,:) = grid.positions(n,:);
                smdaITF2.position_label{n} = sprintf('%s_%d',smdaITF2.channel_names{smdaITF2.settings_channel(n)},exposureArray(j));
            end
        end
        smdaITF2.output_directory = fullfile(scan6.smdaI.output_directory,'flatfield');
        smdaITF2.position_continuous_focus_offset(:) = myCFO + 100;
        xyz = mm.getXYZ;
        smdaITF2.position_xyz(:,3) = xyz(3);
        
        smdaP = SuperMDAPilot_object(smdaITF2);
        smdaP.startAcquisition;
    end
%%
%
    function pushbuttonFalse2True_Callback(~,~)
        index_selected = get(handles.listboxFalse,'Value');
        if isempty(index_selected)
            return;
        end
        listboxFalseContents = get(handles.listboxFalse,'String');
        listboxFalseContentsSelected = listboxFalseContents(index_selected);
        myBool = false(1,6);
        sample_selected = cellfun(@(x) str2double(regexp(x,'(?<=s)\d+','match','once')),listboxFalseContentsSelected);
        myBool(sample_selected) = true;
        % rearrange the selected samples in listboxTrue to be in ascending
        % order.
        listboxFalseContentsOld = cell(6,1);
        listboxFalseContentsOld(sample_selected) = listboxFalseContentsSelected;
        listboxTrueContentsOld = cell(6,1);
        listboxTrueContents = get(handles.listboxTrue,'String');
        if ~isempty(listboxTrueContents)
            sample_selected = cellfun(@(x) str2double(regexp(x,'(?<=s)\d+','match','once')),listboxTrueContents);
            listboxTrueContentsOld(sample_selected) = listboxTrueContents;
        end
        listboxTrueContents = cell(sum(myBool)+sum(scan6.sampleList),1);
        mycounter = 0;
        for i=1:length(scan6.sampleList)
            if myBool(i)
                mycounter = mycounter + 1;
                listboxTrueContents(mycounter) = listboxFalseContentsOld(i);
            elseif scan6.sampleList(i)
                mycounter = mycounter + 1;
                listboxTrueContents(mycounter) = listboxTrueContentsOld(i);
            end
        end
        set(handles.listboxTrue,'String',listboxTrueContents);
        set(handles.listboxTrue,'Value',1);
        listboxFalseContents(index_selected) = [];
        if isempty(listboxFalseContents)
            set(handles.listboxFalse,'String',[]);
            set(handles.listboxFalse,'Value',[]);
        else
            set(handles.listboxFalse,'String',listboxFalseContents);
            set(handles.listboxFalse,'Value',1);
        end
        scan6.sampleList = scan6.sampleList + myBool;
        % update the visuals
        for i = 1:length(scan6.sampleList)
            if scan6.sampleList(i) == true
                handlesStageMap = guidata(scan6.gui_axes);
                myPerimeter = handlesStageMap.patchPerimeterPositions{i};
                set(myPerimeter,'Visible','on');
                myPerimeter2 = handles.patchPerimeterPositions{i};
                set(myPerimeter2,'Visible','on');
                
                myDish = handlesStageMap.rectangleDishPerimeter{i};
                myDish2 = handles.rectangleDishPerimeter{i};
                myPPts = get(myPerimeter,'XData');
                if length(myPPts) > 2
                    set(myDish,'Visible','on');
                    set(myDish2,'Visible','on');
                else
                    set(myDish,'Visible','off');
                    set(myDish2,'Visible','off');
                end
                
                myPositions = handlesStageMap.patchSmdaPositions{i};
                set(myPositions,'Visible','on');
            end
        end
    end
%%
%
    function pushbuttonTrue2False_Callback(~,~)
        index_selected = get(handles.listboxTrue,'Value');
        if isempty(index_selected)
            return;
        end
        listboxTrueContents = get(handles.listboxTrue,'String');
        listboxTrueContentsSelected = listboxTrueContents(index_selected);
        myBool = false(1,6);
        sample_selected = cellfun(@(x) str2double(regexp(x,'(?<=s)\d+','match','once')),listboxTrueContentsSelected);
        myBool(sample_selected) = true;
        % rearrange the selected samples in listboxTrue to be in ascending
        % order.
        listboxTrueContentsOld = cell(6,1);
        listboxTrueContentsOld(sample_selected) = listboxTrueContentsSelected;
        listboxFalseContentsOld = cell(6,1);
        listboxFalseContents = get(handles.listboxFalse,'String');
        if ~isempty(listboxFalseContents)
            sample_selected = cellfun(@(x) str2double(regexp(x,'(?<=s)\d+','match','once')),listboxFalseContents);
            listboxFalseContentsOld(sample_selected) = listboxFalseContents;
        end
        listboxFalseContents = cell(sum(myBool)+sum(~scan6.sampleList),1);
        mycounter = 0;
        for i=1:length(scan6.sampleList)
            if myBool(i)
                mycounter = mycounter + 1;
                listboxFalseContents(mycounter) = listboxTrueContentsOld(i);
            elseif ~scan6.sampleList(i)
                mycounter = mycounter + 1;
                listboxFalseContents(mycounter) = listboxFalseContentsOld(i);
            end
        end
        set(handles.listboxFalse,'String',listboxFalseContents);
        set(handles.listboxFalse,'Value',1);
        listboxTrueContents(index_selected) = [];
        if isempty(listboxTrueContents)
            set(handles.listboxTrue,'String',[]);
            set(handles.listboxTrue,'Value',[]);
        else
            set(handles.listboxTrue,'String',listboxTrueContents);
            set(handles.listboxTrue,'Value',1);
        end
        scan6.sampleList = scan6.sampleList - myBool;
        % update the visuals
        for i = 1:length(scan6.sampleList)
            if scan6.sampleList(i) == false
                handlesStageMap = guidata(scan6.gui_axes);
                myPerimeter = handlesStageMap.patchPerimeterPositions{i};
                set(myPerimeter,'Visible','off');
                myPerimeter2 = handles.patchPerimeterPositions{i};
                set(myPerimeter2,'Visible','off');
                
                myDish = handlesStageMap.rectangleDishPerimeter{i};
                myDish2 = handles.rectangleDishPerimeter{i};
                set(myDish,'Visible','off');
                set(myDish2,'Visible','off');
                
                myPositions = handlesStageMap.patchSmdaPositions{i};
                set(myPositions,'Visible','off');
            end
        end
    end

%%
%
    function editNumS_Callback(~,~)
        myNum = str2double(get(handles.editNumS,'String'));
        if isnan(myNum) || myNum < 1
            scan6.numberOfPositions(scan6.ind) = 1;
        else
            scan6.numberOfPositions(scan6.ind) = round(myNum);
        end
    end
%%
%
    function listboxTrue_Callback(~,~)
        myValue = get(handles.listboxTrue,'Value');
        if isempty(myValue)
            return
        end
        % update the visuals
        if ~isempty(scan6.ind)
            handlesStageMap = guidata(scan6.gui_axes);
            myPerimeter = handlesStageMap.patchPerimeterPositions{scan6.ind};
            set(myPerimeter,'MarkerEdgeColor',handlesStageMap.colorPerimeter);
            myDish = handlesStageMap.rectangleDishPerimeter{scan6.ind};
            set(myDish,'EdgeColor',handlesStageMap.colorDish);
            
            myPerimeter2 = handles.patchPerimeterPositions{scan6.ind};
            set(myPerimeter2,'MarkerEdgeColor',handles.colorPerimeter);
            myDish2 = handles.rectangleDishPerimeter{scan6.ind};
            set(myDish2,'EdgeColor',handles.colorDish);
        end
        %
        listboxTrueContents = get(handles.listboxTrue,'String');
        scan6.ind = str2double(regexp(listboxTrueContents{myValue(1)},'(?<=s)\d+','match','once'));
        set(handles.editNumS,'String',num2str(scan6.numberOfPositions(scan6.ind)));
        scan6.numberOfPositions(scan6.ind) = str2double(get(handles.editNumS,'String'));
        % now update listboxXY
        myPPts = scan6.perimeterPoints{scan6.ind};
        if isempty(myPPts)
            scan6.ind2 = [];
            set(handles.listboxXY,'String',{});
        else
            scan6.ind2 = 1;
            listboxPtsContents = cell(size(myPPts,1),1);
            for i = 1:size(myPPts,1)
                listboxPtsContents{i} = sprintf('%7.0f || %7.0f',myPPts(i,1),myPPts(i,2));
            end
            set(handles.listboxXY,'Value',scan6.ind2);
            set(handles.listboxXY,'String',listboxPtsContents);
        end
        % update the visuals
        handlesStageMap = guidata(scan6.gui_axes);
        myPerimeter = handlesStageMap.patchPerimeterPositions{scan6.ind};
        set(myPerimeter,'MarkerEdgeColor',handlesStageMap.colorActivePerimeter);
        myDish = handlesStageMap.rectangleDishPerimeter{scan6.ind};
        set(myDish,'EdgeColor',handlesStageMap.colorActiveDish);
        
        myPerimeter2 = handles.patchPerimeterPositions{scan6.ind};
        set(myPerimeter2,'MarkerEdgeColor',handles.colorActivePerimeter);
        myDish2 = handles.rectangleDishPerimeter{scan6.ind};
        set(myDish2,'EdgeColor',handles.colorActiveDish);
    end
%%
%
    function listboxXY_Callback(~,~)
        myValue = get(handles.listboxTrue,'Value');
        if isempty(myValue)
            return
        end
        listboxTrueContents = get(handles.listboxTrue,'String');
        scan6.ind = str2double(regexp(listboxTrueContents{myValue(1)},'(?<=s)\d+','match','once'));
        set(handles.editNumS,'String',num2str(scan6.numberOfPositions(scan6.ind)));
        scan6.numberOfPositions(scan6.ind) = str2double(get(handles.editNumS,'String'));
        scan6.ind2 = get(handles.listboxXY,'Value');
    end
%%
%
    function pushbuttonMakeGrids_Callback(~,~)
        tic
        % initialize the SuperMDAItinerary
        gridStyle = get(handles.popupGridStyle,'Value');
        logicalList = logical(scan6.sampleList);
        sampleListIndex = find(logicalList);
        numberOfPositions = scan6.numberOfPositions(logicalList);
        center = scan6.center(:,find(logicalList)); %#ok<FNDSB>
        radius = scan6.radius(logicalList);
        z = scan6.z(logicalList);
        if length(numberOfPositions) > 1 %assumes 1st group is there by default and should not count towards additional groups
            numberOfGroups = scan6.smdaI.numberOfGroup;
            if numberOfGroups < length(numberOfPositions)
                scan6.smdaTA.addGroup(length(numberOfPositions)-numberOfGroups);
            end
        end
        for i = 1:length(numberOfPositions)
            if numberOfPositions(i) == Inf
                imageHeight = scan6.mm.core.getPixelSizeUm*mm.core.getImageHeight;
                imageWidth = scan6.mm.core.getPixelSizeUm*mm.core.getImageWidth;
                %Use 2x image dimensions as a tolerance for the maximum
                %area. In otherwords, the square will be slightly smaller
                %than it could be.
                tol = 0.1*mean(radius);
                %Find the corners of the square that maximizes the area
                %within the circular coverslip.
                ULC = ...
                    [(center(1,i) - (cos(pi/4)*radius(i) - tol)),...
                    (center(2,i) - (cos(pi/4)*radius(i) - tol)),...
                    z(i)];
                LRC = ...
                    [(center(1,i) + (cos(pi/4)*radius(i) - tol)),...
                    (center(2,i) + (cos(pi/4)*radius(i) - tol)),...
                    z(i)];
                if gridStyle == 1
                    grid = super_mda_grid_maker(scan6.mm,'upper_left_corner',ULC,'lower_right_corner',LRC,'overlap',25);
                    numberOfPositions(i) = size(grid.positions,1);
                elseif gridStyle == 2
                    grid = super_mda_grid_maker(scan6.mm,'upper_left_corner',ULC,'lower_right_corner',LRC,'overlap',25);
                    numberOfPositions(i) = size(grid.positions,1);
                end
            else
                if gridStyle == 1
                    %imageHeight = scan6.mm.core.getPixelSizeUm*mm.core.getImageHeight;
                    %imageWidth = scan6.mm.core.getPixelSizeUm*mm.core.getImageWidth;
                    %Use 2x image dimensions as a tolerance for the maximum
                    %area. In otherwords, the square will be slightly smaller
                    %than it could be.
                    %tol = 2*(imageWidth+imageHeight);
                    tol = 0.1*mean(radius);
                    %Find the corners of the square that maximizes the area
                    %within the circular coverslip.
                    ULC = ...
                        [(center(1,i) - (cos(pi/4)*radius(i) - tol)),...
                        (center(2,i) - (cos(pi/4)*radius(i) - tol)),...
                        z(i)];
                    LRC = ...
                        [(center(1,i) + (cos(pi/4)*radius(i) - tol)),...
                        (center(2,i) + (cos(pi/4)*radius(i) - tol)),...
                        z(i)];
                    grid = super_mda_grid_maker(scan6.mm,'upper_left_corner',ULC,'lower_right_corner',LRC,'number_of_images',numberOfPositions(i));
                elseif gridStyle == 2
                    grid = super_mda_grid_maker(scan6.mm,'centroid',[center(1,i),center(2,i),z(i)],'number_of_images',numberOfPositions(i),'overlap',25);
                end
            end
            scan6.smdaTA.addPositionGrid(i,grid);
            
            % update the visuals
            imageHeight = mm.core.getPixelSizeUm*mm.core.getImageHeight;
            imageWidth = mm.core.getPixelSizeUm*mm.core.getImageWidth;
            
            handlesStageMap = guidata(scan6.gui_axes);
            myPositions = handlesStageMap.patchSmdaPositions{sampleListIndex(i)};
            myPosX = transpose(grid.positions(:,1));
            myPosX = vertcat(myPosX,transpose(grid.positions(:,1))+imageWidth);
            myPosX = vertcat(myPosX,transpose(grid.positions(:,1))+imageWidth);
            myPosX = vertcat(myPosX,transpose(grid.positions(:,1)));
            
            myPosY = transpose(grid.positions(:,2));
            myPosY = vertcat(myPosY,transpose(grid.positions(:,2)));
            myPosY = vertcat(myPosY,transpose(grid.positions(:,2))+imageHeight);
            myPosY = vertcat(myPosY,transpose(grid.positions(:,2))+imageHeight);
            
            myFaceColor = jet(size(myPosX,2));
            
            set(myPositions,'XData',myPosX,'YData',myPosY,...
                'FaceVertexCData',myFaceColor,'Visible','on');
            
            set(myPositions,'Visible','on');
        end
        fprintf('Grid Calculation Complete! ');
        toc
    end
%%
%
    function pushbuttonXYAdd_Callback(~,~)
        set(handles.textUserFeedback,'String',[]);
        if isempty(scan6.ind)
            return;
        end
        scan6.mm.getXYZ;
        myPPts = scan6.perimeterPoints{scan6.ind};
        myPPts(end+1,1:3) = scan6.mm.pos;
        % Proofread the data points
        % * data points should not be identical with the first value.
        % * there is a singularity if the y-value of the first point is the
        % same as the y-value of an nth point. This must also be avoided.
        if size(myPPts,1)>1
            testnumx = scan6.mm.pos(1)-myPPts(1,1);
            testnumy = scan6.mm.pos(2)-myPPts(1,2);
            testsumchk = testnumx+testnumy ~= 0;
            if ~all(testsumchk)
                instring = {'The first pair of points in the input array of (x,y) coordinates is identical to another pair of points in the array. Choose another point.'};
                outstring = textwrap(handles.textUserFeedback,instring);
                set(handles.textUserFeedback,'String',outstring);
                return
            end
            if ~all(testnumy)
                instring = {'The first y-value in the input array of (x,y) coordinates is identical to another y-value in the array. Choose another point.'};
                outstring = textwrap(handles.textUserFeedback,instring);
                set(handles.textUserFeedback,'String',outstring);
                return
            end
        end
        scan6.perimeterPoints{scan6.ind} = myPPts;
        % update the visuals
        handlesStageMap = guidata(scan6.gui_axes);
        myPerimeter = handlesStageMap.patchPerimeterPositions{scan6.ind};
        set(myPerimeter,'XData',myPPts(:,1),'YData',myPPts(:,2),'Visible','on');
        
        myPerimeter2 = handles.patchPerimeterPositions{scan6.ind};
        set(myPerimeter2,'XData',myPPts(:,1),'YData',myPPts(:,2),'Visible','on');
        % estimate the size of the coverslip area using this new
        % information
        if size(myPPts,1)>2
            [xc,yc,r] = SCAN6config_estimateCircle(myPPts(:,1:2));
            scan6.center(1:2,scan6.ind) = [xc,yc];
            scan6.radius(scan6.ind) = r;
            scan6.z(scan6.ind) = mean(myPPts(:,3));
            % update the visuals
            myDish = handlesStageMap.rectangleDishPerimeter{scan6.ind};
            set(myDish,'Position',[xc-r,yc-r,2*r,2*r],'Visible','on');
            myDish2 = handles.rectangleDishPerimeter{scan6.ind};
            set(myDish2,'Position',[xc-r,yc-r,2*r,2*r],'Visible','on');
        else
            handlesStageMap = guidata(scan6.gui_axes);
            myDish = handlesStageMap.rectangleDishPerimeter{scan6.ind};
            set(myDish,'Visible','off');
            myDish2 = handles.rectangleDishPerimeter{scan6.ind};
            set(myDish2,'Visible','off');
        end
        % add this position data to the listboxPts
        listboxPtsContents = get(handles.listboxXY,'String');
        listboxPtsContents{end+1} = sprintf('%7.0f || %7.0f',scan6.mm.pos(1),scan6.mm.pos(2));
        set(handles.listboxXY,'Value',length(listboxPtsContents));
        scan6.ind2 = length(listboxPtsContents);
        set(handles.listboxXY,'String',listboxPtsContents);
    end
%%
%
    function pushbuttonXYDrop_Callback(~,~)
        set(handles.textUserFeedback,'String',[]);
        if isempty(scan6.ind) || isempty (scan6.ind2) || scan6.ind2 == 0
            return;
        end
        myPPts = scan6.perimeterPoints{scan6.ind};
        myPPts(scan6.ind2,:) = [];
        scan6.perimeterPoints{scan6.ind} = myPPts;
        % update the visuals
        handlesStageMap = guidata(scan6.gui_axes);
        myPerimeter = handlesStageMap.patchPerimeterPositions{scan6.ind};
        set(myPerimeter,'XData',myPPts(:,1),'YData',myPPts(:,2),'Visible','on');
        myPerimeter2 = handles.patchPerimeterPositions{scan6.ind};
        set(myPerimeter2,'XData',myPPts(:,1),'YData',myPPts(:,2),'Visible','on');
        % estimate the size of the coverslip area using this new
        % information
        if size(myPPts,1)>2
            [xc,yc,r] = SCAN6config_estimateCircle(myPPts(:,1:2));
            scan6.center(1:2,scan6.ind) = [xc,yc];
            scan6.radius(scan6.ind) = r;
            scan6.z(scan6.ind) = mean(myPPts(:,3));
            % update the visuals
            myDish = handlesStageMap.rectangleDishPerimeter{scan6.ind};
            set(myDish,'Position',[xc-r,yc-r,2*r,2*r],'Visible','on');
            myDish2 = handles.rectangleDishPerimeter{scan6.ind};
            set(myDish2,'Position',[xc-r,yc-r,2*r,2*r],'Visible','on');
        else
            handlesStageMap = guidata(scan6.gui_axes);
            myDish = handlesStageMap.rectangleDishPerimeter{scan6.ind};
            set(myDish,'Visible','off');
            myDish2 = handlesStageMap.rectangleDishPerimeter{scan6.ind};
            set(myDish2,'Visible','off');
        end
        % remove this position data to the listboxPts
        listboxPtsContents = get(handles.listboxXY,'String');
        listboxPtsContents(scan6.ind2) = [];
        scan6.ind2 = length(listboxPtsContents);
        set(handles.listboxXY,'Value',scan6.ind2);
        set(handles.listboxXY,'String',listboxPtsContents);
    end
end
