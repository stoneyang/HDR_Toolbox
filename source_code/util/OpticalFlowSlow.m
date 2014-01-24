function offsetMap = OpticalFlowSlow(img1, img2, patchSize, maxIterations)
%
%       offsetMap = OpticalFlowSlow(img1, img2, patchSize, maxIterations)
%
%
%       input:
%         - img1: source
%         - img2: target
%         - patchSize: size of the patch
%
%       output:
%         - offsetMap: shift vectors from img1 to img2
%
%     Copyright (C) 2013-14  Francesco Banterle
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

if(~exist('patchSize','var'))
    patchSize = 7;
end

if(~exist('maxIterations','var'))
    maxIterations = 0;
end

[r,c,~] = size(img1);

halfPatchSize = ceil(patchSize/2);

offsetMap = zeros(r,c,3);

for i=(patchSize+1):(r-patchSize-1)
    
    for j=(patchSize+1):(c-patchSize-1)
        
        err = 1e30;
        patch1 = img1((i-halfPatchSize):(i+halfPatchSize), (j-halfPatchSize):(j+halfPatchSize), :);
        
        for k=(-halfPatchSize+1):halfPatchSize
            tmp_i = i+k;
            
            for l=(-halfPatchSize+1):halfPatchSize
                tmp_j = j+l;

                patch2 = img2((tmp_i-halfPatchSize):(tmp_i+halfPatchSize), (tmp_j-halfPatchSize):(tmp_j+halfPatchSize), :);
                
                tmp_err = (patch1-patch2).^2;
                tmp_err = sum(tmp_err(:));
                
                if(tmp_err<err)
                    err = tmp_err;
                    u = k;
                    v = l;
                end
            end            
        end
        
        offsetMap(i,j,1) =  v;
        offsetMap(i,j,2) =  u;
        offsetMap(i,j,3) =  err;
    end
end

end