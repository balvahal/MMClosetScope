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
smdaI.group.position(1).xyz = [-6589,-1.8937e3,5.51e3];
smdaI.group.position(2).xyz = [-7.0544e3,-1.9677e3,5.5024e3];
for i = smdaI.group.position_order
    smdaI.group.position(i).settings(1).channel = 2;
    smdaI.group.position(i).settings(1).exposure = 200;
    smdaI.group.position(i).settings(2).channel = 4;
    smdaI.group.position(i).settings(2).exposure = 100;
    smdaI.group.position(i).settings(2).binning = 2;
end

%% Beging the SuperMDA
smdaP.start_acquisition;