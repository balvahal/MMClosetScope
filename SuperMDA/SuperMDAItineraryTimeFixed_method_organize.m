%%
% To organize the itinerary is to have the order of the groups, positions,
% and settings reflect the order of acquisition. After organization the
% _orderVector_ will be strictly increasing. Unassigned groups, positions,
% and settings will be removed.
%
% The strategy will be to organize the GPS by the _orderVector_ and then
% use the logical vectors to remove the unused rows.
function [smdaITF] = SuperMDAItineraryTimeFixed_method_organize(smdaITF)
smdaITF.refreshIndAndOrder;
%% Sort the _gps_ by the orderVector
%
myGPS = smdaITF.gps(smdaITF.orderVector,:);
%% Sort by group
%
smdaITF.orderOfGroup

smdaITF.refreshIndAndOrder;
end