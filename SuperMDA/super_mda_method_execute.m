%%
%
function [smda] = super_mda_method_execute(smda)
disp('hello');
disp(smda.mda_clock_pointer);
smda.runtime_index(1) = smda.mda_clock_pointer;
for i2 = smda.group_order
    smda.runtime_index(2) = i2;
%    smda.group(i2).group_function_before_handle(smda);
    for j2 = smda.group(i2).position_order
        smda.runtime_index(3) = j2;
        smda.group(i2).position(j2).position_function_before_handle(smda);
        for k2 = smda.group(i2).position(j2).settings_order
            smda.runtime_index(4) = k2;
            if smda.group(i2).position(j2).settings(k2).timepoints(smda.mda_clock_pointer) == true
                %% Execute the function that will snap and save an image
                %
                smda.group(i2).position(j2).settings(k2).settings_function_handle(smda);
                writetable(smda.database,fullfile(smda.output_directory,'smda.txt'),'Delimiter','\t');
            end
        end
        smda.group(i2).position(j2).position_function_after_handle(smda);
    end
    smda.group(i2).group_function_after_handle(smda);
end
smda.mda_clock_pointer = smda.mda_clock_pointer + 1;
if smda.mda_clock_pointer > smda.number_of_timepoints
    smda.stop_acquisition;
end