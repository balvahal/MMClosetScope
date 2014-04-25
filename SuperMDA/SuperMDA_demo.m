mm = Core_MicroManagerHandle;
smdaI = SuperMDAItinerary(mm);
smdaP = SuperMDAPilot(smdaI);

%% Initialize the supermda
%
smdaI.newFundamentalPeriod(60); %one minutes
smdaI.newNumberOfTimepoints(5); %8 minute duration
smdaI.preAllocateMemoryAndInitialize(1,2,2);
smdaI.group.position_order = [1,2];
for i = smdaI.group.position_order
    smdaI.group.position(i).settings_order = [1,2];
end
smdaI.preAllocateDatabaseAndInitialize;

%% Configure the supermda
%
smdaI.group.position(1).xyz = [-14455.1000000000,-1859.60000000000,5347.07507967763];
smdaI.group.position(2).xyz = [-14527.6000000000,-2225.90000000000,5334.60007949173];
for i = smdaI.group.position_order
    smdaI.group.position(i).settings(1).channel = 1;
    smdaI.group.position(i).settings(1).exposure = 200;
    smdaI.group.position(i).settings(2).channel = 2;
    smdaI.group.position(i).settings(2).exposure = 100;
    smdaI.group.position(i).settings(2).binning = 2;
end

%% Beging the SuperMDA
profile on
smdaP.start_acquisition;