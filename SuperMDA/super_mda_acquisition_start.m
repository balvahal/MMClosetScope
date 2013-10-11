%%
%
function super_mda_start_acquisition(mmhandle,SuperMDA)
%% create a dataset that contains the relevant info for each timepoint
%
channel = {};
exposure = [];
filename = {};
label_group = {};
label_position = {};
position_order = [];
x = [];
y = [];
z = [];
%% Determine the number of timepoints and the number of functions to execute
%
number_of_timepoints_in_group = zeros(1,length(SuperMDA));
number_of_functions_to_execute_per_group = zeros(1,length(SuperMDA));
number_of_functions_to_execute_total = 0;
position_order_in_group = cell(length(SuperMDA,1));
for i = 1:length(SuperMDA)
    number_of_timepoints_in_group(i) = floor(SuperMDA(i).duration/SuperMDA(i).fundamental_period) + 1;
    number_of_functions_to_execute_per_group(i) = 0;
    position_order_in_group{i} = zeros(length(SuperMDA(i).positions),1);
    for j = 1:length(SuperMDA(i).positions)
        position_order_in_group{i}(j) = SuperMDA(i).positions(j).position_order;
        for k = 1:length(SuperMDA(i).positions(j).settings)
            number_of_functions_to_execute_per_group(i) = number_of_functions_to_execute_per_group(i) + 1;
        end
    end
    number_of_functions_to_execute_total = number_of_functions_to_execute_total + number_of_timepoints_in_group(i)*number_of_functions_to_execute_per_group(i);
end

MDAhandles.stack_function = cell(number_of_functions_to_execute_total,1);
MDAhandles.stack_time_absolute = zeros(number_of_functions_to_execute_total,1);
MDAhandles.stack_time_relative = zeros(number_of_functions_to_execute_total,1);
MDAhandles.stack_pointer = 1;
counter = 0;
for i = 1:length(SuperMDA)
    for j = 1:number_of_timepoints_in_group(i)
        for k = 1:number_of_functions_to_execute_per_group(i)
            counter = counter + 1;
            
        end
    end
end

