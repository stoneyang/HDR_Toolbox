function val = SNR(imgReference, imgDistorted)
%
%
%      val = SNR(imgReference, imgDistorted)
%
%
%       Input:
%           -imgReference: input reference image
%           -imgDistorted: input distoreted image
%
%       Output:
%           -val: classic SNR (signal-to-noise ratio) for images.
%           Higher values, in decibel (dB) means better quality.
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

if(CheckSameImage(imgReference, imgDistorted)==0)
    error('The two images are different they can not be used.');
end

imgR = RemoveSpecials(imgReference);
imgD = RemoveSpecials(imgDistorted);

imgN = imgD-imgR;

A_signal = mean(imgR(:).^2);
A_noise  = mean(imgN(:).^2);

ratio = A_signal/A_noise;

val = 10*log10(ratio);

end