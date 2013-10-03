function img=hdrimread(filename)
%
%       img=hdrimread(filename)
%
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

extension=lower(fileExtension(filename));

if(strcmpi(extension,'pic')==1)
    extension='hdr';
end

img=[];
bLDR = 0;

switch extension
    
    %PIC-HDR format by Greg Ward
    case 'hdr'
        try
		 %Uncompressed RGBE Image
            img=read_rgbe(filename);  
        catch
            %RLE compressed image
            img=double(hdrread(filename));
        end
        
    %Portable float map
    case 'pfm'
        try
            img=read_pfm(filename);
        catch
            disp('This PFM file can not be read.');
        end
        
    case 'jp2'
        try
            img = HDRJPEG2000Dec(filename);
        catch
            disp('Tried to read it as HDRJPEG 2000.');
        end        
        
    case 'jpg'
        try
            img = JPEGHDRDec(filename);
        catch
            disp('Tried to read it as JPEG HDR.');
        end
       
    otherwise %try to open as LDR image
        try
            bLDR = 1;
            img=double(imread(filename))/255;
        catch
            disp('This format is not supported.');
        end
end

if(isempty(img)&&(bLDR==0))
	try
        image_info = imfinfo(filename);
        if(image_info.BitDepth==24)
        	img=double(imread(filename))/255;
        end
        
        if(bitDepth==48)
            img=double(imread(filename))/65535;
        end
    catch
        disp('This format is not supported.');
	end
end

%Remove specials
img = RemoveSpecials(img);
end