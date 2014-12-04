function [smdaITF] = SuperMDAItineraryTimeFixed_method_refreshIndAndOrder(smdaITF)
%% Indices
%
%%% ind_group
%
gpsGrp = 1:length(smdaITF.group_logical);
smdaITF.ind_group = gpsGrp(smdaITF.group_logical);
%%% ind_next_gps
%
if any(~smdaITF.gps_logical)
    smdaITF.ind_next_gps = find(~smdaITF.gps_logical,1,'first');
else
    smdaITF.ind_next_gps = length(smdaITF.gps_logical) + 1;
end
%%% ind_next_group
%
if any(~smdaITF.group_logical)
    smdaITF.ind_next_group = find(~smdaITF.group_logical,1,'first');
else
    smdaITF.ind_next_group = length(smdaITF.group_logical) + 1;
end
%%% ind_next_position
%
if any(~smdaITF.position_logical)
    smdaITF.ind_next_position = find(~smdaITF.position_logical,1,'first');
else
    smdaITF.ind_next_position = length(smdaITF.position_logical) + 1;
end
%%% ind_next_settings
%
if any(~smdaITF.settings_logical)
    smdaITF.ind_next_settings = find(~smdaITF.settings_logical,1,'first');
else
    smdaITF.ind_next_settings = length(smdaITF.settings_logical) + 1;
end
%%% ind_position
%
smdaITF.ind_position = cell(length(smdaITF.group_logical),1);
for i = smdaITF.ind_group
    gpsPosLogical = smdaITF.gps(:,1) == i;
    gpsPos = smdaITF.gps(gpsPosLogical,2);
    smdaITF.ind_position{i} = transpose(unique(gpsPos,'sorted'));
end
%%% ind_settings
%
smdaITF.ind_settings = cell(length(smdaITF.position_logical),1);
for i = smdaITF.ind_group
    posInd = smdaITF.ind_position{i};
    gpsPosLogical = smdaITF.gps(:,1) == i;
    for j = posInd
        gpsSetLogical = smdaITF.gps(:,2) == j;
        gpsSet = smdaITF.gps(gpsPosLogical & gpsSetLogical,3);
        smdaITF.ind_settings{j} = transpose(unique(gpsSet,'sorted'));
    end
end
%%% order_group
%
gpsOrder = smdaITF.gps(smdaITF.orderVector,:);
gpsGrp = gpsOrder(:,1);
smdaITF.order_group = transpose(unique(gpsGrp,'stable'));
%%% order_position
%
smdaITF.order_position = cell(length(smdaITF.group_logical),1);
for i = smdaITF.ind_group
    gpsPosLogical = gpsOrder(:,1) == i;
    gpsPos = gpsOrder(gpsPosLogical,2);
    smdaITF.order_position{i} = transpose(unique(gpsPos,'stable'));
end
%%% order_settings
%
smdaITF.order_settings = cell(length(smdaITF.position_logical),1);
for i = smdaITF.ind_group
    posInd = smdaITF.ind_position{i};
    gpsPosLogical = gpsOrder(:,1) == i;
    for j = posInd
        gpsSetLogical = gpsOrder(:,2) == j;
        gpsSet = gpsOrder(gpsPosLogical & gpsSetLogical,3);
        smdaITF.order_settings{j} = transpose(unique(gpsSet,'stable'));
    end
end
%%% ind_first_group
%
smdaITF.ind_first_group = zeros(length(smdaITF.group_logical),1);
for i = smdaITF.ind_group
    smdaITF.ind_first_group(i) = find(gpsGrp(:,1) == i,1,'first');
end
%%% ind_last_group
%
smdaITF.ind_last_group = zeros(length(smdaITF.group_logical),1);
for i = smdaITF.ind_group
    smdaITF.ind_last_group(i) = find(gpsGrp(:,1) == i,1,'last');
end
end