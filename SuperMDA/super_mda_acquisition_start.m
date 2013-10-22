%%
%
function super_mda_start_acquisition(mmhandle,SuperMDA)
%% create a dataset that contains the relevant info for each timepoint
%
finalize_MDA;
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
    else
        %%
        % Here is the code block where the while loop runs in between
        % execution of the MDA
        
    end
end

%% Save a history of the MDA execution and the images created to a CSV file
%
export(SuperMDA.database_filenames,'File',fullfile(SuperMDA.output_directory,'SuperMDA_database_filenames.csv'),'Delimiter',',');
%% Nested Functions
%
%% execute_SuperMDA
%
    function execute_SuperMDA(~,~)
        for i2 = 1:length(SuperMDA.groups)
            mmhandle = SuperMDA.groups(i2).group_function_before_handle(mmhandle,SuperMDA,i2);
            for j2 = 1:length(SuperMDA.groups(i2).positions)
                mmhandle = SuperMDA.groups(i2).positions(j2).position_function_before_handle(mmhandle,SuperMDA,i2,j2);
                for k2 = 1:length(SuperMDA.groups(i2).positions(j2).settings)
                    if SuperMDA.groups(i2).positions(j2).settings(k2).timepoints(counter) == true
                        %% Update the function history database
                        
                        %% Execute the function for this setting
                        mmhandle = SuperMDA.groups(i2).positions(j2).settings(k2).snap_function_handle(mmhandle,SuperMDA,i2,j2,k2,counter);
                    end
                end
                mmhandle = SuperMDA.groups(i2).positions(j2).position_function_after_handle(mmhandle,SuperMDA,i2,j2);
            end
            mmhandle = SuperMDA.groups(i2).group_function_after_handle(mmhandle,SuperMDA,i2);
        end
    end

%% finalize_MDA
%
    function finalize_MDA()
        %% Update the dependent parameters in the MDA object
        % Some parameters in the MDA object are dependent on others. This
        % dependency came about from combining parameters that are easy to
        % configure by a user interface into data structures that are convenient to
        % code with.
        SuperMDA.configure_clock_relative;
        max_number_of_images = 0;
        for i1 = 1:length(SuperMDA.groups)
            SuperMDA.groups(i1).group_function_handle = str2func(SuperMDA.groups(i1).group_function_name);
            for j1 = 1:length(SuperMDA.groups(i1).positions)
                SuperMDA.groups(i1).positions(j1).position_function_handle = str2func(SuperMDA.groups(i1).positions(j1).position_function_name);
                for k1 = 1:length(SuperMDA.groups(i1).positions(j1).settings)
                    SuperMDA.groups(i1).positions(j1).settings(k1).calculate_timepoints;
                    SuperMDA.groups(i1).positions(j1).settings(k1).snap_function_handle = str2func(SuperMDA.groups(i1).positions(j1).settings(k1).snap_function_name);
                    max_number_of_images = max_number_of_images + 1;
                end
            end
        end
        %%
        % initialize the dataset array that will store the history of the MDA. The
        % maximum number of images that can be taken by the MDA are also the
        % maximum number of rows in the dataset.
        max_number_of_images = max_number_of_images*length(SuperMDA.mda_clock_absolute);
        VarNames_strings = {...
            'Channel_name',...
            'filename',...
            'group_label',...
            'position_label'};
        VarNames_numeric = {...
            'binning',...
            'Channel_number',...
            'continuous_focus_offset',...
            'exposure',...
            'matlab_serial_date_number',...
            'position_order',...
            'timepoint',...
            'x',...
            'y',...
            'z'};
        database_strings = cell(max_number_of_images+1,length(VarNames_strings));
        database_strings(1,:) = VarNames_strings;
        [database_strings{2:end,:}] = deal('');
        database_numeric = cell(max_number_of_images+1,length(VarNames_numeric));
        database_numeric(1,:) = VarNames_numeric;
        [database_numeric{2:end,:}] = deal(0);
        SuperMDA.database_filenames = horzcat(database_strings,database_numeric);
    end
end