function imgOut = ConvertXYZtoLMS(img, inverse)
%
%       imgOut = ConvertXYZtoLMS(img, inverse)
%
%
%        Input:
%           -img: image to convert from XYZ to LMS or from LMS to XYZ.
%           -inverse: takes as values 0 or 1. If it is set to 0 the
%                     transformation from XYZ to LMS is applied, otherwise
%                     the transformation from LMS to XYZ.
%
%        Output:
%           -imgOut: converted image in XYZ or IPT.
%
%     Copyright (C) 2011  Francesco Banterle
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

%XYZ to LMS matrix conversion
mtxXYZ2LMS = [  0.8951,  0.2664, -0.1614;...
               -0.7502,  1.7135,  0.0367;...
                0.0389, -0.0685,  1.0296];

if(inverse==0)
    imgOut = ConvertLinearSpace(img, mtxXYZ2LMS);
else

if(inverse==1)
    imgOut = ConvertLinearSpace(img, inv(mtxXYZ2LMS));
end
            
end