%% super_mda_method_update_number_of_timepoints
% The ability to customize the SuperMDA lies in explicitly stating what
% will happen at each position and for each settings, such as filter
% choice, at every time point. When the number of timepoints is specified
% the arrays with the event information at the position and settings must
% be updated to reflect the number of timepoints. This function serves this
% need.
%
% Without the ability anticipate a users intentions, it was determined that
% the expansion of an array should have a default behavior: either make new
% entries equal to the last entry or, in the case of timepoints 1. If the
% number of timepoints is reduced, the excess in each array is deleted. The
% hope is that by making the SuperMDA behavior predictable a user will be
% able to program around any idiosyncrasies this creates.
function [obj] = super_mda_method_update_number_of_timepoints(obj)
for i = 1:length(obj.group)
    for j = 1:length(obj.group(i).position)
        % xyz
        mydiff = obj.number_of_timepoints - size(obj.group(i).position(j).xyz,1);
        if mydiff < 0
            mydiff2 = obj.number_of_timepoints+1;
            obj.group(i).position(j).xyz(mydiff2:end,:) = [];
        elseif mydiff > 0
            obj.group(i).position(j).xyz(end+1:obj.number_of_timepoints,:) = bsxfun(@times,ones(mydiff,3),obj.group(i).position(j).xyz(end,:));
        end
        for k = 1:length(obj.group(i).position(j).settings)
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