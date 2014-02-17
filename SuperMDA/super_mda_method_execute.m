%%
%
function [SuperMDA] = super_mda_method_execute(SuperMDA)
SuperMDA.runtime_index(1) = SuperMDA.mda_clock_pointer;
for i2 = SuperMDA.group_order
    SuperMDA.runtime_index(2) = i2;
    SuperMDA.group(i2).group_function_before_handle(SuperMDA);
    for j2 = SuperMDA.group(i2).position_order
        SuperMDA.runtime_index(3) = j2;
        SuperMDA.group(i2).position(j2).position_function_before_handle(SuperMDA);
        for k2 = SuperMDA.group(i2).position(j2).settings_order
            SuperMDA.runtime_index(4) = k2;
            if SuperMDA.group(i2).position(j2).settings(k2).timepoints(SuperMDA.mda_clock_pointer) == true
                %% Execute the function that will snap and save an image
                %
                SuperMDA.group(i2).position(j2).settings(k2).settings_function_handle(SuperMDA);
                writetable(SuperMDA.database,fullfile(SuperMDA.output_directory,'SuperMDA.txt'),'Delimiter','\t');
            end
        end
        SuperMDA.group(i2).position(j2).position_function_after_handle(SuperMDA);
    end
    SuperMDA.group(i2).group_function_after_handle(SuperMDA);
end
SuperMDA.mda_clock_pointer = SuperMDA.mda_clock_pointer + 1;