%%
%
classdef SCAN6_object < handle
    properties
        smdaI;
        smdaTA;
        mm;
        gamepad;
        sampleList = zeros(1,6);
        gui_main;
        gui_axes;
        numberOfPositions = ones(1,6);
        ind=[]; %listboxInd
        ind2=[]; %pointsInd
        perimeterPoints = cell(1,6);
        center = zeros(2,6);
        radius = zeros(1,6);
        timerStageRefresh;
        z = zeros(1,6);
    end
    %%
    %
    methods
        %% The constructor method
        % |smdai| is the itinerary that has been initalized with the
        % micromanager core handler object
        function obj = SCAN6_object(mm,smdaI,smdaTA,gamepad)
            %%
            %
            if nargin == 0
                return
            elseif nargin == 4
                %% Initialzing the SuperMDA object
                %
                obj.smdaI = smdaI;
                obj.mm = mm;
                obj.smdaTA = smdaTA;
                %% Create a simple gui to enable pausing and stopping
                %
                obj.gui_main = SCAN6_gui_main(obj);
                obj.gui_axes = SCAN6_gui_axes(obj);
                obj.timerStageRefresh = timer('ExecutionMode','fixedRate','Period',1,'TimerFcn',@(~,~) obj.timerStageRefreshFcn);
                start(obj.timerStageRefresh);
                
                if strcmp(mm.computerName,'LAHAVSCOPE002')
                    [mfilepath,~,~] = fileparts(mfilename('fullpath'));
                    mytable = readtable(fullfile(mfilepath,'settings_LAHAVSCOPE002.txt'));
                    obj.center(1,:) = mytable.center_x;
                    obj.center(2,:) = mytable.center_y;
                    obj.radius(:) = mytable.radius;
                    obj.z = 1000*ones(1,6);
                    myAngles = [10;72;144;225;269;333];
                    handlesStageMap = guidata(obj.gui_axes);
                    handles = guidata(obj.gui_main);
                    for i = 1:6
                        obj.perimeterPoints{i} = [obj.radius(i)*cosd(myAngles)+obj.center(1,i),...
                            obj.radius(i)*sind(myAngles)+obj.center(2,i),1000*ones(numel(myAngles),1)];
                        [xc,yc,r] = deal(obj.center(1,i),obj.center(2,i),obj.radius(i));
                        % update the visuals
                        myDish = handlesStageMap.rectangleDishPerimeter{i};
                        set(myDish,'Position',[xc-r,yc-r,2*r,2*r],'Visible','on');
                        myDish2 = handles.rectangleDishPerimeter{i};
                        set(myDish2,'Position',[xc-r,yc-r,2*r,2*r],'Visible','on');
                        
                        myPPts = obj.perimeterPoints{i};
                        myPerimeter = handlesStageMap.patchPerimeterPositions{i};
                        set(myPerimeter,'XData',myPPts(:,1),'YData',myPPts(:,2),'Visible','on');
                        
                        myPerimeter2 = handles.patchPerimeterPositions{i};
                        set(myPerimeter2,'XData',myPPts(:,1),'YData',myPPts(:,2),'Visible','on');
                        
                        %%
                        % setup the gamepad for adjusting proposed
                        % positions
                        obj.gamepad = gamepad;
                        obj.gamepad.smdaITF = smdaI;
                        obj.gamepad.scan6 = obj;
                        obj.gamepad.function_button_lt = @SCAN6_gamepad_lt;
                        obj.gamepad.function_button_rt = @SCAN6_gamepad_rt;
                        obj.gamepad.function_button_lb = @SCAN6_gamepad_lb;
                        obj.gamepad.function_button_rb = @SCAN6_gamepad_rb;
                        obj.gamepad.function_button_x = @SCAN6_gamepad_x;
                        obj.gamepad.function_button_y = @SCAN6_gamepad_y;
                        obj.gamepad.function_read_controller = @SCAN6_gamepad_read_controller;
                        %obj.gamepad.connectController;
                    end
                elseif strcmp(mm.computerName,'LAHAVSCOPE0001')
                    [mfilepath,~,~] = fileparts(mfilename('fullpath'));
                    mytable = readtable(fullfile(mfilepath,'settings_LAHAVSCOPE0001.txt'));
                    obj.center(1,:) = mytable.center_x;
                    obj.center(2,:) = mytable.center_y;
                    obj.radius(:) = mytable.radius;
                    obj.z = 1000*ones(1,6);
                    myAngles = [10;72;144;225;269;333];
                    handlesStageMap = guidata(obj.gui_axes);
                    handles = guidata(obj.gui_main);
                    for i = 1:6
                        obj.perimeterPoints{i} = [obj.radius(i)*cosd(myAngles)+obj.center(1,i),...
                            obj.radius(i)*sind(myAngles)+obj.center(2,i),1000*ones(numel(myAngles),1)];
                        [xc,yc,r] = deal(obj.center(1,i),obj.center(2,i),obj.radius(i));
                        % update the visuals
                        myDish = handlesStageMap.rectangleDishPerimeter{i};
                        set(myDish,'Position',[xc-r,yc-r,2*r,2*r],'Visible','on');
                        myDish2 = handles.rectangleDishPerimeter{i};
                        set(myDish2,'Position',[xc-r,yc-r,2*r,2*r],'Visible','on');
                        
                        myPPts = obj.perimeterPoints{i};
                        myPerimeter = handlesStageMap.patchPerimeterPositions{i};
                        set(myPerimeter,'XData',myPPts(:,1),'YData',myPPts(:,2),'Visible','on');
                        
                        myPerimeter2 = handles.patchPerimeterPositions{i};
                        set(myPerimeter2,'XData',myPPts(:,1),'YData',myPPts(:,2),'Visible','on');
                        
                        %%
                        % setup the gamepad for adjusting proposed
                        % positions
                        obj.gamepad = gamepad;
                        obj.gamepad.smdaITF = smdaI;
                        obj.gamepad.scan6 = obj;
                        obj.gamepad.function_button_lt = @SCAN6_gamepad_lt;
                        obj.gamepad.function_button_rt = @SCAN6_gamepad_rt;
                        obj.gamepad.function_button_lb = @SCAN6_gamepad_lb;
                        obj.gamepad.function_button_rb = @SCAN6_gamepad_rb;
                        obj.gamepad.function_button_x = @SCAN6_gamepad_x;
                        obj.gamepad.function_read_controller = @SCAN6_gamepad_read_controller;
                        %obj.gamepad.connectController;
                    end
                elseif strcmp(mm.computerName,'KISHONYWAB111A')
                    [mfilepath,~,~] = fileparts(mfilename('fullpath'));
                    mytable = readtable(fullfile(mfilepath,'settings_KISHONYWAB111A.txt'));
                    obj.center(1,:) = mytable.center_x;
                    obj.center(2,:) = mytable.center_y;
                    obj.radius(:) = mytable.radius;
                    obj.z = 1000*ones(1,6);
                    myAngles = [10;72;144;225;269;333];
                    handlesStageMap = guidata(obj.gui_axes);
                    handles = guidata(obj.gui_main);
                    for i = 1:6
                        obj.perimeterPoints{i} = [obj.radius(i)*cosd(myAngles)+obj.center(1,i),...
                            obj.radius(i)*sind(myAngles)+obj.center(2,i),1000*ones(numel(myAngles),1)];
                        [xc,yc,r] = deal(obj.center(1,i),obj.center(2,i),obj.radius(i));
                        % update the visuals
                        myDish = handlesStageMap.rectangleDishPerimeter{i};
                        set(myDish,'Position',[xc-r,yc-r,2*r,2*r],'Visible','on');
                        myDish2 = handles.rectangleDishPerimeter{i};
                        set(myDish2,'Position',[xc-r,yc-r,2*r,2*r],'Visible','on');
                        
                        myPPts = obj.perimeterPoints{i};
                        myPerimeter = handlesStageMap.patchPerimeterPositions{i};
                        set(myPerimeter,'XData',myPPts(:,1),'YData',myPPts(:,2),'Visible','on');
                        
                        myPerimeter2 = handles.patchPerimeterPositions{i};
                        set(myPerimeter2,'XData',myPPts(:,1),'YData',myPPts(:,2),'Visible','on');
                        
                        %%
                        % setup the gamepad for adjusting proposed
                        % positions
                        obj.gamepad = gamepad;
                        obj.gamepad.smdaITF = smdaI;
                        obj.gamepad.scan6 = obj;
                        obj.gamepad.function_button_lt = @SCAN6_gamepad_lt;
                        obj.gamepad.function_button_rt = @SCAN6_gamepad_rt;
                        obj.gamepad.function_button_lb = @SCAN6_gamepad_lb;
                        obj.gamepad.function_button_rb = @SCAN6_gamepad_rb;
                        obj.gamepad.function_button_x = @SCAN6_gamepad_x;
                        obj.gamepad.function_read_controller = @SCAN6_gamepad_read_controller;
                        %obj.gamepad.connectController;
                    end
                end
            end
        end
        %% delete (make sure its child objects are also deleted)
        % for a clean delete
        %         function obj = refresh_gui_main(obj)
        %             obj = SCAN6_method_refresh_gui_main(obj);
        %         end
        %%
        %
        function obj = timerStageRefreshFcn(obj)
            SCAN6_method_timerStageRefreshFcn(obj);
        end
        %% delete (make sure its child objects are also deleted)
        % for a clean delete
        function delete(obj)
            delete(obj.gui_main);
            delete(obj.gui_axes);
            stop(obj.timerStageRefresh);
            delete(obj.timerStageRefresh);
        end
    end
end