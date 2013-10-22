function imgR = MantiukResidualImage(Ld, Lw)
%
%
%       imgR = MantiukResidualImage(Ld, Lw)
%
%
%       Input:
%           -Lw: input HDR luminance
%           -Ld: Lw tone mapped luminance 8-bit in [0,255]
%
%       Output:
%           -imgR: residual image between reconstructed Lw from Ld and Lw,
%           at 8-bit in the range [-127,127]
%
%     Copyright (C) 2013  Francesco Banterle
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

if(~exist('Mantiuk_RF'))
    Mantiuk_RF = MantiukReconstructionFunction(Ld, Lw);
end

Lw_rec = zeros(size(Lw));
for i=1:256
    Lw_rec(Ld==(i-1)) = Mantiuk_RF(i);
end

rl = Lw - Lw_rec; %residuals

%quantization
Qmin = 1; %as suggested in the original paper
imgR = zeros(size(rl));
for i=1:256
    rl_bin_i = abs(rl(Ld==(i-1)));
    Qtmp = max(rl_bin_i(:))/127;
    Q = max(Qmin,Qtmp);
    
    imgR(Ld==(i-1)) = round(rl(Ld==(i-1))/Q);
end

imgR = ClampImg(imgR,-127,127);

end