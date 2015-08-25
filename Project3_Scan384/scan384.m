%%
% find the upper left hand corner and add value here.
ULC = [0,0,0];
%%
% the spacing between wells is 4500um in both x and y
overlap = 4500;

grid = SuperMDA_grid_maker(mm,'overlap_units','um','overlap',overlap,...
    'upper_left_corner',ULC,'number_of_columns',24,'number_of_rows',16);
smdaTA.addPositionGrid(384,grid);


