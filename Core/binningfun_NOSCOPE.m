function [] = binningfun_NOSCOPE(mm,binNum)
    switch binNum
        case 1
            mm.core.setProperty(mm.CameraDevice,'Binning',1);
        case 2
            mm.core.setProperty(mm.CameraDevice,'Binning',2);
        case 4
            mm.core.setProperty(mm.CameraDevice,'Binning',4);
        otherwise
            mm.core.setProperty(mm.CameraDevice,'Binning',1);
    end
end