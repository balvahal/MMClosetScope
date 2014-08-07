%%
% This is setup to test the shutter delay on the Kishony downstairs scope.
% Setup a dish with media in the bottom left corner.

mm = Core_MicroManagerHandle;
[mfilepath,~,~] = fileparts(mfilename('fullpath'));
smdaITFPositionSource = SuperMDAItineraryTimeFixed_object(mm);
smdaITFPositionSource.import(fullfile(mfilepath,'smdaITFPositionSource.txt'));
smdaITF2 = SuperMDAItineraryTimeFixed_object(mm);

%%
%
smdaITF2.newGroup(3);
groupInds = smdaITF2.indOfGroup;
for i = transpose(groupInds)
    smdaITF2.newPosition(i,24); %25 positions in each group
end
%%
% use the source position to populate the new itinerary
n = 0;
for i = transpose(groupInds)
    positionInds = smdaITF2.indOfPosition(i);
    for j = transpose(positionInds)
        n = n + 1;
        smdaITF2.position_xyz(j,:) = smdaITFPositionSource.position_xyz(n,:);
        smdaITF2.position_continuous_focus_offset(j) = smdaITFPositionSource.position_continuous_focus_offset(n);
    end
end
%%
% change the settings for each group
for i = 1:4
    smdaITF2.settings_channel(i) = smdaITFPositionSource.settings_channel(i);
end
smdaITF2.settings_binning(:) = 4;
smdaITF2.settings_exposure(:) = 100;

smdaTA = SuperMDATravelAgent_object(smdaITF2);
smdaP = SuperMDAPilot_object(smdaITF2);