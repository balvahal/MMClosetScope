%% The SuperMDAPilot
% The SuperMDA allows multiple multi-dimensional-acquisitions to be run
classdef SuperMDAPilotContinuousCapture_object < handle
    %%
    % * database: 2^20 rows will be set aside to store image metadata. This
    % will represent a soft cap on the number of images that can be
    % collected by the SuperMDA. For images of size 2048x2048 this would be
    % 4 terabytes of image data, which seems like a reasonable upper limit
    % that will be relevant through the year 2016.
    % * duration: the length of a time lapse experiment in seconds. A
    % duration of zero means only a single set of images are captured, e.g.
    % for a scan slide feature.
    % * filename_prefix: the string that is placed at the front of the
    % image filename.
    % * fundamental_period: the shortest period that images are taken in
    % seconds.
    % * output_directory: The directory where the output images are stored.
    %
    properties
        databasefilename;
        database_imagedescription = '';
        database_z_number = 1;
        itinerary;
        clock_absolute;
        mm;
        pause_bool = false;
        running_bool = false;
        runtime_imagecounter = 0;
        gps_previous = [0,0,0]; %when looping through the MDA object, this will keep track of where it is in the loop. [timepoint,group,position,settings,z_stack]
        gps_current;
        gui_pause_stop_resume;
        gui_lastImage;
        t = 1;
        flag_group_before = false;
        flag_group_after = false;
        flag_position_before = false;
        flag_position_after = false;
    end
    %%
    %
    events
        
    end
    %%
    %
    methods
        %% The constructor method
        % The first argument is always mm
        function obj = SuperMDAPilotContinuousCapture_object(smdaI)
            %%%
            % parse the input
            q = inputParser;
            addRequired(q, 'smdaI', @(x) isa(x,'SuperMDAItineraryTimeFixed_object'));
            parse(q,smdaI);
            %% Initialzing the SuperMDA object
            %
            obj.itinerary = smdaI;
            obj.mm = smdaI.mm;
            %%
            %
            obj.databasefilename = fullfile(obj.itinerary.output_directory,'smda_database.txt');
            if ~isdir(obj.itinerary.output_directory)
                mkdir(obj.itinerary.output_directory);
            end
            %% Create the figure
            %
            myunits = get(0,'units');
            set(0,'units','pixels');
            Pix_SS = get(0,'screensize');
            set(0,'units','characters');
            Char_SS = get(0,'screensize');
            ppChar = Pix_SS./Char_SS;
            set(0,'units',myunits);
            fwidth = 91;
            fheight = 35;
            fx = Char_SS(3) - (Char_SS(3)*.1 + fwidth);
            fy = Char_SS(4) - (Char_SS(4)*.1 + fheight);
            obj.gui_pause_stop_resume = figure('Visible','off','Units','characters','MenuBar','none','Position',[fx fy fwidth fheight],...
                'CloseRequestFcn',{@obj.PSR_fDeleteFcn},'Name','Pause Stop Resume');
            %% Construct the components
            % The pause, stop, and resume buttons
            hwidth = 20;
            hheight = 5.3846;
            hx = 4;
            hygap = (fheight - 4*hheight)/5;
            hy = fheight - (hygap + hheight);
            PSR_pushbuttonPause = uicontrol('Parent',obj.gui_pause_stop_resume,'Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',[255 214 95]/255,...
                'String','Pause','Position',[hx hy hwidth hheight],...
                'Callback',{@obj.PSR_pushbuttonPause_Callback});
            
            hy = hy - (hygap + hheight);
            PSR_pushbuttonResume = uicontrol('Parent',obj.gui_pause_stop_resume,'Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',[56 165 95]/255,...
                'String','Resume','Position',[hx hy hwidth hheight],...
                'Callback',{@obj.PSR_pushbuttonResume_Callback});
            
            hy = hy - (hygap + hheight);
            PSR_pushbuttonStop = uicontrol('Parent',obj.gui_pause_stop_resume,'Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',[255 103 97]/255,...
                'String','Stop','Position',[hx hy hwidth hheight],...
                'Callback',{@obj.PSR_pushbuttonStop_Callback});
            
            hy = hy - (hygap + hheight);
            PSR_pushbuttonFinishAcq = uicontrol('Parent',obj.gui_pause_stop_resume,'Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',[37 124 224]/255,...
                'String',sprintf('Finish'),'Position',[hx hy hwidth hheight],...
                'Callback',{@obj.PSR_pushbuttonFinishAcq_Callback});
            
            align([PSR_pushbuttonPause,PSR_pushbuttonResume,PSR_pushbuttonStop,PSR_pushbuttonFinishAcq],'Center','None');
            %%
            % A text box showing the time until the next acquisition
            hwidth = 50;
            hheight = 7.6923;
            hx = (fwidth - (4 + 20 + hwidth))/2 + 4 + 20;
            hygap = (fheight - hheight)/2;
            hy = fheight - (hygap + hheight);
            PSR_textTime = uicontrol('Style','text','String','No Acquisition',...
                'Units','characters','FontSize',20,'FontWeight','bold',...
                'FontName','Courier New',...
                'Position',[hx hy hwidth hheight]);
            %%
            % store the uicontrol handles in the figure handles via guidata()
            PSR_handles.PSR_textTime = PSR_textTime;
            PSR_handles.PSR_pushbuttonPause = PSR_pushbuttonPause;
            PSR_handles.PSR_pushbuttonResume = PSR_pushbuttonResume;
            PSR_handles.PSR_pushbuttonStop = PSR_pushbuttonStop;
            PSR_handles.PSR_pushbuttonFinishAcq = PSR_pushbuttonFinishAcq;
            guidata(obj.gui_pause_stop_resume,PSR_handles);
            %%
            % make the gui visible
            set(obj.gui_pause_stop_resume,'Visible','on');
            %%
            %
            myunits = get(0,'units');
            set(0,'units','pixels');
            Pix_SS = get(0,'screensize');
            set(0,'units','characters');
            Char_SS = get(0,'screensize');
            ppChar = Pix_SS./Char_SS;
            ppChar = ppChar([3,4]);
            set(0,'units',myunits);
            Isize = size(obj.mm.I);
            image_height = Isize(1);
            image_width = Isize(2);
            
            if image_width > image_height
                if image_width/image_height >= Pix_SS(3)/Pix_SS(4)
                    fwidth = 0.9*Pix_SS(3);
                    fheight = fwidth*image_height/image_width;
                else
                    fheight = 0.9*Pix_SS(4);
                    fwidth = fheight*image_width/image_height;
                end
            else
                if image_height/image_width >= Pix_SS(4)/Pix_SS(3)
                    fheight = 0.9*Pix_SS(4);
                    fwidth = fheight*image_width/image_height;
                else
                    fwidth = 0.9*Pix_SS(3);
                    fheight = fwidth*image_height/image_width;
                    
                end
            end
            
            fwidth = fwidth/ppChar(1);
            fheight = fheight/ppChar(2);
            mycolormap = colormap(jet(255));
            obj.gui_lastImage = figure('Visible','off','Units','characters','MenuBar','none',...
                'Resize','off','Name','Last Image Taken',...
                'Renderer','OpenGL','Position',[(Char_SS(3)-fwidth)/2 (Char_SS(4)-fheight)/2 fwidth fheight],...
                'Colormap',mycolormap,'CloseRequestFcn',{@obj.LIT_fDeleteFcn});
            
            LIT_axesLastImage = axes('Parent',obj.gui_lastImage,...
                'Units','characters',...
                'Position',[0 0 fwidth  fheight],...
                'YDir','reverse',...
                'Visible','on',...
                'XLim',[0.5,image_width+0.5],...
                'YLim',[0.5,image_height+0.5]);
            
            LIT_sourceImage = image('Parent',LIT_axesLastImage,'CData',obj.mm.I);
            %%
            % store the uicontrol handles in the figure handles via guidata()
            LIT_handles.LIT_axesLastImage = LIT_axesLastImage;
            LIT_handles.I = LIT_sourceImage;
            guidata(obj.gui_lastImage,LIT_handles);
            %%
            % make the gui visible
            set(obj.gui_lastImage,'Visible','on');
        end
        %%
        %
        function LIT_fDeleteFcn(~,~)
            %do nothing. This means only the master object can close this
            %window.
        end
        %%
        %
        function PSR_fDeleteFcn(obj,~,~)
            obj.delete;
        end
        %%
        %
        function obj = PSR_pushbuttonPause_Callback(obj,~,~)
            obj.pause_acquisition;
        end
        %%
        %
        function obj = PSR_pushbuttonResume_Callback(obj,~,~)
            obj.resume_acquisition;
        end
        %%
        %
        function obj = PSR_pushbuttonStop_Callback(obj,~,~)
            str = sprintf('The current acquisition will be stopped.\n\nDo you wish to proceed?');
            choice = questdlg(str, ...
                'Warning! Do you wish to proceed?', ...
                'Yes','No','No');
            % Handle response
            if strcmp(choice,'No')
                return;
            end
            obj.stop_acquisition;
        end
        %%
        %
        function obj = PSR_pushbuttonFinishAcq_Callback(obj,~,~)
            str = sprintf('The current acquisition will be stopped after a running acquisition ends. You cannot unmake this decision.\n\nDo you wish to proceed?');
            choice = questdlg(str, ...
                'Warning! Do you wish to proceed?', ...
                'Yes','No','No');
            % Handle response
            if strcmp(choice,'No')
                return;
            end
            obj.clock_absolute(end) = now;
        end
        %% start acquisition
        %
        function obj = startAcquisition(obj)
            %%
            %
            if obj.running_bool
                display('SuperMDA is already running!');
                return
            end
            obj.itinerary.export;
            %% Establish folder tree that will store images
            %
            if ~isdir(obj.itinerary.output_directory)
                mkdir(obj.itinerary.output_directory);
            end
            obj.itinerary.png_path = fullfile(obj.itinerary.output_directory,'RAW_DATA');
            if ~isdir(obj.itinerary.png_path)
                mkdir(obj.itinerary.png_path);
            end
            %%
            % initialize key variables
            obj.t = 1;
            obj.runtime_imagecounter = 0;
            obj.gps_previous = [0,0,0];
            if obj.itinerary.duration == 0
                obj.running_bool = true;
                obj.oneLoop
                obj.stop_acquisition;
                return
            end
            %% Configure the absolute clock
            % Convert the obj.itinerary.clock_relative unit of time (seconds) to
            % the MATLAB unit of time (days) for the serial date numbers, i.e. the
            % number of days that have passed since January 1, 0000.            
            obj.clock_absolute = now + obj.itinerary.clock_relative/86400;
            obj.running_bool = true;
            while now < obj.clock_absolute(end)
                pause(1);
                tic
                obj.oneLoop
                obj.t = obj.t + 1;
                fprintf('Loop-');
                toc
                if obj.running_bool == false
                    %%%
                    % if acquisition was stopped during the loop
                    obj.stop_acquisition;
                    return
                end
            end
            obj.stop_acquisition;
        end
        %% stop acquisition
        %
        function obj = stop_acquisition(obj)
            %%
            %
            obj.running_bool = false;
            obj.gps_previous = [0,0,0]; %reset the gps_previous pointer
            handles = guidata(obj.gui_pause_stop_resume);
            set(handles.PSR_textTime,'String','No Acquisition');
            drawnow;
            obj.pause_bool = false;
            disp('All Done!')
            if obj.mm.twitterBool
                try
                    obj.mm.twitter.updateStatus(sprintf('The %s microscope has completed a super multi-dimensional acquisition! It has %d timepoints.',obj.mm.computerName,obj.t));
                catch
                    disp('Twitter Error!')
                end
            end
        end
        %% pause acquisition
        %
        function obj = pause_acquisition(obj)
            if obj.running_bool
                obj.pause_bool = true;
            end
        end
        %% resume acquisition
        %
        function obj = resume_acquisition(obj)
            if obj.running_bool
                obj.pause_bool = false;
            end
        end
        %%
        %
        function obj = makeMasterDatabase(obj)
            mydir = dir(obj.itinerary.png_path);
            %%%
            % find all of the text files
            mydir = mydir(cellfun(@(x) ~isempty(regexp(x,'.txt$','start')),{mydir(:).name}));
            mytable = readtable(fullfile(obj.itinerary.png_path,mydir(1).name),'Delimiter','\t');
            if length(mydir) > 1
                for i = 2:length(mydir)
                    mytable = vertcat(mytable,readtable(fullfile(obj.itinerary.png_path,mydir(i).name),'Delimiter','\t')); %#ok<AGROW>
                end
            end
            obj.databasefilename = fullfile(obj.itinerary.output_directory,'smda_database.txt');
            writetable(mytable,obj.databasefilename,'Delimiter','tab');
        end
        %% execute 1 round of acquisition
        %
        function obj = oneLoop(obj)
            %%
            % for the n-1 entries in the gps
            smdaI = obj.itinerary;
            obj.gps_current = smdaI.gps(smdaI.orderVector(1),:);
            handles_gui_pause_stop_resume = guidata(obj.gui_pause_stop_resume);
            for i = 1:(length(smdaI.orderVector)-1)
                %%
                % determine which functions to execute
                g = obj.gps_current(1);
                p = obj.gps_current(2);
                s = obj.gps_current(3);
                set(handles_gui_pause_stop_resume.PSR_textTime,'String',sprintf('G:%d P:%d S:%d',g,p,s));
                drawnow;
                flagcheck_before;
                flagcheck_after(smdaI.gps(smdaI.orderVector(i+1),:),obj.gps_current);
                %%
                % detect pause event and refresh guis
                drawnow;
                while obj.pause_bool
                    pause(1);
                    set(handles_gui_pause_stop_resume.PSR_textTime,'String','PAUSED');
                    drawnow;
                    if obj.running_bool == false
                        break;
                    end
                end
                if obj.running_bool == false
                    obj.stop_acquisition;
                    return;
                end
                %%
                % execute the functions
                gps_execute;
                %%
                % update the pointers
                obj.gps_previous = obj.gps_current;
                obj.gps_current = smdaI.gps(smdaI.orderVector(i+1),:);
            end
            %%
            % for the nth entry in the gps
            g = obj.gps_current(1);
            p = obj.gps_current(2);
            s = obj.gps_current(3);
            set(handles_gui_pause_stop_resume.PSR_textTime,'String',sprintf('G:%d P:%d S:%d',g,p,s));
            drawnow;
            flagcheck_before;
            flagcheck_after([0,0,0],obj.gps_current);
            gps_execute;
            obj.gps_previous = obj.gps_current;
            obj.gps_current = [0,0,0];
            if obj.mm.twitterBool
                try
                    obj.mm.twitter.updateStatus(sprintf('Timepoint %d has been acquired by the %s microscope.',obj.t,obj.mm.computerName));
                catch
                    disp('Twitter Error!');
                end
            end
            %%
            % functions with the logic to determine which function to execute
            function flagcheck_before
                mydiff = obj.gps_current - obj.gps_previous;
                if mydiff(1) ~= 0
                    obj.flag_group_before = true;
                end
                if mydiff(2) ~= 0
                    obj.flag_position_before = true;
                end
            end
            function flagcheck_after(gps_next,gps_now)
                mydiff = gps_next - gps_now;
                if mydiff(1) ~= 0
                    obj.flag_group_after = true;
                end
                if mydiff(2) ~= 0
                    obj.flag_position_after = true;
                end
            end
            function gps_execute
                if obj.flag_group_before
                    myfun = str2func(smdaI.group_function_before{g});
                    myfun(obj);
                    obj.flag_group_before = false;
                end
                if obj.flag_position_before
                    myfun = str2func(smdaI.position_function_before{p});
                    myfun(obj);
                    obj.flag_position_before = false;
                end
                
                myfun = str2func(smdaI.settings_function{s});
                myfun(obj);
                
                if obj.flag_position_after
                    myfun = str2func(smdaI.position_function_after{p});
                    myfun(obj);
                    obj.flag_position_after = false;
                end
                if obj.flag_group_after
                    myfun = str2func(smdaI.group_function_after{g});
                    myfun(obj);
                    obj.flag_group_after = false;
                end
            end
        end
        %%
        %
        function obj = snap(obj)
            obj.mm.snapImage;
            obj.updateGuiLastImage;
            obj.runtime_imagecounter = obj.runtime_imagecounter + 1;
        end
        %%
        %
        function obj = updateGuiLastImage(obj)
            I = uint8(bitshift(obj.mm.I, -8)); %assumes 16-bit depth
            Isize = size(I);
            Iheight = Isize(1);
            Iwidth = Isize(2);
            handles = guidata(obj.gui_lastImage);
            set(handles.LIT_axesLastImage,'XLim',[1,Iwidth]);
            set(handles.LIT_axesLastImage,'YLim',[1,Iheight]);
            I2 = reshape(I,[],1);
            I2 = sort(I2);
            I = (I-I2(round(0.1*length(I2))))*(255/I2(round(0.99*length(I2))));
            set(handles.I,'CData',I);
            %% Create an informative title
            %
            i = obj.gps_current(1); %group
            j = obj.gps_current(2); %position
            k = obj.gps_current(3); %settings
            channelName = obj.mm.Channel{obj.itinerary.settings_channel(k)};
            mytitle = sprintf('Group: %d, Position: %d, Channel: %s, Timepoint: %d',i,j,channelName,obj.t);
            set(obj.gui_lastImage,'Name',mytitle);
        end
        %% delete (make sure its child objects are also deleted)
        % for a clean delete
        function delete(obj)
            delete(obj.gui_pause_stop_resume);
            delete(obj.gui_lastImage);
        end
        %% update_database
        %
        function obj = update_database(obj)
            %% update the internal smdaPect database
            %
            g = obj.gps_current(1); %group
            p = obj.gps_current(2); %position
            s = obj.gps_current(3); %settings
            z = obj.database_z_number;
            obj.mm.getXYZ;
            myGroupOrder = obj.itinerary.order_group;
            myPositionOrder = obj.itinerary.order_position{g};
            mySettingsOrder = obj.itinerary.order_settings{p};
            varNames = {'channel_name',...
                'filename',...
                'group_label',...
                'position_label',...
                'binning',...
                'channel_number',...
                'continuous_focus_offset',...
                'continuous_focus_bool',...
                'exposure',...
                'group_number',...
                'group_order',...
                'matlab_serial_date_number',...
                'position_number',...
                'position_order',...
                'settings_number',...
                'settings_order',...
                'timepoint',...
                'x',...
                'y',...
                'z',...
                'z_order',...
                'image_description'};
            myNewDatabaseRow = {...
                obj.itinerary.channel_names{obj.itinerary.settings_channel(s)},... %channel_name
                obj.itinerary.database_filenamePNG,... %filename
                obj.itinerary.group_label{g},... %group_label
                obj.itinerary.position_label{p},... %position_label
                obj.itinerary.settings_binning(s),... %binning
                obj.itinerary.settings_channel(s),... %channel_number
                obj.itinerary.position_continuous_focus_offset(p),... %continuous_focus_offset
                obj.itinerary.position_continuous_focus_bool(p),... %continuous_focus_bool
                obj.itinerary.settings_exposure(s),... %exposure
                g,... %group_number
                find(myGroupOrder == g,1,'first'),... %group_order
                now,... %matlab_serial_date_number
                p,... %position_number
                find(myPositionOrder == p,1,'first'),... %position_order,
                s,... %settings_number
                find(mySettingsOrder == s,1,'first'),... %settings_order
                obj.t,... %timepoint
                obj.mm.pos(1),...%obj.itinerary.group(g).position(p).xyz(obj.t,1),... %x
                obj.mm.pos(2),...%obj.itinerary.group(g).position(p).xyz(obj.t,2),... %y
                obj.mm.pos(3),...%     obj.itinerary.group(g).position(p).settings(s).z_origin_offset + ...%     obj.itinerary.group(g).position(p).settings(s).z_stack(z) + ...%     obj.itinerary.group(g).position(p).xyz(obj.t,3),... %z
                z,... %the order of zstack from bottom to top
                obj.database_imagedescription}; %image_description
            %%
            %
            metadataFilename = sprintf('g%d_s%d_w%d_t%d_z%d.txt',g,p,s,obj.t,z);
            fileID = fopen(fullfile(obj.itinerary.png_path,metadataFilename),'w');
            formatSpecHeader = strcat(...
                '%s\t',... %channel_name
                '%s\t',... %filename
                '%s\t',... %group_label
                '%s\t',... %position_label
                '%s\t',... %binning
                '%s\t',... %channel_number
                '%s\t',... %continuous_focus_offset
                '%s\t',... %continuous_focus_bool
                '%s\t',... %exposure
                '%s\t',... %group_number
                '%s\t',... %group_order
                '%s\t',... %matlab_serial_date_number
                '%s\t',... %position_number
                '%s\t',... %position_order,
                '%s\t',... %settings_number
                '%s\t',... %settings_order
                '%s\t',... %timepoint
                '%s\t',...%obj.itinerary.group(g).position(p).xyz(t,1),... %x
                '%s\t',...%obj.itinerary.group(g).position(p).xyz(t,2),... %y
                '%s\t',...%     obj.itinerary.group(g).position(p).settings(s).z_origin_offset + ...%     obj.itinerary.group(g).position(p).settings(s).z_stack(z) + ...%     obj.itinerary.group(g).position(p).xyz(t,3),... %z
                '%s\t',... %the order of zstack from bottom to top
                '%s\r\n'); %image_description
            formatSpecDatabaseRow = strcat(...
                '%s\t',... %channel_name
                '%s\t',... %filename
                '%s\t',... %group_label
                '%s\t',... %position_label
                '%d\t',... %binning
                '%d\t',... %channel_number
                '%1.15g\t',... %continuous_focus_offset
                '%d\t',... %continuous_focus_bool
                '%1.15g\t',... %exposure
                '%d\t',... %group_number
                '%d\t',... %group_order
                '%1.30g\t',... %matlab_serial_date_number
                '%d\t',... %position_number
                '%d\t',... %position_order,
                '%d\t',... %settings_number
                '%d\t',... %settings_order
                '%d\t',... %timepoint
                '%1.15g\t',...%obj.itinerary.group(g).position(p).xyz(t,1),... %x
                '%1.15g\t',...%obj.itinerary.group(g).position(p).xyz(t,2),... %y
                '%1.20g\t',...%     obj.itinerary.group(g).position(p).settings(s).z_origin_offset + ...%     obj.itinerary.group(g).position(p).settings(s).z_stack(z) + ...%     obj.itinerary.group(g).position(p).xyz(t,3),... %z
                '%d\t',... %the order of zstack from bottom to top
                '%s\r\n'); %image_description
            fprintf(fileID,formatSpecHeader,varNames{:});
            fprintf(fileID,formatSpecDatabaseRow,myNewDatabaseRow{:});
            fclose(fileID);
        end
    end
    %%
    %
    methods (Static)
        
    end
end