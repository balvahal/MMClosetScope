%%
%
classdef SCAN6_object < handle
    properties
        smdaI;
        smdaTA;
        mm;
        sampleList = zeros(1,6);
        gui_main;
        gui_axes;
        numberOfPositions = zeros(1,6);
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
                %% Create a simple gui to enable pausing and stopping
                %
                obj.gui_main = SCAN6_gui_main(obj);
                obj.gui_axes = SCAN6_gui_axes(obj);
                obj.refresh_gui_main;
                obj.timerStageRefresh = timer('ExecutionMode','fixedRate','Period',1,'TimerFcn',@(~,~) obj.timerStageRefreshFcn);
                start(obj.timerStageRefresh);
            end
        end
        %% delete (make sure its child objects are also deleted)
        % for a clean delete
        function obj = refresh_gui_main(obj)
            obj = SCAN6_method_refresh_gui_main(obj);
        end
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