%%
% Create a position by augmenting the position_order vector and taking
% advantage of the the pre-allocation, or create a new position built on
% the |Itinerary| prototypes.
function smdaITF = SuperMDAItineraryTimeFixed_method_newPositionNewSettings(smdaITF,gInd,varargin)
%%
% parse the input
p = inputParser;
addRequired(p, 'smdaITF', @(x) isa(x,'SuperMDAItineraryTimeFixed_object'));
addRequired(p, 'gInd', @(x) ismember(x,smdaITF.ind_group));
addOptional(p, 'pNum',1, @(x) mod(x,1)==0);
parse(p,smdaITF,gInd,varargin{:});
mm = smdaITF.mm;
%%
%
if p.Results.pNum == 1
    %%
    % only a single position is to be added
    %
    % the position will have the xyz at the current scope position and the
    % settings will be the same as the settings for the first position in
    % this group.
    %
    pInd = smdaITF.indOfPosition(gInd);
    pInd = pInd(1); %this position is used as a template for the new position
    
    smdaITF.position_continuous_focus_offset(smdaITF.ind_next_position) = str2double(mm.core.getProperty(mm.AutoFocusDevice,'Position'));
    smdaITF.position_continuous_focus_bool(smdaITF.ind_next_position) = true;
    smdaITF.position_function_after{smdaITF.ind_next_position} = smdaITF.position_function_after{pInd};
    smdaITF.position_function_before{smdaITF.ind_next_position} = smdaITF.position_function_before{pInd};
    smdaITF.position_label{smdaITF.ind_next_position} = sprintf('position%d',smdaITF.numberOfPosition(gInd)+1);
    smdaITF.position_logical(smdaITF.ind_next_position) = true;
    pInd2 = smdaITF.gps(smdaITF.orderVector(smdaITF.ind_last_group(gInd)),2); % the position index of the last position, in terms of order, in a the group at gInd
    smdaITF.position_xyz(smdaITF.ind_next_position,:) = smdaITF.position_xyz(pInd2,:); % assigns the xyz of the new position with the xyz of the last position in the group gInd
    % find the order of the last position in the given group
    %     myPOrder = smdaITF.orderOfPosition(gInd);
    %     mySOrder = smdaITF.orderOfSettings(gInd,myPOrder(end));
    %     [~,myInd] = ismember([gInd,myPOrder(end),mySOrder(end)],smdaITF.gps,'rows');
    %     myInd = find(smdaITF.orderVector == myInd,1,'first');
    myInd = smdaITF.ind_last_group(gInd); % the index of the orderVector that specifies where the last position of gInd is located
    % find how many settings there are for position at pInd.
    firstPositionSettings = smdaITF.orderOfSettings(gInd,pInd); % the indicies of the settings found at the first position. These settings will be assigned to the new position
    smdaITF.ind_last_group(gInd) = smdaITF.ind_last_group(gInd) + length(firstPositionSettings); % the location, within the orderVector of the last position in the group gInd, is updated to reflect the addition of the new position that is now the latest last position
    % the groups that follow the group specified by gInd must also have
    % their ind_last_group updated since all positions in these groups have
    % been shifted by this new "upstream" position.
    myGroupOrder = smdaITF.orderOfGroup;
    indGroupOrder = find(myGroupOrder == gInd,1,'first'); % the order index of the group gInd
    if indGroupOrder ~= length(myGroupOrder)
        for i = (indGroupOrder+1):length(myGroupOrder)
            ix = myGroupOrder(i);
            smdaITF.ind_last_group(ix) = smdaITF.ind_last_group(ix) + length(firstPositionSettings);
        end
    end
    % create new settings
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
    % update gps, order vector, and settings index
    smdaITF.gps(smdaITF.ind_next_gps,:) = [gInd,smdaITF.ind_next_position,smdaITF.ind_next_settings];
    smdaITF.gps_logical(smdaITF.ind_next_gps) = true;
    smdaITF.orderVectorInsert(myInd+1);
    smdaITF.find_ind_next('gps');
    smdaITF.find_ind_next('settings');
    smdaITF.find_ind_next('position');
else
    for i = 1:p.Results.pNum
        smdaITF.newPositionNewSettings(gInd);
    end
end
end