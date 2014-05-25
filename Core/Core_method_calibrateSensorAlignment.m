%% Core_method_calibrateSensorAlignment
% # Ask user to focus on some cells or other objects of high contrast in
% the center of the field of view. A brightfield image is suggested.
% # Using a square in the center

function [mm] = Core_method_calibrateSensorAlignment(mm)
pixWidth = mm.core.getImageWidth;
pixHeight = mm.core.getImageHeight;
pixSize = mm.core.getPixelSizeUm;
mm.getXYZ;
fixed = mm.snapImage;
mm.setXYZ(mm.pos(1) + pixSize*round((pixWidth*.1)),'x');
mm.core.waitForDevice(mm.xyStageDevice);
moving_X1 = mm.snapImage;
mm.getXYZ;
    function [trnsltnStruct] = cc2translation(fix,mov)
        % uses the inner 10% of the image to find cross correlation and x/y
        % translation.
innerWidth = round(0.1*pixWidth);
innerHeight = round(0.1*pixHeight);
innerTop = round((pixHeight-innerHeight)/2);
innerBottom = round((pixHeight+innerHeight)/2)-1;
innerLeft = round((pixWidth-innerWidth)/2);
innerRight = round((pixWidth+innerWidth)/2)-1;
        IMinner10 = fix(innerTop:innerBottom,...
            innerLeft:innerRight);
        c = normxcorr2(IMinner10,mov);
[~, imax] = max(abs(c(:)));
[ypeak, xpeak] = ind2sub(size(c),imax(1));
corr_offset = [(xpeak-size(IMinner10,2))
               (ypeak-size(IMinner10,1))];
    end
end

