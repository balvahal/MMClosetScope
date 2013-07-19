%% Command Line User Interface to collect 6-well spatial information
% The goal is to identify the center of each plate. Determine if the plate
% is flat. Collect a reference image.
%% Inputs
% * mmhandle
%% Outputs
% * pcell = a 2 x 3 cell that contains the perimeter data for the 6-well
% format
function [mmhandle] = SCAN6commandline_6WellMap(mmhandle)
%% Initialize common user prompts and variables
%
pcell = cell(2,3);
%%
% countWell = a variable from 1 to 6. Represents which well data is being
% collected on. Well format is [1,2,3;4,5,6];
countWell = 1;
strGreet = ['Hello! and welcome to the 6-well command line map function.\n' ...
    'There are 3 steps to this process\n\n'...
    'First, at least 3 points along the perimeter must be chosen.\n'...
    'Second, four positions with the dish are chosen to see that\n'...
    'each plate is level.\n' ...
    'Third, a reference image is chosen that can be used to realign\n'...
    'your plate, should it be moved.\n\n'];
strWellStatus = 'Well %d\n';
strMenu = ['Return ''p'' to save data about perimeter\n'...
    'Return ''r'' to remove the last data point\n'...
    'Press ''enter'' to move to the next well\n'];
%%
%
fprintf(strGreet);
fprintf(strWellStatus,countWell);
pdata = [];
reply = input(strMenu,'s');
while reply ~= 1
    %%
    %
    switch lower(reply)
        case 'p'
            mmhandle = SCAN6general_getXYZ(mmhandle);
            pdata(end+1,1:2) = mmhandle.pos(1:2); %#ok<*AGROW>
            fprintf(strWellStatus,countWell);
            pStatus(pdata);
            reply = input(strMenu,'s');
        case 'r'
            if ~isempty(pdata)
                pdata(end,:) = [];
            end
            fprintf(strWellStatus,countWell);
            pStatus(pdata);
            reply = input(strMenu,'s');
        case 's'
            fprintf(strWellStatus,countWell);
            pStatus(pdata);
            reply = input(strMenu,'s');
        case 'q'
            fprintf('PROCESS ABORTED!\n\n');
            return
        otherwise
            fprintf('Unrecognized input, please try again.\n');
            reply = input(strMenu,'s');
    end
    %%
    %
    if isempty(reply)
        reply = input('Do you want to move to the next well? (y/n)\n','s');
        if any(strcmpi(reply,{'y','yes'}))
            if size(pdata,1)<=2
                fprintf('Collect more perimeter points!\n\n');
            else
                pcell{countWell} = pdata;
                fprintf('Data stored for well %d!\n\n',countWell);
                countWell = countWell + 1;
                pdata = [];
            end
        else
            fprintf('Returning to main menu...\n\n');
        end
        reply = 's';
    end
    %%
    %
    if countWell >6
        break
    end
end
for i=1:numel(pcell)
    [xc,yc,r] = SCAN6config_estimateCircle(pcell{i});
    mmhandle.map6well(i).center = [xc,yc];
    mmhandle.map6well(i).radius = r;
end

function [] = pStatus(pdata)
fprintf('x\ty\n');
for i = 1:size(pdata,1)
    fprintf('%4.4f\t%4.4f\n',pdata(i,:));
end
fprintf(':)\n');
