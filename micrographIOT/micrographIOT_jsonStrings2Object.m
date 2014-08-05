function [myjson] = micrographIOT_jsonStrings2Object(jsonStrings)
myjson = sprintf('{\n'); %#ok<*AGROW>
for i = 1:(length(jsonStrings) - 1)
    myjson = horzcat(myjson,jsonStrings{i},sprintf(',\n'));
end
myjson = horzcat(myjson,jsonStrings{end},sprintf('\n}'));
end