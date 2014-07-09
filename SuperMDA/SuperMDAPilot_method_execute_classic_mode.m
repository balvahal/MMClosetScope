function obj = SuperMDAPilot_method_execute_classic_mode(obj)
smdaI = obj.itinerary;
obj.gps_current = smdaI.gps(obj.orderVector(1),:);
for i = 1:length(obj.orderVector)-1
    g = obj.gps_current(1);
    p = obj.gps_current(2);
    s = obj.gps_current(3);
    flagcheck_before;
    n = obj.orderVector(i+1);
    obj.gps_previous = obj.gps_current;
    obj.gps_current = smdaI.gps(obj.orderVector(n),:);
    flagcheck_after;
    gps_execute
end
g = obj.gps_current(1);
p = obj.gps_current(2);
s = obj.gps_current(3);
flagcheck_before;
obj.gps_previous = obj.gps_current;
obj.gps_current = [0,0,0];
flagcheck_after;
gps_execute


    function flagcheck_before
        mydiff = obj.gps_current - obj.gps_previous;
        if mydiff(1) ~= 0
            obj.flag_group_before = true;
        end
        if mydiff(2) ~= 0
            obj.flag_position_before = true;
        end
        if mydiff(3) ~= 0
            obj.flag_settings_before = true;
        end
    end
    function flagcheck_after
        mydiff = obj.gps_current - obj.gps_previous;
        if mydiff(1) ~= 0
            obj.flag_group_after = true;
        end
        if mydiff(2) ~= 0
            obj.flag_position_after = true;
        end
        if mydiff(3) ~= 0
            obj.flag_settings_after= true;
        end
    end
    function gps_execute
        if obj.flag_group_before
        end
        if obj.flag_position_before
        end
        if obj.flag_settings_before
        end
        if obj.flag_settings_after
        end
        if obj.flag_position_after
        end
        if obj.flag_group_after
        end
    end
end