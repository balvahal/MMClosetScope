%%
%
function [smdaITF] = SuperMDAItineraryTimeFixed_method_export(smdaITF)
%%
%
fid = fopen(fullfile(smdaITF.output_directory,'smdaITF.txt'),'w');
if fid == -1
    error('smdaITF:badfile','Cannot open the file, preventing the export of the smdaITF.');
end
%%
%
myjson = micrographIOT_array2json('orderVector',smdaITF.orderVector);
fprintf(fid,myjson);
%%
%
fclose(fid);
end