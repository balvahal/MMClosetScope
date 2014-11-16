%%
% The numbers per line will be limited to 10 for readability
function [myjson] = micrographIOT_2dmatrix2json(myarrayname,myarray)
if numel(myarray) == 1
    error('mIOT2dmat2json:one','The matrix input only had one element, so no action was taken');
elseif (ismatrix(myarray) && isrow(myarray)) || (ismatrix(myarray) && iscolumn(myarray))
    myjson = micrographIOT_array2json(myarrayname,myarray);
    return
elseif ~ismatrix(myarray) || iscolumn(myarray) || isrow(myarray)
    error('mIOT2dmat2json:notTwoDim','The matrix did not have 2 dimensions, so no action was taken');
end
myjson = sprintf('"%s": [\n[',myarrayname); %#ok<*AGROW>

if isnumeric(myarray) || islogical(myarray)
    for i = 1:(size(myarray,1)-1)
        myjson = horzcat(myjson,sprintf('%d,',myarray(i,1:end-1)));
        myjson = horzcat(myjson,sprintf('%d],\n[',myarray(i,end)));
    end
    myjson = horzcat(myjson,sprintf('%d,',myarray(end,1:end-1)));
    myjson = horzcat(myjson,sprintf('%d]\n]',myarray(end,end)));
end
end