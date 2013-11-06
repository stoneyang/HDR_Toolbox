function hdrv = hdrvread(filename)
%
%        hdrv = hdrvread(filename)
%
%
%        Input:
%           -filename: the name or the folder path of the HDR video to open
%
%        Output:
%           -hdrv: a HDR video structure
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

hdrv = [];
if(isdir(filename))
    tmp_list = dir([filename,'/','*.hdr']);
    type = 'TYPE_HDR_RGBE';
    
    if(isempty(tmp_list))
        tmp_list = dir([filename,'/','*.pfm']);
        type = 'TYPE_HDR_PFM';
    end
    
    if(isempty(tmp_list))%assuming frames compressed with JPEG HDR
        tmp_list = dir([filename,'/','*.jpg']);
        type = 'TYPE_HDR_JPEG';
    end

    if(isempty(tmp_list))%assuming frames compressed with HDR JPEG 2000
        tmp_list = dir([filename,'/','*.jp2']);
        type = 'TYPE_HDR_JPEG_2000';
    end
    
    if(isempty(tmp_list))
        type = 'TYPE_HDR_FAIL';
    end
    
    hdrv = struct('type',type,'path',filename,'list',tmp_list,'totalFrames',length(tmp_list),'FrameRate',30,'frameCounter',1,'streamOpen',0);
else
    
end

end