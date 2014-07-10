%%
% Create a group by augmenting the group_order vector and taking advantage
% of the the pre-allocation, or create a new group built on the |Itinerary|
% prototypes.
function smdaTA = SuperMDATravelAgent_method_addGroup(smdaTA,varargin)
%%
% parse the input
p = inputParser;
addRequired(p, 'smdaTA', @(x) isa(x,'SuperMDATravelAgent_object'));
addOptional(p,'gNum',1, @(x) mod(x,1)==0);
parse(p,smdaTA,varargin{:});
smdaITF = smdaTA.itinerary;
mm = smdaTA.mm;
%%
%
if p.Results.gNum ==1
    %%
    % only a single group is to be added
    %
    % the group will have 1 position with xyz at the current scope
    % position. The rest of the position parameters will be the same as the
    % first position. The group will have the same number of settings as
    % the first position. These will be new settings configured in the same
    % way as the first settings. These behaviors are somewhat arbitrary,
    % but provide a comfortable starting point for further modification.
    %
    % add the new group properties
    smdaITF.group_function_after{smdaITF.ind_next_group} = smdaITF.group_function_after{1};
    smdaITF.group_function_before{smdaITF.ind_next_group} = smdaITF.group_function_before{1};
    smdaITF.group_label{smdaITF.ind_next_group} = sprintf('group%d',smdaITF.ind_next_group);
    % add the new position properties reflecting the current objective
    % position
    smdaITF.position_continuous_focus_offset(smdaITF.ind_next_position) = str2double(mm.core.getProperty(mm.AutoFocusDevice,'Position'));
    smdaITF.position_continuous_focus_bool(smdaITF.ind_next_position) = true;
    smdaITF.position_function_after{smdaITF.ind_next_position} = smdaITF.position_function_after{1};
    smdaITF.position_function_before{smdaITF.ind_next_position} = smdaITF.position_function_before{1};
    smdaITF.position_label{smdaITF.ind_next_position} = 'position1';
    smdaITF.position_xyz(smdaITF.ind_next_position,:) = mm.getXYZ;
    % find how many settings there are for position 1.
    firstPositionSettings = smdaITF.indOfSettings(1,1);
    % add and copy these settings from the first position and update gps
    for i = 1:length(firstPositionSettings)
        % create new settings
        smdaITF.settings_binning(smdaITF.ind_next_settings) = smdaITF.settings_binning(firstPositionSettings(i));
        smdaITF.settings_channel(smdaITF.ind_next_settings) = smdaITF.settings_channel(firstPositionSettings(i));
        smdaITF.settings_exposure(smdaITF.ind_next_settings) = smdaITF.settings_exposure(firstPositionSettings(i));
        smdaITF.settings_function{smdaITF.ind_next_settings} = smdaITF.settings_function{firstPositionSettings(i)};
        smdaITF.settings_gain(smdaITF.ind_next_settings) = smdaITF.settings_gain(firstPositionSettings(i));
        smdaITF.settings_period_multiplier(smdaITF.ind_next_settings) = smdaITF.settings_period_multiplier(firstPositionSettings(i));
        smdaITF.settings_timepoints(smdaITF.ind_next_settings) = smdaITF.settings_timepoints(firstPositionSettings(i));
        smdaITF.settings_z_origin_offset(smdaITF.ind_next_settings) = smdaITF.settings_z_origin_offset(firstPositionSettings(i));
        smdaITF.settings_z_stack_lower_offset(smdaITF.ind_next_settings) = smdaITF.settings_z_stack_lower_offset(firstPositionSettings(i));
        smdaITF.settings_z_stack_upper_offset(smdaITF.ind_next_settings) = smdaITF.settings_z_stack_upper_offset(firstPositionSettings(i));
        smdaITF.settings_z_step_size(smdaITF.ind_next_settings) = smdaITF.settings_z_step_size(firstPositionSettings(i));
        % update gps, order vector, and settings index
        smdaITF.gps(smdaITF.ind_next_gps,:) = [smdaITF.ind_next_group,smdaITF.ind_next_position,smdaITF.ind_next_settings];
        smdaITF.orderVector(end+1) = smdaITF.ind_next_gps;
        smdaITF.ind_next_gps = smdaITF.ind_next_gps + 1;
        smdaITF.ind_next_settings = smdaITF.ind_next_settings + 1;
    end
    smdaITF.ind_next_group = smdaITF.ind_next_group + 1;
    smdaITF.ind_next_position = smdaITF.ind_next_position + 1;
    
else
    error('smdaTA:addGroupN','this part of the code needs to be created');
end
end