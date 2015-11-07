%% plates_registration
% A user-guided function to identify the ULC, URC, and LLC of a multi-well
% plate.
%
% Each point represents the center of a well.
%
% * ULC = upper left corner (x,y,z)
% * URC = upper right corner (x,y,z)
% * LLC = lower left corner (x,y,z)
function myoutput = plates_registration(mm)
%%
% 
str = sprintf('Move the microscope to the center of the upper-left-corner well.\n\nWhen ready press ''Next''.');
choice = questdlg(str, ...
    'upper-left-corner', ...
    'Next','Cancel','Cancel');
% Handle response
if strcmp(choice,'Cancel')
    return;
end
ULC = mm.getXYZ;

str = sprintf('Move the microscope to the center of the upper-right-corner well.\n\nWhen ready press ''Next''.');
choice = questdlg(str, ...
    'upper-right-corner', ...
    'Next','Cancel','Cancel');
% Handle response
if strcmp(choice,'Cancel')
    return;
end
URC = mm.getXYZ;

str = sprintf('Move the microscope to the center of the lower-left-corner well.\n\nWhen ready press ''Next''.');
choice = questdlg(str, ...
    'lower-left-corner', ...
    'Next','Cancel','Cancel');
% Handle response
if strcmp(choice,'Cancel')
    return;
end
LLC = mm.getXYZ;

myoutput = plates_multiWellPlate.vectors(ULC,URC,LLC);


end