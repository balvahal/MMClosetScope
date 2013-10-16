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
stack_time_absolute = zeros(number_of_functions_to_execute_total,1);
stack_time_relative = zeros(number_of_functions_to_execute_total,1);
MDAhandles.stack_pointer = 1;

number_group = zeros(number_of_functions_to_execute_total,1);
number_position = zeros(number_of_functions_to_execute_total,1);


counter = 0;
for i = 1:length(SuperMDA)
    for j = 1:number_of_timepoints_in_group(i)
        for k = 1:length(SuperMDA(i).positions)
            for h = 1:length(SuperMDA(i).positions(k).settings)
                
            end
        end
    end
end
%% Update the dependent parameters in the MDA object
% Some parameters in the MDA object are dependent on others. This
% dependency came about from combining parameters that are easy to
% configure by a user interface into data structures that are convenient to
% code with.
SuperMDA.configure_clock_relative;
for i = 1:length(SuperMDA.groups)
    for j = 1:length(SuperMDA.groups(i).positions)
        for k = 1:length(SuperMDA.groups(i).positions(j).settings)
            SuperMDA.groups(i).positions(j).settings(k).calculate_timepoints;
        end
    end
end
%% Execute the MDA according the the control hierarchy
% Immediately before MDA begins the absolute clock must be started...
SuperMDA.configure_clock_absolute;
%%
% Start the MDA
for t = 1:length(SuperMDA.mda_clock_absolute)
    
    %% Should I wait (and how long)?
    if t >= length(SuperMDA.mda_clock_absolute)-1
        continue
    elseif now < SuperMDA.mda_clock_absolute(t+1)
        
    else
        continue
    end
end
%% the execute_SuperMDA
    function execute_SuperMDA()
        for in = 1:length(SuperMDA.groups)
            for jn = 1:length(SuperMDA.groups(in).positions)
                for kn = 1:length(SuperMDA.groups(in).positions(jn).settings)
                    %% Update the function history database
                    %% Execute the function for this setting
                    
                end
            end
        end
    end
end