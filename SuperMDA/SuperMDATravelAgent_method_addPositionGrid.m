function smdaTA = SuperMDATravelAgent_method_addPositionGrid(smdaTA,gInd,grid)
%%
%
p = inputParser;
addRequired(p, 'smdaTA', @(x) isa(x,'SuperMDATravelAgent_object'));
addRequired(p, 'gInd', @(x) ismember(x,smdaTA.itinerary.indOfPosition(gInd)));
addRequired(p, 'grid', @(x) isstruct(x));
parse(p,smdaTA,gInd,grid);

if  smdaTA.itinerary.numberOfPosition(gInd) == 1
    %replace the first position when assigning grid numbers if only 1
    %position exists. It is assumed this was the default/place-holder
    %position.
    smdaTA.itinerary.newPosition(gInd,size(grid.positions,1)-1);
    myPInds = smdaTA.itinerary.orderOfPosition(gInd);
    n=0;
    myposition_labels = grid.position_labels; %when cells are embedded into structs MATLAB grinds to a halt
    for i = myPInds
        n = n+1;
        smdaTA.itinerary.position_xyz(i,:) = grid.positions(n,:);
        smdaTA.itinerary.position_label{i} = myposition_labels{n};
    end
else
        %else, append grid to exisiting positions
    myOldPInds = smdaTA.itinerary.indOfPosition(gInd);
    smdaTA.itinerary.newPosition(gInd,size(grid.positions,1));
    myNewPInds = smdaTA.itinerary.indOfPosition(gInd);
    myNewPInds = myNewPInds(~ismember(myNewPInds,myOldPInds));
    n=0;
    myposition_labels = grid.position_labels; %when cells are embedded into structs MATLAB grinds to a halt
    for i = transpose(myNewPInds)
        n = n+1;
        smdaTA.itinerary.position_xyz(i,:) = grid.positions(n,:);
        smdaTA.itinerary.position_label{i} = myposition_labels{n};
    end
end
