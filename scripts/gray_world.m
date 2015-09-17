function I_out = gray_world(I_in, catType, maxIter)
    I_in = double(I_in) / 255;

    xyz_D65 = [95.04; 100; 108.88]; %http://en.wikipedia.org/wiki/D65, normalized Y = 100
    sRGBtoXYZ = [0.4124564  0.3575761  0.1804375; ...
                 0.2126729  0.7151522  0.0721750; ...
                 0.0193339  0.1191920  0.9503041];
             
    b = 0.001;
    
    imRGB_orig = cbreshape(I_in) * 255;
    
    grayDiff = [];
    for iter = 1:maxIter
        rgbEst = mean(imRGB_orig, 2);
        grayDiff = [grayDiff norm([rgbEst(1)-rgbEst(2), rgbEst(1)-rgbEst(3), rgbEst(2)-rgbEst(3)])];
        
        if grayDiff(end) < b
            disp(['Converged. RGB difference vector < ' num2str(b) ' in magnitude.']);
            break
        elseif iter >= 2 && abs(grayDiff(end-1) - grayDiff(end)) < 10^-6
            disp(['RGB difference vector no longer improving.']);
            break
        end
        
        xyEst = XYZ2xy(sRGBtoXYZ * rgbEst); %calculate xy chromaticity
        xyzEst = xy2XYZ(xyEst, 100); % normalize Y to 100 so D65 luminance comparable
        imRGB = cbCAT(xyzEst, xyz_D65, catType) * imRGB_orig;                
    end
    
    I_out = cbunshape(imRGB, size(I_in)) / 255;
end