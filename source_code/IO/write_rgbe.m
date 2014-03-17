function ret = write_rgbe(img, filename, bRLE)
%
%       ret = write_rgbe(img, filename, bRLE)
%
%
%        Input:
%           -img: the image to write on the hard disk
%           -filename: the name of the image to write
%           -bRLE: run length encoding compression flag
%
%        Output:
%           -ret: a boolean value, it is set to 1 if the write succeed, 0 otherwise
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

if(~exist('bRLE','var'))
    bRLE = 1;
end

ret = 0;

fid = fopen(filename,'w');
[n,m,c] = size(img);

fprintf(fid,'#?RADIANCE\n');
fprintf(fid,'FORMAT=32-bit_rle_rgbe\n');
fprintf(fid,'EXPOSURE= 1.0000000000000\n\n');
fprintf(fid,'-Y %d +X %d\n',n,m);

%convert from float to RGBE
RGBEbuffer = uint8(float2RGBE(img));

if((n<8) || (n>32767)) %RLE encoding is not allowed in these cases
    bRLE = 0;
end

%MIN_RLE_RUN = 4;

if(bRLE)   
    error('RLE has not be implemented yet');
%     TODO
%     for k=1:n
%         block = [2,2,bitshift(m,-8),bitand(m,255)];
%         fwrite(fid, block,'uint8');
% 
%         for j=1:4
%             data = reshape(RGBEbuffer(k,:,j),m,1);
%             cur = 1;        
%             while(cur<=m) 
% 
%             end   
%         end
%     end
else    
    %reshape of data
    data = zeros(n*m*4,1);
    for i=1:4
        C = i:4:(m*n*4);
        data(C) = reshape(RGBEbuffer(:,:,i)',m*n,1);
    end    
    fwrite(fid, data, 'uint8');
end

fclose(fid);

ret = 1;

end