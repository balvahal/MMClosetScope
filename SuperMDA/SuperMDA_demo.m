mm = Core_MicroManagerHandle;
smdaI = SuperMDAItinerary(mm);
smdaP = SuperMDAPilot(smdaI);

%% Initialize the supermda
%
smdaI.newFundamentalPeriod(120); %two minutes
smdaI.newNumberOfTimepoints(5); %8 minute duration
smdaI.preAllocateMemoryAndInitialize(1,2,2);
smdaI.group.position_order = [1,2];
for i = smdaI.group.position_order
    smdaI.group.position(i).settings_order = [1,2];
end
smdaI.preAllocateDatabaseAndInitialize;

%% Configure the supermda
%
smdaI.group.position(1).xyz = [-1.4905e4,-6.4896e3,1000];
smdaI.group.position(2).xyz = [-6.6539e3,-100,1500];
smdaI.group.position(1).continuous_focus_bool = 0;
smdaI.group.position(2).continuous_focus_bool = 0;
for i = smdaI.group.position_order
    smdaI.group.position(i).settings(1).channel = 2;
    smdaI.group.position(i).settings(1).exposure = 200;
    smdaI.group.position(i).settings(2).channel = 3;
    smdaI.group.position(i).settings(2).exposure = 100;
    smdaI.group.position(i).settings(2).binning = 2;
end

%% Beging the SuperMDA
smdaP.start_acquisition;