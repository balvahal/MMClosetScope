%%
% The input file must not already contain indents. Also, the input file
% must have closing brackets *"}"* and *"]"* that are alone on their own
% line followed by a comma.
function [myjson] = micrographIOT_autoIndentJson(filename)
fid = fopen(filename,'r');
if fid == -1
    error('mIOTautoIndent:badfile','Cannot open the file for autoindentation');
end
indentCount = 0;
indentStr = '';
tline = fgetl(fid);
myjson = ''; %#ok<*AGROW>
while ischar(tline)
    lastInLine2 = regexp(tline,'(},$|],$)','lineanchors');
    if isempty(lastInLine2)
        lastInLine2 = regexp(tline,'(}$|]$)','lineanchors');
    end
    if ~isempty(lastInLine2) && numel(tline) <= 2
        indentCount = indentCount - 1;
        if indentCount == 0
            indentStr = '';
        else
            indentStr = indentStr(1:end-1);
        end
    end
    if indentCount > 0
        myjson = horzcat(myjson,indentStr,tline,sprintf('\n'));
    else
        myjson = horzcat(myjson,tline,sprintf('\n'));
    end
    lastInLine = regexp(tline,'({$|[$)','lineanchors');
    if ~isempty(lastInLine)
        indentCount = indentCount + 1;
        indentStr = horzcat(indentStr,sprintf('\t'));
    end
    tline = fgetl(fid);
end
fclose(fid);
end