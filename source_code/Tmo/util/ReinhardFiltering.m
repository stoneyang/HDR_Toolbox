function L_adapt = ReinhardFiltering(L, pAlpha, pPhi)  
%
%
%      L_adapt = ReinhardFiltering(L, pAlpha, pPhi)  
%
%
%       Input:
%           -L: input grayscale image
%           -pAlpha: value of exposure of the image
%           -pPhi: a parameter which controls the sharpening
%
%       Output:
%           -L_adapt: filtered image
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

if(~exist('pAlpha'))
    pAlpha = ReinhardAlpha(L);
end

if(~exist('pPhi'))
    pPhi = 8;
end

%precomputation of 9 filtered images
sMax = 9; 
[r,c] = size(L);
Lfiltered = zeros(r,c,sMax); 
LC = zeros(r,c,sMax);

alpha1 = 1/(2*sqrt(2));
alpha2 = alpha1*1.6;
    
constant = (2^pPhi)*pAlpha;
sizeWindow = 1;

for i=1:sMax        
    s = round(sizeWindow);
    V1=ReinhardGaussianFilter(L,s,alpha1);    
    V2=ReinhardGaussianFilter(L,s,alpha2);       
     
    %normalized difference of Gaussian levels
    LC(:,:,i)=RemoveSpecials((V1-V2)./(constant/(s^2)+V1)); 
    Lfiltered(:,:,i)=V1;
    sizeWindow=sizeWindow*1.6;
end  
    
%threshold is a constant for solving the band-limited 
%local contrast LC at a given image location.
epsilon = 1e-4;
    
%adaptation image
L_adapt = L;
for i=sMax:-1:1
    ind = find(LC(:,:,i)<epsilon);
    if(~isempty(ind))
        L_adapt(ind) = Lfiltered(r*c*(i-1)+ind);
    end
end
    
end