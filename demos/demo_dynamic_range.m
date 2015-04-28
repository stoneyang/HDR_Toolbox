function [dynRg, dynRgLog, img, L] = demo_dynamic_range(filename)
%
%       HDR Toolbox demo compute dynamic range of input image:
%	   1) Load HDR image using hdrimread
%	   2) Show the image in linear mode using imshow
%	   3) 
%	   4) 
%	   5) 
%	   6) 
%       Author: Francesco Banterle, Fan Yang
%       Copyright 2013-15 (c)
%
%
    disp('1) Load HDR image using hdrimread');
    img = hdrimread(filename);

    disp('2) Show the image in linear mode using imshow');
    h = figure(1);
    set(h,'Name','HDR visualization in Linear mode at F-stop 0');
    GammaTMO(img, 1.0, 0, 1);
    
    disp('3) Calculate the dynamic range of HDR image');
    h = figure(2);
    set(h,'Name','Luminance visualization in Linear mode at F-stop 0');
    L = lum(img);
    imshow(L);
    
    %nanRows = any(isnan(L), 2);
    %zeroRows = any(L == 0, 2);
    %badRows = nanRows | zeroRows;
    %L(badRows, :) = [];
    
    epsilon = 0.00001;
    Lmax = double(max(L(:)));
    Lmin = double(min(L(:))) + epsilon; % to make sure the mininum not be null
    
    dynRg = Lmax / Lmin;
    dynRgLog = 20 * log10(dynRg);
end