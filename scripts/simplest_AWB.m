function I_out = simplest_AWB(I_in, satLvl)
    I_in = double(I_in) / 255;
    
    q = [satLvl/2 1-satLvl/2];
    
    imgRGB_orig = cbreshape(I_in) * 255;
    imgRGB = zeros(size(imgRGB_orig));
    
    for ch = 1:3
        tiles = quantile(imgRGB_orig(ch, :), q);
        imgRGB(ch, :) = cbsaturate(imgRGB_orig(ch, :), tiles);
        bottom = min(imgRGB(ch, :));
        top = max(imgRGB(ch, :));
        imgRGB(ch, :) = (imgRGB(ch, :) - bottom) * 255 / (top - bottom);
    end
    I_out = cbunshape(imgRGB, size(I_in)) / 255;
end