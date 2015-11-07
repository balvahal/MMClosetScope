%%
% find the upper left hand corner and add value here.
ULC = [-11767.1001753435,6799.40010131896,4714.35007024929];
LRC = [1708.90002546459,-2141.20003190637,4732.37507051788];
%%
% the spacing between wells is 4500um in both x and y
pixWidth = mm.core.getImageWidth*mm.core.getPixelSizeUm;
pixHeight = mm.core.getImageHeight*mm.core.getPixelSizeUm;
overlap_x = 4480-pixWidth;
overlap_y = 5080-pixHeight;

grid = SuperMDA_grid_maker(mm,'overlap_units','um','overlap_x',overlap_x,'overlap_y',overlap_y,...
    'upper_left_corner',ULC,'number_of_columns',4,'number_of_rows',1);
smdaTA.addPositionGrid(1,grid);


