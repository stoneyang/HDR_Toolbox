function index = GalloReferenceImage(imageStack)
%
%
%        index = GalloReferenceImage(imageStack)
%
%
%        Input:
%           -imageStack: an exposure stack of LDR images with values in
%           [0,1].
%
%        Output:
%   `       -index: the index of the reference image in the stack.
% 
%     Copyright (C) 2015  Francesco Banterle
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
%     "Artifact-free High Dynamic Range Imaging"
% 	  by  O. Gallo, N. Gelfand, W. Chen, M. Tico, and K. Pulli. 
%     in IEEE International Conference on Computational Photography (ICCP)
%     2009
%

[r, c, ~, n] = size(imageStack);

toe = 248 / 255;
tue =   7 / 255;

index = -1;
value = r * c;

for i=1:n
    over_exp = max(imageStack(:,:,:,i), [], 3);
    under_exp = min(imageStack(:,:,:,i), [], 3);
    
    mask_oe = zeros(r, c);
    mask_oe(over_exp >= toe) = 1;

    mask_ue = zeros(r, c);
    mask_ue(under_exp <= tue) = 1;
    
    mask = mask_oe + mask_ue;
    mask(mask > 1) = 1;
    
    tmp_value = sum(mask(:));
    
    if(tmp_value < value) 
        index = i;
        value = tmp_value; 
    end    
end

end