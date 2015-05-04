function outputImg = hdr_condition(filename, outputHDR, outputGamma)
%
%
%      outputImg = hdr_condition(filename, outputHDR, outputGamma)
%
%
%       Input:
%           -filename:     filename of input image
%           -outputHDR:    filename of original hdr in tif format
%           -outputGamma:  filename of gamma-corrected image
%       Output:
%           -outputImg:    input HDR image
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
    disp('1) Load the image using hdrimread');
    img = hdrimread(filename);
    
    disp('2) Show the image in linear mode using imshow');
    h = figure(1);
    set(h,'Name','HDR visualization in Linear mode at F-stop 0');
    imwrite(GammaTMO(img, 1.0, 0, 1), outputHDR);
    
    disp('3) Show the image applying gamma');
    h = figure(2);
    set(h,'Name','HDR visualization with gamma correction, 2.2, at F-stop 0');
    imwrite(GammaTMO(img, 2.2, 0, 1), outputGamma);
    
    outputImg = img;
end