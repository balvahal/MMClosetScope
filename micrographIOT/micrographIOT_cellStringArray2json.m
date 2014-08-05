%%
% The numbers per line will be limited to 10 for readability
function [myjson] = micrographIOT_cellStringArray2json(myarrayname,myarray)
if ~iscell(myarray)
    error('mIOTcsa2json:notCell','The input is not a cell, so no action was taken');
elseif numel(myarray) == 1
    myjson = sprintf('"%s": "%s"',myarrayname,myarray{1});
    return;
elseif ~isrow(myarray) && ~iscolumn(myarray)
    error('mIOTcsa2json:twoDimOrMore','The cell array has more than one dimension, so no action was taken');
elseif allNumelCell(myarray) ~= numel(myarray)
    error('mIOTcsa2json:nestedCell','The cell input had nested cell elements, so no action was taken');
end
myjson = sprintf('"%s": [\n',myarrayname); %#ok<*AGROW>
linecounter = 1;
if iscell(myarray)
    for i = 1:(length(myarray)-1)
        if linecounter < 10
            myjson = horzcat(myjson,sprintf('"%s",',myarray{i}));
            linecounter = linecounter + 1;
        else
            myjson = horzcat(myjson,sprintf('"%s",\n',myarray{i}));
            linecounter = 1;
        end
    end
    myjson = horzcat(myjson,sprintf('"%s"\n]',myarray{end}));
end
end

function n = allNumelCell(A)
    n = 0;
    for i=1:numel(A)
        if iscell(A{i})
            n = n + my_numel(A{i});
        else
            n = n + 1; %n = n + numel(A{i});
        end
    end
end