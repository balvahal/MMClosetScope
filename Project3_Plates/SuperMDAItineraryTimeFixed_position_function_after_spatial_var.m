%%
%
function [smdaPilot] = SuperMDAItineraryTimeFixed_position_function_after_spatial_var(smdaPilot)
%%
% identify current position of SMDA
t = smdaPilot.t; %time
i = smdaPilot.gps_current(1); %group
j = smdaPilot.gps_current(2); %position
k = smdaPilot.gps_current(3); %settings
smdaITF = smdaPilot.itinerary;
%%
% find the image files for all z
z_num = round((smdaITF.settings_z_stack_upper_offset-smdaITF.settings_z_stack_lower_offset)/(smdaITF.settings_z_step_size)-0.499)+1;

for x = 1:z_num
    filenames{x} = sprintf('g%d_%s_s%d_%s_w%d_%s_t%d_z%d.tiff',i,smdaPilot.itinerary.group_label{i},j,strcat(smdaPilot.itinerary.position_label{j},''),k,smdaPilot.itinerary.channel_names{smdaPilot.itinerary.settings_channel(k)},smdaPilot.t,x);
end
%%
% calculate score for each image
parfor x2 = 1:z_num
    I = imread(fullfile(smdaPilot.itinerary.png_path,filenames{x2}));
    score(x2) = spatial_var(I);
    disp(x2);
    disp(score(x2));
end
%%
% find the z of the maximum scored image
[~,z_index] = max(score);

%%
% update the z of the position
smdaITF.position_continuous_focus_offset = smdaITF.position_continuous_focus_offset + smdaITF.settings_z_stack_lower_offset + (z_index-1)*smdaITF.settings_z_step_size;
end