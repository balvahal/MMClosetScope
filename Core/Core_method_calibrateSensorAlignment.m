%% Core_method_calibrateSensorAlignment
% # Ask user to focus on some cells or other objects of high contrast in
% the center of the field of view. A brightfield image is suggested.
% # Using a square in the center

function [mm] = Core_method_calibrateSensorAlignment(mm)
pixWidth = mm.core.getImageWidth;
pixHeight = mm.core.getImageHeight;
pixSize = mm.core.getPixelSizeUm;
mm.getXYZ;
oldPos = mm.pos;

mm.setXYZ(mm.pos(1) + pixSize*round((pixWidth*.4)),'x');
mm.core.waitForDevice(mm.xyStageDevice);
mm.getXYZ;

fixed = mm.snapImage;
innerWidth = round(0.1*pixWidth);
innerHeight = round(0.1*pixHeight);
innerTop = round((pixHeight*.5-innerHeight/2));
innerBottom = round((pixHeight*.5+innerHeight/2))-1;
innerLeft = round((pixWidth*.1-innerWidth/2));
innerRight = round((pixWidth*.1+innerWidth/2))-1;
pattern = fixed(innerTop:innerBottom,...
    innerLeft:innerRight);


mm.setXYZ(mm.pos(1) - pixSize*round((pixWidth*.7)),'x');
mm.core.waitForDevice(mm.xyStageDevice);
moving = mm.snapImage;
mm.getXYZ;
myOffset = cc2translation(fixed,moving,pattern);

mm.setXYZ(mm.pos(1) - pixSize*round((pixWidth*.03)),'x');
mm.core.waitForDevice(mm.xyStageDevice);
moving = mm.snapImage;
mm.getXYZ;
myOffset(end+1,:) = cc2translation(fixed,moving,pattern);

mm.setXYZ(mm.pos(1) - pixSize*round((pixWidth*.035)),'x');
mm.core.waitForDevice(mm.xyStageDevice);
moving = mm.snapImage;
mm.getXYZ;
myOffset(end+1,:) = cc2translation(fixed,moving,pattern);

mm.setXYZ(mm.pos(1) - pixSize*round((pixWidth*.04)),'x');
mm.core.waitForDevice(mm.xyStageDevice);
moving = mm.snapImage;
mm.getXYZ;
myOffset(end+1,:) = cc2translation(fixed,moving,pattern);

mm.setXYZ(mm.pos(1) - pixSize*round((pixWidth*.045)),'x');
mm.core.waitForDevice(mm.xyStageDevice);
moving = mm.snapImage;
mm.getXYZ;
myOffset(end+1,:) = cc2translation(fixed,moving,pattern);

mm.setXYZ(oldPos(1),'x');
mm.core.waitForDevice(mm.xyStageDevice);
mm.getXYZ;

mm.setXYZ(mm.pos(2) + pixSize*round((pixHeight*.4)),'y');
mm.core.waitForDevice(mm.xyStageDevice);
mm.getXYZ;

fixed = mm.snapImage;
innerWidth = round(0.1*pixWidth);
innerHeight = round(0.1*pixHeight);
innerTop = round((pixHeight*.1-innerHeight/2));
innerBottom = round((pixHeight*.1+innerHeight/2))-1;
innerLeft = round((pixWidth*.5-innerWidth/2));
innerRight = round((pixWidth*.5+innerWidth/2))-1;
pattern = fixed(innerTop:innerBottom,...
    innerLeft:innerRight);


mm.setXYZ(mm.pos(2) - pixSize*round((pixHeight*.7)),'y');
mm.core.waitForDevice(mm.xyStageDevice);
moving = mm.snapImage;
mm.getXYZ;
myOffset(end+1,:) = fliplr(cc2translation(fixed,moving,pattern));

mm.setXYZ(mm.pos(2) - pixSize*round((pixHeight*.03)),'y');
mm.core.waitForDevice(mm.xyStageDevice);
moving = mm.snapImage;
mm.getXYZ;
myOffset(end+1,:) = fliplr(cc2translation(fixed,moving,pattern));

mm.setXYZ(mm.pos(2) - pixSize*round((pixHeight*.035)),'y');
mm.core.waitForDevice(mm.xyStageDevice);
moving = mm.snapImage;
mm.getXYZ;
myOffset(end+1,:) = fliplr(cc2translation(fixed,moving,pattern));

mm.setXYZ(mm.pos(2) - pixSize*round((pixHeight*.04)),'y');
mm.core.waitForDevice(mm.xyStageDevice);
moving = mm.snapImage;
mm.getXYZ;
myOffset(end+1,:) = fliplr(cc2translation(fixed,moving,pattern));

mm.setXYZ(mm.pos(2) - pixSize*round((pixHeight*.045)),'y');
mm.core.waitForDevice(mm.xyStageDevice);
moving = mm.snapImage;
mm.getXYZ;
myOffset(end+1,:) = fliplr(cc2translation(fixed,moving,pattern));

mm.setXYZ(oldPos(2),'y');
mm.core.waitForDevice(mm.xyStageDevice);
mm.getXYZ;

disp('hello');
    function [corr_offset] = cc2translation(fix,mov,pattern)
        % uses the inner 10% of the image to find cross correlation and x/y
        % translation.
%         innerWidth = round(0.1*pixWidth);
%         innerHeight = round(0.1*pixHeight);
%         innerTop = round((pixHeight-innerHeight)/2);
%         innerBottom = round((pixHeight+innerHeight)/2)-1;
%         innerLeft = round((pixWidth-innerWidth)/2);
%         innerRight = round((pixWidth+innerWidth)/2)-1;
%         IMinner10 = fix(innerTop:innerBottom,...
%             innerLeft:innerRight);
        c = normxcorr2(pattern,mov);
        [~, imax] = max(abs(c(:)));
        [ypeak, xpeak] = ind2sub(size(c),imax);
        corr_offset = abs([(xpeak-size(pattern,2)+1-innerLeft),...
            (ypeak-size(pattern,1)+1-innerTop)]);
    end
end

