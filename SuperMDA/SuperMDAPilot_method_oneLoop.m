%% SuperMDAPilot_method_oneLoop
% Perform a single pass through the multi-diminensional acquisition as
% detailed in the SuperMDAItinerary_object.
function smdaP = SuperMDAPilot_method_oneLoop(smdaP)
%%
% for the n-1 entries in the gps
smdaI = smdaP.itinerary;
smdaP.gps_current = smdaI.gps(smdaP.orderVector(1),:);
for i = 1:length(smdaP.orderVector)-1
    %%
    % determine which functions to execute
    g = smdaP.gps_current(1);
    p = smdaP.gps_current(2);
    s = smdaP.gps_current(3);
    flagcheck_before;
    n = smdaP.orderVector(i+1);
    smdaP.gps_previous = smdaP.gps_current;
    smdaP.gps_current = smdaI.gps(smdaP.orderVector(n),:);
    flagcheck_after;
    %%
    % detect pause event and refresh guis
    smdaP.runtime_index(2) = i;
    drawnow;
    while smdaP.pause_bool
        pause(1);
        disp('i am paused');
        if smdaP.running_bool == false
            return;
        end
    end
    %%
    % execute the functions
    gps_execute;
end
%%
% for the nth entry in the gps
g = smdaP.gps_current(1);
p = smdaP.gps_current(2);
s = smdaP.gps_current(3);
flagcheck_before;
smdaP.gps_previous = smdaP.gps_current;
smdaP.gps_current = [0,0,0];
flagcheck_after;
gps_execute;

%%
% functions with the logic to determine which function to execute
    function flagcheck_before
        mydiff = smdaP.gps_current - smdaP.gps_previous;
        if mydiff(1) ~= 0
            smdaP.flag_group_before = true;
        end
        if mydiff(2) ~= 0
            smdaP.flag_position_before = true;
        end
    end
    function flagcheck_after
        mydiff = smdaP.gps_current - smdaP.gps_previous;
        if mydiff(1) ~= 0
            smdaP.flag_group_after = true;
        end
        if mydiff(2) ~= 0
            smdaP.flag_position_after = true;
        end
    end
    function gps_execute
        if smdaP.flag_group_before
            myfun = str2func(smdaI.group_function_before(g));
            myfun(smdaP);
            smdaP.flag_group_before = false;
        end
        if smdaP.flag_position_before
            myfun = str2func(smdaI.position_function_before(p));
            myfun(smdaP);
            smdaP.flag_position_before = false;
        end
        
        myfun = str2func(smdaI.settings_function(s));
        myfun(smdaP);
        
        if smdaP.flag_position_after
            myfun = str2func(smdaI.position_function_after(p));
            myfun(smdaP);
            smdaP.flag_position_after = false;
        end
        if smdaP.flag_group_after
            myfun = str2func(smdaI.group_function_after(g));
            myfun(smdaP);
            smdaP.flag_group_after = false;
        end
    end
end