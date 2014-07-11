%%
% Create a position by augmenting the position_order vector and taking
% advantage of the the pre-allocation, or create a new position built on
% the |Itinerary| prototypes.
function obj = SuperMDATravelAgent_method_addSettings(obj,gInd,pInd,varargin)
%%
% parse the input
p = inputParser;
addRequired(p, 'obj', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'gInd', @(x) ismember(x,1:length(obj.itinerary.group)));
addRequired(p, 'pInd', @(x) ismember(x,1:length(obj.itinerary.group(gInd).position)));
addOptional(p, 'sNum',1, @(x) mod(x,1)==0);
parse(p,obj,gInd,pInd,varargin{:});
smdaITF = smdaTA.itinerary;
mm = smdaTA.mm;
%%
%
if p.Results.sNum == 1
    %%
    % only a single settings is to be added
    %
    % The new settings will be the same as the first settings of the first
    % position in the group that contains the pInd.
    %
    % add the new settings
    pIndFirst = smdaTA.itinerary.indOfPosition(gInd);
    pIndFirst = pIndFirst(1);
    firstPositionSettings = smdaITF.indOfSettings(gInd,pIndFirst);
    smdaITF.settings_binning(smdaITF.ind_next_settings) = smdaITF.settings_binning(firstPositionSettings(1));
    smdaITF.settings_channel(smdaITF.ind_next_settings) = smdaITF.settings_channel(firstPositionSettings(1));
    smdaITF.settings_exposure(smdaITF.ind_next_settings) = smdaITF.settings_exposure(firstPositionSettings(1));
    smdaITF.settings_function{smdaITF.ind_next_settings} = smdaITF.settings_function{firstPositionSettings(1)};
    smdaITF.settings_gain(smdaITF.ind_next_settings) = smdaITF.settings_gain(firstPositionSettings(1));
    smdaITF.settings_period_multiplier(smdaITF.ind_next_settings) = smdaITF.settings_period_multiplier(firstPositionSettings(1));
    smdaITF.settings_timepoints(smdaITF.ind_next_settings) = smdaITF.settings_timepoints(firstPositionSettings(1));
    smdaITF.settings_z_origin_offset(smdaITF.ind_next_settings) = smdaITF.settings_z_origin_offset(firstPositionSettings(1));
    smdaITF.settings_z_stack_lower_offset(smdaITF.ind_next_settings) = smdaITF.settings_z_stack_lower_offset(firstPositionSettings(1));
    smdaITF.settings_z_stack_upper_offset(smdaITF.ind_next_settings) = smdaITF.settings_z_stack_upper_offset(firstPositionSettings(1));
    smdaITF.settings_z_step_size(smdaITF.ind_next_settings) = smdaITF.settings_z_step_size(firstPositionSettings(1));
    % update gps, order vector, and settings index
    smdaITF.gps(smdaITF.ind_next_gps,:) = [gInd,pInd,smdaITF.ind_next_settings];
    % find the order of the last settings at the given position
    mySOrder = smdaTA.itinerary.orderOfSettings(gInd,pInd);
    [~,myInd] = ismember([gInd,pInd,mySOrder(end)],smdaITF.gps,'rows');
    myInd = find(smdaITF.ordervector == myInd,1,'first');
    smdaITF.orderVectorInsert(myInd);
    smdaITF.ind_next_gps = smdaITF.ind_next_gps + 1;
    smdaITF.ind_next_settings = smdaITF.ind_next_settings + 1;
else
error('smdaTA:addSettingsN','this part of the code needs to be created');
end
end