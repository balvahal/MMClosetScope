%%
% The numbers per line will be limited to 10 for readability
function [myjson] = micrographIOT_array2json(myarrayname,myarray)
if numel(myarray) == 1
    error('mIOTary2json:one','The array input only had one element and no action was taken');
elseif ~isrow(myarray) && ~iscolumn(myarray)
    error('mIOTary2json:twoDimOrMore','The array has more than one dimension');
end
myjson = sprintf('"%s": [\n',myarrayname); %#ok<*AGROW>
linecounter = 1;
if isnumeric(myarray)
    for i = 1:(length(myarray)-1)
        if linecounter < 10
            myjson = horzcat(myjson,sprintf('%d,',myarray(i))); 
            linecounter = linecounter + 1;
        else
            myjson = horzcat(myjson,sprintf('%d,\n',myarray(i))); 
            linecounter = 1;
        end
    end
    myjson = horzcat(myjson,sprintf('%d\n]\n',myarray(end)));
end
end