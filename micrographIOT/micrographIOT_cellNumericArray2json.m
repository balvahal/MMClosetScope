%%
%
function [myjson] = micrographIOT_cellNumericArray2json(myarrayname,myarray)
if ~iscell(myarray)
    error('mIOTcna2json:notCell','The input is not a cell, so no action was taken');
elseif numel(myarray) == 1
    myjson = micrographIOT_array2json(myarrayname,myarray{1});
    return;
elseif ~isrow(myarray) && ~iscolumn(myarray)
    error('mIOTcna2json:twoDimOrMore','The cell array has more than one dimension, so no action was taken');
elseif allNumelCell(myarray) ~= numel(myarray)
    error('mIOTcna2json:nestedCell','The cell input had nested cell elements, so no action was taken');
end
myjson = sprintf('"%s": [\n[',myarrayname); %#ok<*AGROW>
if iscell(myarray)
    for i = 1:(length(myarray)-1)
        myarrayloop = myarray{i};
        if numel(myarrayloop) == 1
            myjson = horzcat(myjson,sprintf('%d],\n[',myarrayloop));
        else
            myjson = horzcat(myjson,sprintf('%d,',myarrayloop(1:end-1)));
            myjson = horzcat(myjson,sprintf('%d],\n[',myarrayloop(end)));
        end
    end
    myarrayloop = myarray{end};
    if numel(myarrayloop) == 1
        myjson = horzcat(myjson,sprintf('%d]\n]',myarrayloop));
    else
        myjson = horzcat(myjson,sprintf('%d,',myarrayloop(1:end-1)));
        myjson = horzcat(myjson,sprintf('%d]\n]',myarrayloop(end)));
    end
end
end

function n = allNumelCell(A)
    n = 0;
    for i=1:numel(A)
        if iscell(A{i})
            n = n + numel(A{i});
        else
            n = n + 1;
        end
    end
end