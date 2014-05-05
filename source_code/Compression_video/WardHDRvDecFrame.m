function frameHDR = WardHDRvDecFrame(frameTMO, frameR, r_min, r_max, r_max_tmo)
%
%
%       frameHDR = WardHDRvDecFrame(frameTMO, frameR, r_min, r_max, r_max_tmo)
%
%
%       Input:
%           -frameTMO: a tone mapped frame from the video stream with values in [0,255] at 8-bit
%           -frameR: a residual frame from the residuals stream with values in [0,255] at 8-bit
%           -r_min: the minimum value of frameR
%           -r_max: the maximum value of frameR
%           -r_max_tmo: the maximum value of frameTMO
%
%       Output:
%           -frameHDR: the reconstructed HDR frame
%
%     Copyright (C) 2013-14  Francesco Banterle
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
%     This method is an extension of the Ward and Simmons JPEG-HDR method
%     applied to videos.
%
%

%decompression of the residuals frame
frameR = frameR(:,:,1);
frameR = double(frameR)/255.0;
frameR = frameR*(r_max-r_min) + r_min;
RI = 2.^(frameR * 32 - 16);
    
%decompression of the tone mapped frame
tmo_gamma = 2.2; 
frameTMO = (double(frameTMO)/255.0).^tmo_gamma;
frameTMO = frameTMO * r_max_tmo;

%adding colors
frameHDR = zeros(size(frameTMO));
for i=1:size(frameTMO, 3)
    frameHDR(:,:,i) = frameTMO(:,:,i) .* RI;
end

end

