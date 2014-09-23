%%
% The numbers per line will be limited to 10 for readability
function [myjson] = micrographIOT_nestedObject2json(mystrname,mystr)
if ~ischar(mystr)
    error('mIOTstr2json:notChar','The input is not a string of characters, so no action was taken');
elseif ~isrow(mystr) && ~iscolumn(mystr)
    error('mIOTcsa2json:twoDimOrMore','The string has more than one dimension, so no action was taken');
end
myjson = sprintf('"%s": %s',mystrname,horzcat(mystr));
end