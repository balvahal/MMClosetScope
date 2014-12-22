function [] = binningfun_HAMAMATSU(mm,binNum)
    switch binNum
        case 1
            mm.core.setProperty(mm.CameraDevice,'Binning','1x1');
        case 2
            mm.core.setProperty(mm.CameraDevice,'Binning','2x2');
        case 4
            mm.core.setProperty(mm.CameraDevice,'Binning','4x4');
        otherwise
            mm.core.setProperty(mm.CameraDevice,'Binning','1x1');
    end
end