function ret = write_pfm(img, filename, endian_mode)
%
%       ret = write_pfm(img, filename, endian_mode)
%
%
%        Input:
%           -img: the image to write on the hard disk
%           -filename: the name of the image to write
%           -endian_mode: sets the endian mode for writing float values:
%                         - 'l': little-endian (default)
%                         - 'b': big-endian
%
%        Output:
%           -ret: a boolean value, it is set to 1 if the write succeed, 0 otherwise
%
%     Copyright (C) 2011-2014  Francesco Banterle
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

if(~exist('endian_mode', 'var'))
    endian_mode = 'l';
end

%open the file
fid = fopen(filename,'w', endian_mode);

[n,m,c] = size(img);

switch endian_mode
    case 'l'
        fprintf(fid,'PF%c%d %d%c-1.000000%c', 10, m, n, 10, 10);

    case 'b'
        fprintf(fid,'PF%c%d %d%c1.000000%c', 10, m, n, 10, 10);
end

tot = n * m;
tot3 = tot * 3;
data = zeros(tot3, 1);

img = imrotate(img, -90, 'nearest');


for i=1:c
    indx = i:3:tot3;
    data(indx) = reshape(img(:,:,i), tot, 1);
end

for i=c:3
    indx = i:3:tot3;
    data(indx) = reshape(img(:,:,i), tot, 1);
end

fwrite(fid, data, 'float');

fclose(fid);

ret = 1;

end
