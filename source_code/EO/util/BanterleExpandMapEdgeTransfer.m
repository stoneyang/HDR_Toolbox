function expand_map = BanterleExpandMapEdgeTransfer(expand_map_de, img, BEM_bColorRec, BEM_bHighQuality)
%
%		 expand_map = BanterleExpandMapEdgeTransfer(expand_map_de, img, BEM_bColorRec, BEM_bHighQuality)
%
%
%		 Input:
%           -expand_map_de: expand map after density estimation; i.e.
%           without strong edges
%			-img: an input image LDR image in the linear domain
%           -BEM_bColorRec: a boolean value. If it is set 1 the expand
%           map will be calculated for each color channel
%           -BEM_bHighQuality: a boolean value. If it is set to 1,
%           LischinskiMinimization will be used for better quality. This
%           takes more than using the bilateral filter. You may need MATLAB
%           at 64-bit for running high quality edge transer at HD
%           resolution (1920x1080).
%
%		 Output:
%			-expand_map: the final expand map
%
%     Copyright (C) 2011-13  Francesco Banterle
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

L = lum(img);

%Edge transfer
[r,c,col] = size(img);

expand_map = zeros(r,c,col);

if(BEM_bColorRec)
    for i=1:col
        if(BEM_bHighQuality)
            expand_map(:,:,i) = LischinskiMinimization(img(:,:,i),expand_map_de(:,:,i),base);
        else
            expand_map(:,:,i) = bilateralFilter(expand_map_de(:,:,i),img(:,:,i));
        end
    end
else    
    if(BEM_bHighQuality)
        tmp_expand_map = LischinskiMinimization(L,expand_map_de,0.07*ones(r,c));
    else
        tmp_expand_map = bilateralfilter(expand_map_de, L);
    end
    
    for i=1:col
        expand_map(:,:,i) = tmp_expand_map;
    end      
end

end