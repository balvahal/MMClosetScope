%%
% Create a position by augmenting the position_order vector and taking
% advantage of the the pre-allocation, or create a new position built on
% the |Itinerary| prototypes.
function smdaITF = SuperMDAItineraryTimeFixed_method_newSettings(smdaITF,gInd,pInd,varargin)
%%
% parse the input
p = inputParser;
addRequired(p, 'smdaITF', @(x) isa(x,'SuperMDAItineraryTimeFixed_object'));
addRequired(p, 'gInd', @(x) ismember(x,smdaITF.ind_group));
addRequired(p, 'pInd', @(x) ismember(x,smdaITF.indOfPosition(gInd)));
addOptional(p, 'sNum',1, @(x) mod(x,1)==0);
parse(p,smdaITF,gInd,pInd,varargin{:});

%%
%
if p.Results.sNum == 1
    %%
    % only a single settings is to be added
    %
    % add the new settings
    firstPositionSettings = smdaITF.indOfSettings(gInd,pInd);
    smdaITF.settings_binning(smdaITF.ind_next_settings) = smdaITF.settings_binning(firstPositionSettings(1));
    smdaITF.settings_channel(smdaITF.ind_next_settings) = smdaITF.settings_channel(firstPositionSettings(1));
    smdaITF.settings_exposure(smdaITF.ind_next_settings) = smdaITF.settings_exposure(firstPositionSettings(1));
    smdaITF.settings_function{smdaITF.ind_next_settings} = smdaITF.settings_function{firstPositionSettings(1)};
    smdaITF.settings_logical(smdaITF.ind_next_settings) = true;
    smdaITF.settings_period_multiplier(smdaITF.ind_next_settings) = smdaITF.settings_period_multiplier(firstPositionSettings(1));
    smdaITF.settings_timepoints(smdaITF.ind_next_settings) = smdaITF.settings_timepoints(firstPositionSettings(1));
    smdaITF.settings_z_origin_offset(smdaITF.ind_next_settings) = smdaITF.settings_z_origin_offset(firstPositionSettings(1));
    smdaITF.settings_z_stack_lower_offset(smdaITF.ind_next_settings) = smdaITF.settings_z_stack_lower_offset(firstPositionSettings(1));
    smdaITF.settings_z_stack_upper_offset(smdaITF.ind_next_settings) = smdaITF.settings_z_stack_upper_offset(firstPositionSettings(1));
    smdaITF.settings_z_step_size(smdaITF.ind_next_settings) = smdaITF.settings_z_step_size(firstPositionSettings(1));
    % find the order of the last settings at the given position
    mySOrder = smdaITF.orderOfSettings(gInd,pInd);
    [~,myInd] = ismember([gInd,pInd,mySOrder(end)],smdaITF.gps,'rows');
    myInd = find(smdaITF.orderVector == myInd,1,'first');
    smdaITF.orderVectorInsert(myInd+1);
    % update gps, order vector, and settings index
    smdaITF.gps(smdaITF.ind_next_gps,:) = [gInd,pInd,smdaITF.ind_next_settings];
    smdaITF.gps_logical(smdaITF.ind_next_gps) = true;
    smdaITF.find_ind_next('gps');
    smdaITF.find_ind_next('settings');
    smdaITF.ind_last_group(gInd) = smdaITF.ind_last_group(gInd) + 1;
else
error('smdaITF:addSettingsN','this part of the code needs to be created');
end
end