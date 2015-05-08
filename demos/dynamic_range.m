function [Lmax, Lmin, dynRg, dynRgLog] = dynamic_range(img, saveLuminanceFile, saveMap)
%
%      [Lmax, Lmin, dynRg, dynRgLog] = dynamic_range(img, saveLuminanceFile, saveMap)
%
%
%       Input:
%           -img:               input image
%           -saveLuminanceFile: tone mapping method
%           -saveMap:           filename of original hdr in tif format
%       Output:
%           -Lmax:              maximum luminance of the input
%           -Lmin:              minimum luminance of the input
%           -dynRg:             dynamic range of input HDR
%           -dynRgLog:          log dynamic range of input HDR
% 
%     Copyright (C) 2015  Fan Yang
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%     disp(strcat({'Start calculating dynamic range of '}, filename, {' ...'}));
%     disp('1) Load HDR image using hdrimread');
%     img = hdrimread(filename);

    disp('Show the image in linear mode using imshow');
    h = figure(1);
    set(h,'Name','HDR visualization in Linear mode at F-stop 0');
    GammaTMO(img, 1.0, 0, 1);
    
    disp('Calculate the dynamic range of HDR image');
    h = figure(2);
    set(h,'Name','Luminance visualization in Linear mode at F-stop 0');
    L = lum(img);
    imshow(L);
    imwrite(L, saveLuminanceFile);
    
    epsilon = 0.0000000000001;
    Lmax = double(max(L(:)));
    Lmin = double(min(L(:))) + epsilon; % to make sure the mininum not be null
    disp(strcat({'Maximum luminance (cd/m^2): '}, num2str(Lmax)));
    disp(strcat({'Minimum luminance (cd/m^2): '}, num2str(Lmin)));
        
    dynRg = Lmax / Lmin;
    dynRgLog = 20 * log10(dynRg);
    disp(strcat({'Dynamic Range:'}, num2str(dynRg)));
    disp(strcat({'Dynamic Range in dB: '}, num2str(dynRgLog)));
    
    disp('Show the color temperature in logarithmic unit');
    h = figure(3);
    set(h,'Name','Color temperature in logarithmic unit (10-based)');
    map = FalseColor(img);
    imwrite(map, saveMap);
%     map = imagesc(L);
%     colorbar;
%     saveas(map, saveMap);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% TODO: export the color temperature map with the same size of the precedent figures
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end