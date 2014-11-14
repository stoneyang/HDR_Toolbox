function img = read_pfm(filename)
%
%
%       img = read_pfm(filename)
%
%        Input:
%           -filename: the name of the file to open
%
%        Output:
%           -img: the opened image
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

%by default PFM files are open in little-endian format
fid = fopen(filename, 'r', 'l');

%reading the header
fscanf(fid,'%c',3);
m = fscanf(fid,'%d',1);
fscanf(fid,'%c',1);
n = fscanf(fid,'%d',1);
fscanf(fid,'%c',1);
endian_selector = fscanf(fid,'%f',1);
fscanf(fid,'%c',1);

%we have a big-endian encoded file
if(endian_selector > 0.0)
    fclose(fid);
    
    %reopening the file in big-endian mode
    fid = fopen(filename, 'r', 'b');
    fscanf(fid,'%c',3);
    m = fscanf(fid,'%d',1);
    fscanf(fid,'%c',1);
    n = fscanf(fid,'%d',1);
    fscanf(fid,'%c',1);
    endian_selector = fscanf(fid,'%f',1);
    fscanf(fid,'%c',1);  
end

img = zeros([m, n, 3]);

total = n * m * 3;
tmpImg = fread(fid, total, 'float');

for i=1:3
    tmpC = i:3:total;
    img(:,:,i) = reshape(tmpImg(tmpC), m, n);    
end

img = imrotate(img,90,'nearest');

fclose(fid);

end