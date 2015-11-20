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
myoutput.rownum = input('How many rows are in the multi-well plate?\n');
myoutput.colnum = input('How many columns are in the multi-well plate?\n');

str = sprintf('Move the microscope to the center of the UPPER-LEFT-CORNER well.\n\nWhen ready press ''Next''.');
choice = questdlg(str, ...
    'upper-left-corner', ...
    'Next','Cancel','Cancel');
% Handle response
if strcmp(choice,'Cancel')
    myoutput = [];
    return;
end
myoutput.ULC = mm.getXYZ;

str = sprintf('Move the microscope to the center of the UPPER-RIGHT-CORNER well.\n\nWhen ready press ''Next''.');
choice = questdlg(str, ...
    'upper-right-corner', ...
    'Next','Cancel','Cancel');
% Handle response
if strcmp(choice,'Cancel')
    myoutput = [];
    return;
end
myoutput.URC = mm.getXYZ;

str = sprintf('Move the microscope to the center of the LOWER-LEFT-CORNER well.\n\nWhen ready press ''Next''.');
choice = questdlg(str, ...
    'lower-left-corner', ...
    'Next','Cancel','Cancel');
% Handle response
if strcmp(choice,'Cancel')
    myoutput = [];
    return;
end
myoutput.LLC = mm.getXYZ;

myoutput = plates_multiWellPlate.vectors(ULC,URC,LLC,rownum,colnum);
end