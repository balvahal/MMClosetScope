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
        timer_scan6;
        mapRefreshCounter
        z = zeros(1,6);
    end
    %%
    %
    methods
        %% The constructor method
        % |smdai| is the itinerary that has been initalized with the
        % micromanager core handler object
        function obj = SCAN6_object(mm,smdaI,smdaTA)
            %%
            %
            if nargin == 0
                return
            elseif nargin == 3
                %% Initialzing the SuperMDA object
                %
                obj.smdaI = smdaI;
                obj.mm = mm;
                obj.smdaTA = smdaTA;
                obj.gamepad = SCAN6_gamepad_object(mm);
                obj.gamepad.smdaITF = smdaI;
                obj.gamepad.scan6 = obj;
                %% Create a simple gui to enable pausing and stopping
                %
                obj.gui_main = SCAN6_gui_main(obj);
                obj.gui_axes = SCAN6_gui_axes(obj);
                obj.mapRefreshCounter = 1;
                obj.timer_scan6 = timer('ExecutionMode','fixedRate','BusyMode','drop','Period',.04,'TimerFcn',@(~,~) obj.timer_scan6Fcn);
                start(obj.timer_scan6);
                [mfilepath,~,~] = fileparts(mfilename('fullpath'));
                mytable = readtable(fullfile(mfilepath,sprintf('settings_%s.txt',obj.mm.computerName)));
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
                end
                %                 if strcmp(mm.computerName,'LAHAVSCOPE002')
                %                     [mfilepath,~,~] = fileparts(mfilename('fullpath'));
                %                     mytable = readtable(fullfile(mfilepath,'settings_LAHAVSCOPE002.txt'));
                %                     obj.center(1,:) = mytable.center_x;
                %                     obj.center(2,:) = mytable.center_y;
                %                     obj.radius(:) = mytable.radius;
                %                     obj.z = 1000*ones(1,6);
                %                     myAngles = [10;72;144;225;269;333];
                %                     handlesStageMap = guidata(obj.gui_axes);
                %                     handles = guidata(obj.gui_main);
                %                     for i = 1:6
                %                         obj.perimeterPoints{i} = [obj.radius(i)*cosd(myAngles)+obj.center(1,i),...
                %                             obj.radius(i)*sind(myAngles)+obj.center(2,i),1000*ones(numel(myAngles),1)];
                %                         [xc,yc,r] = deal(obj.center(1,i),obj.center(2,i),obj.radius(i));
                %                         % update the visuals
                %                         myDish = handlesStageMap.rectangleDishPerimeter{i};
                %                         set(myDish,'Position',[xc-r,yc-r,2*r,2*r],'Visible','on');
                %                         myDish2 = handles.rectangleDishPerimeter{i};
                %                         set(myDish2,'Position',[xc-r,yc-r,2*r,2*r],'Visible','on');
                %
                %                         myPPts = obj.perimeterPoints{i};
                %                         myPerimeter = handlesStageMap.patchPerimeterPositions{i};
                %                         set(myPerimeter,'XData',myPPts(:,1),'YData',myPPts(:,2),'Visible','on');
                %
                %                         myPerimeter2 = handles.patchPerimeterPositions{i};
                %                         set(myPerimeter2,'XData',myPPts(:,1),'YData',myPPts(:,2),'Visible','on');
                %                     end
                %                 elseif strcmp(mm.computerName,'LAHAVSCOPE0001')
                %                     [mfilepath,~,~] = fileparts(mfilename('fullpath'));
                %                     mytable = readtable(fullfile(mfilepath,'settings_LAHAVSCOPE0001.txt'));
                %                     obj.center(1,:) = mytable.center_x;
                %                     obj.center(2,:) = mytable.center_y;
                %                     obj.radius(:) = mytable.radius;
                %                     obj.z = 1000*ones(1,6);
                %                     myAngles = [10;72;144;225;269;333];
                %                     handlesStageMap = guidata(obj.gui_axes);
                %                     handles = guidata(obj.gui_main);
                %                     for i = 1:6
                %                         obj.perimeterPoints{i} = [obj.radius(i)*cosd(myAngles)+obj.center(1,i),...
                %                             obj.radius(i)*sind(myAngles)+obj.center(2,i),1000*ones(numel(myAngles),1)];
                %                         [xc,yc,r] = deal(obj.center(1,i),obj.center(2,i),obj.radius(i));
                %                         % update the visuals
                %                         myDish = handlesStageMap.rectangleDishPerimeter{i};
                %                         set(myDish,'Position',[xc-r,yc-r,2*r,2*r],'Visible','on');
                %                         myDish2 = handles.rectangleDishPerimeter{i};
                %                         set(myDish2,'Position',[xc-r,yc-r,2*r,2*r],'Visible','on');
                %
                %                         myPPts = obj.perimeterPoints{i};
                %                         myPerimeter = handlesStageMap.patchPerimeterPositions{i};
                %                         set(myPerimeter,'XData',myPPts(:,1),'YData',myPPts(:,2),'Visible','on');
                %
                %                         myPerimeter2 = handles.patchPerimeterPositions{i};
                %                         set(myPerimeter2,'XData',myPPts(:,1),'YData',myPPts(:,2),'Visible','on');
                %                     end
                %                 elseif strcmp(mm.computerName,'KISHONYWAB111A')
                %                     [mfilepath,~,~] = fileparts(mfilename('fullpath'));
                %                     mytable = readtable(fullfile(mfilepath,'settings_KISHONYWAB111A.txt'));
                %                     obj.center(1,:) = mytable.center_x;
                %                     obj.center(2,:) = mytable.center_y;
                %                     obj.radius(:) = mytable.radius;
                %                     obj.z = 1000*ones(1,6);
                %                     myAngles = [10;72;144;225;269;333];
                %                     handlesStageMap = guidata(obj.gui_axes);
                %                     handles = guidata(obj.gui_main);
                %                     for i = 1:6
                %                         obj.perimeterPoints{i} = [obj.radius(i)*cosd(myAngles)+obj.center(1,i),...
                %                             obj.radius(i)*sind(myAngles)+obj.center(2,i),1000*ones(numel(myAngles),1)];
                %                         [xc,yc,r] = deal(obj.center(1,i),obj.center(2,i),obj.radius(i));
                %                         % update the visuals
                %                         myDish = handlesStageMap.rectangleDishPerimeter{i};
                %                         set(myDish,'Position',[xc-r,yc-r,2*r,2*r],'Visible','on');
                %                         myDish2 = handles.rectangleDishPerimeter{i};
                %                         set(myDish2,'Position',[xc-r,yc-r,2*r,2*r],'Visible','on');
                %
                %                         myPPts = obj.perimeterPoints{i};
                %                         myPerimeter = handlesStageMap.patchPerimeterPositions{i};
                %                         set(myPerimeter,'XData',myPPts(:,1),'YData',myPPts(:,2),'Visible','on');
                %
                %                         myPerimeter2 = handles.patchPerimeterPositions{i};
                %                         set(myPerimeter2,'XData',myPPts(:,1),'YData',myPPts(:,2),'Visible','on');
                %                     end
            end
        end
        
        %% delete (make sure its child objects are also deleted)
        % for a clean delete
        %         function obj = refresh_gui_main(obj)
        %             obj = SCAN6_method_refresh_gui_main(obj);
        %         end
        %%
        %
        function obj = timer_scan6Fcn(obj)
            SCAN6_timer_function(obj);
        end
        %% delete (make sure its child objects are also deleted)
        % for a clean delete
        function delete(obj)
            stop(obj.timer_scan6);
            delete(obj.timer_scan6);
            delete(obj.gui_main);
            delete(obj.gui_axes);
            delete(obj.gamepad);
        end
    end
end