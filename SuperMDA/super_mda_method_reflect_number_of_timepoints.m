%%
%
function [obj] = super_mda_method_reflect_number_of_timepoints(obj)
obj.configure_clock_relative;
for i = 1:obj.my_length
    for j = 1:obj.group(i).my_length
        % xyz
        mydiff = obj.number_of_timepoints - size(obj.group(i).position(j).xyz,1);
        if mydiff < 0
            mydiff2 = obj.number_of_timepoints+1;
            obj.group(i).position(j).xyz(mydiff2:end,:) = [];
        elseif mydiff > 0
            obj.group(i).position(j).xyz(end+1:obj.number_of_timepoints,:) = bsxfun(@times,ones(mydiff,3),obj.group(i).position(j).xyz(end,:));
        end
        for k = 1:obj.group(i).position(j).my_length
            % timepoints
            mydiff = obj.number_of_timepoints - length(obj.group(i).position(j).settings(k).timepoints);
            if mydiff < 0
                mydiff2 = obj.number_of_timepoints+1;
                obj.group(i).position(j).settings(k).timepoints(mydiff2:end) = [];
            elseif mydiff > 0
                obj.group(i).position(j).settings(k).timepoints(end+1:obj.number_of_timepoints) = 1;
            end
            % exposure
            mydiff = obj.number_of_timepoints - length(obj.group(i).position(j).settings(k).exposure);
            if mydiff < 0
                mydiff2 = obj.number_of_timepoints+1;
                obj.group(i).position(j).settings(k).exposure(mydiff2:end) = [];
            elseif mydiff > 0
                obj.group(i).position(j).settings(k).exposure(end+1:obj.number_of_timepoints) = obj.group(i).position(j).settings(k).exposure(end);
            end
        end
    end
end