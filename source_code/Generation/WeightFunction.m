function weight = WeightFunction(img, weight_type, bMeanWeight)
%
%       weight = WeightFunction(img, weight_type)
%
%
%        Input:
%           -img: input LDR image in [0,1]
%           -weight_type:
%               - 'all': weight is set to 1
%               - 'hat': hat function 1-(2x-1)^12
%               - 'Deb97': Debevec and Malik 97 weight function
%               - 'Gauss': Gaussian (mu = 0.5, sigma=0.15) 
%           -bMeanWeight:
%
%        Output:
%           -weight: the output weight function for a given LDR image
%
%     Copyright (C) 2011-15  Francesco Banterle
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

if(~exist('bMeanWeight', 'var'))
    bMeanWeight = 0;
end

col = size(img, 3);
if((size(img, 3) > 1) && bMeanWeight)
    L = mean(img, 3);
    
    for i=1:col
        img(:,:,i) = L;
    end
end

switch weight_type
    case 'all'
        weight = ones(size(img));
        
    case 'Gauss'
        mu = 0.5;
        sigma = 0.5;
        sigma2 = sigma * sigma * 2;
        weight = exp(-4 * (img - mu).^2 / sigma2);
        
    case 'hat'
        weight = 1 - (2 * img - 1).^12;
        
    case 'Deb97'
        Zmin = 0.01;
        Zmax = 0.99;
        tr = (Zmin + Zmax) / 2;
        indx1 = find (img <= tr);
        indx2 = find (img > tr);
        weight = zeros(size(img));
        weight(indx1) = img(indx1) - Zmin;
        weight(indx2) = Zmax - img(indx2);
        weight(weight < 0) = 0;
        weight = weight / max(weight(:));
        
    otherwise 
        weight = -1;
end

end