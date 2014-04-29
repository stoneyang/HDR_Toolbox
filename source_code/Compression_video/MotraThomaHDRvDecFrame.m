function frameHDR = MotraThomaHDRvDecFrame(frameLUV, a, b)
%
%
%       frameHDR = MotraThomaHDRvDecFrame(frameLUV, a, b)
%
%
%       Input:
%           -frameLUV: logLUV representation at 8-bit
%           -a: a's adapative logLUV parameter
%           -b: b's adapative logLUV parameter
%
%       Output:
%           -frameHDR: the reconstructed HDR frame
%
%     Copyright (C) 2014  Francesco Banterle
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
%     The paper describing this technique is:
%     "Backward Compatible High Dynamic Range MPEG Video Compression"
%           by Rafal Mantiuk, Alexander Efremov, Karol Myszkowski, and Hans-Peter Seidel 
%     in ACM SIGGRAPH 2006
%
%


%Reconstruction of HDR luminance
frameLUV = double(frameLUV);

imgRGB = ALogLuv2float(frameLUV, a, b);

frameHDR = RemoveSpecials(imgRGB);

end
