%%
% The numbers per line will be limited to 10 for readability
function [myjson] = micrographIOT_array2json(myarrayname,myarray)
if numel(myarray) == 1
    myjson = sprintf('"%s": %d',myarrayname,myarray);
    return
elseif numel(myarray) == 0
    myjson = sprintf('"%s": 0',myarrayname);
    return
elseif ~isrow(myarray) && ~iscolumn(myarray)
    error('mIOTary2json:twoDimOrMore','The array has more than one dimension, so no action was taken');
end
myjson = sprintf('"%s": [\n',myarrayname); %#ok<*AGROW>
if isnumeric(myarray) || islogical(myarray)
    for i = 1:(length(myarray)-1)
            myjson = horzcat(myjson,sprintf('%d,',myarray(i)));
    end
    myjson = horzcat(myjson,sprintf('%d\n]',myarray(end)));
end
end