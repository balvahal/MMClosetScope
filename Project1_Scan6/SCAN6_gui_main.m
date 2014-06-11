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
    'CloseRequestFcn',{@fDeleteFcn},'Name','Main');

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

%%
% store the uicontrol handles in the figure handles via guidata()
handles.listboxFalse = hlistboxFalse;
handles.listboxTrue = hlistboxTrue;
handles.listboxXY = hlistboxXY;
handles.editNumS = heditNumS;
handles.textUserFeedback = htextUserFeedback;
handles.axesStageMap = haxesStageMap;
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
    end

%%
%
    function editNumS_Callback(~,~)
        myNum = str2double(get(handles.editNumS,'String'));
        if isnan(myNum)
            scan6.numberOfPositions(scan6.ind) = 0;
        else
            scan6.numberOfPositions(scan6.ind) = myNum;
        end
    end
%%
%
    function listboxTrue_Callback(~,~)
        myValue = get(handles.listboxTrue,'Value');
        if isempty(myValue)
            return
        end
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
        myPPts(end+1,1:2) = scan6.mm.pos(1:2);
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
        % estimate the size of the coverslip area using this new
        % information
        if size(myPPts,1)>2
            [xc,yc,r] = SCAN6config_estimateCircle(myPPts);
            scan6.center(1:2,scan6.ind) = [xc,yc];
            scan6.radius(scan6.ind) = r;
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
        % estimate the size of the coverslip area using this new
        % information
        if size(myPPts,1)>2
            [xc,yc,r] = SCAN6config_estimateCircle(myPPts);
            scan6.center(1:2,scan6.ind) = [xc,yc];
            scan6.radius(scan6.ind) = r;
        end
        % remove this position data to the listboxPts
        listboxPtsContents = get(handles.listboxXY,'String');
        listboxPtsContents(scan6.ind2) = [];
        scan6.ind2 = length(listboxPtsContents);
        set(handles.listboxXY,'Value',scan6.ind2);
        set(handles.listboxXY,'String',listboxPtsContents);
    end

end
