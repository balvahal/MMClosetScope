%%
%
function [smdaI] = SuperMDA_function_postprocessing(smdaI)
imageDim = []; %[height width]
for i= 1:100
    binning = 1;
fid = fopen(fullfile(),'r');
I = fread(fid,imageDim/mybinning,'uint16');
end
