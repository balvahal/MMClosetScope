function obj = SuperMDATravelAgent_method_addPositionGrid(obj,gInd,grid)
%% fake data
% Scenario 1. There is only a single branch of the group struct
obj.itinerary.group.position.xyz = [];
obj.itinerary.group.position.label = [];
obj.itinerary.group.position(1000).xyz = [];
gInd = 1;
%%
% Scenario 2. There is multiple group branches
obj.itinerary.group(2) = obj.itinerary.group;
%%
%
p = inputParser;
addRequired(p, 'obj', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'gInd', @(x) (numel(x) == 1) && all(ismember(x,1:length(obj.itinerary.group))));
addRequired(p, 'grid', @(x) isstruct(x));
parse(p,obj,gInd,grid);

if length(obj.itinerary.group(gInd).position) == 1
    %replace the first position when assigning grid numbers if only 1
    %position exists. It is assumed this was the default/place-holder
    %position.
    obj.addPosition(gInd,size(grid.positions,1)-1);
    myIndex = 1:length(obj.itinerary.group(gInd).position);
else
    %else, append grid to exisiting positions
    myInd1 = length(obj.itinerary.group(gInd).position)+1;
    myInd2 = myInd1 + size(grid.positions,1)-1;
    %obj.itinerary.group(gInd).position(myInd1:myInd2) = repmat(obj.itinerary.group(1).position(1),size(grid.positions,1),1);
    obj.addPosition(gInd,size(grid.positions,1));
    myIndex = myInd1:myInd2;
end

n=0;
    %myPositions = grid.positions;
    myPositions = rand(1000,3);
    tempStruct = obj.itinerary.group(gInd);
for i = myIndex
    n=n+1;
     tempStruct.position(i).xyz = myPositions(n,:);
%     
%      obj.itinerary.group(gInd).position(i).xyz(:,1) = grid.positions(n,1);
%      obj.itinerary.group(gInd).position(i).xyz(:,2) = grid.positions(n,2);
%      obj.itinerary.group(gInd).position(i).xyz(:,3) = grid.positions(n,3);
%      obj.itinerary.group(gInd).position(i).label = grid.position_labels{n};
end
obj.itinerary.group(gInd) = tempStruct;
fprintf('Finish!\n')