function pyr = dwt2Decomposition(img, filterType)
%
%
%      pyr = dwt2Decomposition(img, mode)
%
%
%       Input:
%           -img: an image
%           -filterType: the type of filter to use in the DWT:
%            'db1' or 'haar', 'db2', ... ,'db10', ... , 'db45'
%           Please have a look to the MATLAB reference for dwt2.
%
%       Output:
%           -pyr: the DWT decomposition 
% 
%       This function decomposes an image using the DWT. Please have a look
%       to the reference of dwt2.
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

lmin = min([size(img,1),size(img,2)]);

pyr = [];

while(lmin>2)
    [img, cH, cV, cD] = dwt2(img, filterType);
    
    cur = struct('cA',[],'cH',cH,'cV',cV,'cD',cD);
    pyr = [pyr, cur];
    lmin = min([size(img,1),size(img,2)]);
end

n = length(pyr);

if(n>0)
    pyr(n).cA = img;
end

end