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
smdaI.group.position(1).xyz = [-10181.5000000000,-5736.30000000000,5584.62508321740];
smdaI.group.position(2).xyz = [-10058.9000000000,-5969.30000000000,5592.12508332916];
for i = smdaI.group.position_order
    smdaI.group.position(i).settings(1).channel = 2;
    smdaI.group.position(i).settings(1).exposure = 200;
    smdaI.group.position(i).settings(2).channel = 4;
    smdaI.group.position(i).settings(2).exposure = 100;
    smdaI.group.position(i).settings(2).binning = 2;
end

%% Beging the SuperMDA
smdaP.start_acquisition;