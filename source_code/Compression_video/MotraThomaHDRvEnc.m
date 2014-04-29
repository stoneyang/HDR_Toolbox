function MotraThomaHDRvEnc(hdrv, name, hdrv_profile, hdrv_quality)
%
%
%       MotraThomaHDRvEnc(hdrv, name, hdrv_profile, hdrv_quality)
%
%
%       Input:
%           -hdrv: a HDR video stream, use hdrvread for opening a stream
%           -name: this is the output name of the stream. For example,
%           'video_hdr.avi' or 'video_hdr.mp4'
%           -hdrv_profile: the compression profile (encoder) for compressing the stream.
%           Please have a look to the profile of VideoWriter from the MATLAB
%           help. Depending on the version of MATLAB some profiles may be not
%           be present.
%           -hdrv_quality: the output quality in [1,100]. 100 is the best quality
%           1 is the lowest quality.
%
%     Copyright (C) 2014  Francesco Banterle
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
%     "An Adaptive LogLuv Transform for High Dynamic Range Video Compression"
% 	  by Ajit Motra, Herbert Thoma
%     in Proceedings of 2010 IEEE 17th International Conference on Image Processing
%
%

if(~exist('hdrv_quality','var'))
    hdrv_quality = 95;
end

if(hdrv_quality<1)
    hdrv_quality = 95;
end

if(~exist('hdrv_profile','var'))
    hdrv_profile = 'Motion JPEG AVI';
end

if(strcmp(hdrv_profile,'MPEG-4')==0)
    disp('Note that the H.264 profile needs to be used for fair comparisons!');
end

nameOut = RemoveExt(name);
fileExt = fileExtension(name);
nameALogLUV = [nameOut,'_MT10_LUV.',fileExt];

%number of bits is fixed due to limitation of MATLAB
n_bits = 8;

disp('Note that 8-bit encoding is used, this method should be used with');
disp('14-bit encoding from the H.264 high profile, not available');
disp('in MATLAB at the moment.');

%Opening hdr stream
hdrv = hdrvopen(hdrv);

writerObj = VideoWriter(nameALogLUV, hdrv_profile);
writerObj.Quality = hdrv_quality;
open(writerObj);

a = zeros(hdrv.totalFrames,1);
b = zeros(hdrv.totalFrames,1);

for i=1:hdrv.totalFrames
    disp(['Processing frame ',num2str(i)]);
    
    %HDR frame
    [frame, hdrv] = hdrvGetFrame(hdrv, i);

    [imgALogLuv, param_a, param_b] = float2ALogLuv(frame, n_bits);
        
    a(i) = param_a;
    b(i) = param_b;
    
    %writing residuals
    writeVideo(writerObj, imgALogLuv/255.0);
end

close(writerObj);

save([nameOut,'_MT10_info.mat'], 'n_bits', 'a','b');

hdrvclose(hdrv);

end
