%%
% Create a position by augmenting the position_order vector and taking
% advantage of the the pre-allocation, or create a new position built on
% the |Itinerary| prototypes.
function smdaITF = SuperMDAItineraryTimeFixed_method_newPosition(smdaITF,gInd,varargin)
%%
% parse the input
p = inputParser;
addRequired(p, 'smdaITF', @(x) isa(x,'SuperMDAItineraryTimeFixed_object'));
addRequired(p, 'gInd', @(x) ismember(x,smdaITF.indOfGroup));
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
    % refer to these settings in the gps and update gps
    for i = 1:length(firstPositionSettings)
        % update gps, order vector, and settings index
        smdaITF.orderVectorInsert(myInd+i);
        smdaITF.gps(smdaITF.ind_next_gps,:) = [gInd,smdaITF.ind_next_position,firstPositionSettings(i)];
        smdaITF.gps_logical(smdaITF.ind_next_gps) = true;
        smdaITF.find_ind_next('gps');
    end
    smdaITF.find_ind_next('position');
else
    for i = 1:p.Results.pNum
        smdaITF.newPosition(gInd);
    end
end
end