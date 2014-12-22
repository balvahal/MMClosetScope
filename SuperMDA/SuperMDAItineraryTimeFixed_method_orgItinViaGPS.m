%%
% To organize the itinerary is to have the order of the groups, positions,
% and settings reflect the order of acquisition. After organization the
% _orderVector_ will be strictly increasing. Unassigned groups, positions,
% and settings will be removed.
%
% In otherwords, use the GPS _orderVector_ to rearrange the other
% information within the itinerary in the order of acquisition. Afterwards,
% update the _orderVector_ to reflect this change, which means it will be a
% simple sequence of natural numbers.
%
% The strategy will be to organize the GPS by the _orderVector_ and then
% use the logical vectors to remove the unused rows.
function [smdaITF] = SuperMDAItineraryTimeFixed_method_orgItinViaGPS(smdaITF)
smdaITF.refreshIndAndOrder;
%% Sort the _gps_ by the orderVector
%
myGPS = smdaITF.gps(smdaITF.orderVector,:);

%% Rearrange group
%
myGPS2 = myGPS;
for i = 1:length(smdaITF.order_group);
    myLogical = myGPS(:,1) == smdaITF.order_group(i);
    myGPS2(myLogical,1) = i;
end
smdaITF.group_function_after = smdaITF.group_function_after(smdaITF.order_group);
smdaITF.group_function_before = smdaITF.group_function_before(smdaITF.order_group);
smdaITF.group_label = smdaITF.group_label(smdaITF.order_group);
smdaITF.group_logical = smdaITF.group_logical(smdaITF.order_group);

%% Rearrange position
%
superOrderPosition = zeros(sum(smdaITF.position_logical),1);
positionCounter = 1;
for i = smdaITF.order_group
    superOrderPosition(positionCounter:positionCounter-1+smdaITF.number_position(i)) = ...
        smdaITF.order_position{i,:};
    positionCounter = positionCounter+smdaITF.number_position(i);
end
for i = 1:length(superOrderPosition)
    myLogical = myGPS(:,2) == superOrderPosition(i);
    myGPS2(myLogical,2) = i;
end
smdaITF.position_continuous_focus_offset = smdaITF.position_continuous_focus_offset(superOrderPosition);
smdaITF.position_continuous_focus_bool = smdaITF.position_continuous_focus_bool(superOrderPosition);
smdaITF.position_function_after = smdaITF.position_function_after(superOrderPosition);
smdaITF.position_function_before = smdaITF.position_function_before(superOrderPosition);
smdaITF.position_label = smdaITF.position_label(superOrderPosition);
smdaITF.position_logical = smdaITF.position_logical(superOrderPosition);
smdaITF.position_xyz = smdaITF.position_xyz(superOrderPosition,:);
%% Rearrange settings
%
superOrderSettings = smdaITF.order_settings(superOrderPosition);
superOrderSettings = horzcat(superOrderSettings{:});
superOrderSettings = unique(superOrderSettings,'stable');
for i = 1:length(superOrderSettings)
    myLogical = myGPS(:,3) == superOrderSettings(i);
    myGPS2(myLogical,3) = i;
end
smdaITF.settings_binning = smdaITF.settings_binning(superOrderSettings);
smdaITF.settings_channel = smdaITF.settings_channel(superOrderSettings);
smdaITF.settings_exposure = smdaITF.settings_exposure(superOrderSettings);
smdaITF.settings_function = smdaITF.settings_function(superOrderSettings);
smdaITF.settings_logical = smdaITF.settings_logical(superOrderSettings);
smdaITF.settings_period_multiplier = smdaITF.settings_period_multiplier(superOrderSettings);
smdaITF.settings_timepoints = smdaITF.settings_timepoints(superOrderSettings);
smdaITF.settings_z_origin_offset = smdaITF.settings_z_origin_offset(superOrderSettings);
smdaITF.settings_z_stack_lower_offset = smdaITF.settings_z_stack_lower_offset(superOrderSettings);
smdaITF.settings_z_stack_upper_offset = smdaITF.settings_z_stack_upper_offset(superOrderSettings);
smdaITF.settings_z_step_size = smdaITF.settings_z_step_size(superOrderSettings);
%% update GPS
%
smdaITF.gps = myGPS2;
smdaITF.orderVector = 1:size(myGPS2,1);
%%
%
smdaITF.refreshIndAndOrder;
end