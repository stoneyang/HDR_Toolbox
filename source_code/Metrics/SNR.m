function val = SNR(imgReference, imgDistorted)
%
%
%      val = SNR(img1, img2)
%
%
%       Input:
%           -imgReference: reference image
%           -imgDistorted: distoreted image
%
%       Output:
%           -val: classic SNR for images in dB. Higher values means better quality.
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

disp('PSNR is not very meaningful for HDR images/videos, please consider mPSNR instead!');

imgNoise = imgDistorted-imgReference;

tmp = (imgReference.^2);
A_signal = mean(tmp(:));

tmp = (imgNoise.^2);
A_noise  = mean(tmp(:));

if(A_noise>0)
    SNR = A_signal/A_noise;
    SNR = 10.0*log10(SNR);
else
    disp('The two images are the same');
    val = -1;
end

end