function [smdaITF] = SuperMDAItineraryTimeFixed_method_gpsFromItinOrder(smdaITF)
newGPS = zeros(sum(smdaITF.number_settings),3);
grpOrder = smdaITF.order_group;
mycount = 0;
for i = grpOrder
    posOrder = smdaITF.order_position{i};
    for j = posOrder
        setOrder = smdaITF.order_settings{j};
        for k = setOrder
            mycount = mycount + 1;
            newGPS(mycount,:) = [i,j,k];
        end
    end
end
smdaITF.gps = newGPS;
smdaITF.orderVector = 1:size(newGPS,1);
smdaITF.gps_logical = true(size(newGPS,1),1);
smdaITF.refreshIndAndOrder;
end