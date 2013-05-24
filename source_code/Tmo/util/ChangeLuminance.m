function imgOut = ChangeLuminance(img, Lold, Lnew)
%
%       imgOut = ChangeLuminance(img, Lold, Lnew)
%
%
%       Input:
%           -img: input image
%           -Lold: old luminance
%           -Lnew: new luminance
%
%       Output
%           -imgOut: output image with Lnew luminance
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

%Removing the old luminance
[r,c,col] = size(img);
imgOut = zeros(r,c,col);

for i=1:col
    imgOut(:,:,i) = (img(:,:,i).*Lnew)./Lold;
end

imgOut = RemoveSpecials(imgOut);

end