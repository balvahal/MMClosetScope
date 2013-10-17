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
%% Update the dependent parameters in the MDA object
% Some parameters in the MDA object are dependent on others. This
% dependency came about from combining parameters that are easy to
% configure by a user interface into data structures that are convenient to
% code with.
SuperMDA.configure_clock_relative;
for i1 = 1:length(SuperMDA.groups)
    for j1 = 1:length(SuperMDA.groups(i1).positions)
        for k1 = 1:length(SuperMDA.groups(i1).positions(j1).settings)
            SuperMDA.groups(i1).positions(j1).settings(k1).calculate_timepoints;
            SuperMDA.groups(i1).positions(j1).settings(k1).snap_function_handle = str2func(SuperMDA.groups(i1).positions(j1).settings(k1).snap_function_name);
        end
    end
end
%% Execute the MDA
% Immediately before MDA begins the absolute clock must be started...
SuperMDA.configure_clock_absolute;
%%
% Start the MDA
counter = 1;
timer_mda = timer('TimerFcn',@execute_SuperMDA);
while counter <= length(SuperMDA.mda_clock_absolute)
    if strcmp(timer_mda.Running,'off') && now < SuperMDA.mda_clock_absolute(counter)
        startat(timer_mda,SuperMDA.mda_clock_absolute(counter));
        counter = counter + 1;
    elseif strcmp(timer_mda.Running,'off') && now > SuperMDA.mda_clock_absolute(counter)
        execute_SuperMDA;
        counter = counter + 1;
    end
end
%% execute_SuperMDA, a nested function
    function execute_SuperMDA(~,~)
        for i2 = 1:length(SuperMDA.groups)
            for j2 = 1:length(SuperMDA.groups(i2).positions)
                for k2 = 1:length(SuperMDA.groups(i2).positions(j2).settings)
                    %% Update the function history database
                    
                    %% Execute the function for this setting
                    SuperMDA.groups(i2).positions(j2).settings(k2).snap_function_handle(SuperMDA,[i2,j2,k2]);
                end
            end
        end
    end
end