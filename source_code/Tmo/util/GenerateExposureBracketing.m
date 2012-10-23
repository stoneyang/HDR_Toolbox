function [stack, stack_exposure] = GenerateExposureBracketing( img, fstopDistance, geb_gamma )
%
%
%       stack = GenerateExposureBracketing( img )
%       
%
%        Input:
%           -img: input HDR image
%           -fstopDistance: delta f-stop for generating exposures
%           -geb_gamma: the gamma for encoding the images
%
%        Output:
%           -stack: a stack of LDR images
%           -stack_exposure: exposure values of the stack (stored as time
%           in seconds)
% 
%     Copyright (C) 2010 Francesco Banterle
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

[r,c,col]=size(img);

if(~exist('fstopDistance'))
    fstopDistance=2;
end

%inverse gamma
if(~exist('geb_gamma'))
    inv_gamma = 1.0/2.2;
else
    inv_gamma = 1.0/geb_gamma;
end

%luminance channel
L = lum(img);

MinL = MaxQuart(L(L>0.0),0.01);
MaxL = MaxQuart(L(L>0.0),0.9999);

minExposure = floor(log2(MaxL));
maxExposure = ceil(log2(MinL));

tMax = -(maxExposure-1);
tMin = -(minExposure+1);

%allocate memory for the stack
n = length(tMin:fstopDistance:tMax);
stack = zeros(r,c,col,n);

c = 1;
%calculate exposures
for i=tMin:fstopDistance:tMax
    expo = ClampImg((2^i*img).^inv_gamma,0,1);
    stack(:,:,:,c) = expo;
    c=c+1;
end

stack_exposure = 2.^(tMin:fstopDistance:tMax);

end

