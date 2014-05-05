function WardHDRvEnc(hdrv, name, hdrv_profile, hdrv_quality, hdrv_residual_scaling)
%
%
%       WardHDRvEnc(hdrv, name, hdrv_profile, hdrv_quality, hdrv_residual_scaling)
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
%           -hdrv_residual_scaling: a value in (0,1] for scaling the
%           residual stream and increasing compression.
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
%     This method is an extension of the Ward and Simmons JPEG-HDR method
%     applied to videos.
%
%

if(~exist('hdrv_quality','var'))
    hdrv_quality = 95;
end

if(hdrv_quality<1)
    hdrv_quality = 95;
end

if(~exist('hdrv_residual_scaling','var'))
    hdrv_residual_scaling = 0.75;
end

hdrv_residual_scaling = ClampImg(hdrv_residual_scaling, 0.01, 1.0);

if(~exist('hdrv_profile','var'))
    hdrv_profile = 'Motion JPEG AVI';
end

if(strcmp(hdrv_profile,'MPEG-4')==0)
    disp('Note that the H.264 profile needs to be used for fair comparisons!');
end

nameOut = RemoveExt(name);
fileExt = fileExtension(name);
nameTMO = [nameOut,'_WS05_tmo_tmp.',fileExt];
nameResiduals = [nameOut,'_WS05_residuals.',fileExt];

%Opening hdr stream
hdrv = hdrvopen(hdrv);

%KiserTMO
tmo_gamma = 2.2;    %as in the original paper
KiserTMOv(hdrv, nameTMO,  0.98, 0, tmo_gamma, hdrv_quality, hdrv_profile);

%video Residuals pass
readerObj = VideoReader(nameTMO);

writerObj_residuals = VideoWriter(nameResiduals, hdrv_profile);
writerObj_residuals.Quality = hdrv_quality;
open(writerObj_residuals);

r_min = zeros(1,hdrv.totalFrames);
r_max = zeros(1,hdrv.totalFrames);

for i=1:hdrv.totalFrames
    disp(['Processing frame ',num2str(i)]);
    
    %HDR frame
    [frame, hdrv] = hdrvGetFrame(hdrv, i);
    
    %Tone mapped frame
    frameTMO = double(read(readerObj, i))/255;
    frameTMO = GammaTMO(frameTMO,1.0/tmo_gamma,0.0,0);
 
    %Residuals
    RI = lum(frame)./lum(frameTMO);        
    RIenc = log2(RI + 2^-16);
    RIenc = (ClampImg(RIenc,-16,16)+16)/32;    
    
    maxRIenc = max(RIenc(:));
    minRIenc = min(RIenc(:));
    RIenc = (RIenc-minRIenc)/(maxRIenc-minRIenc);    
    
    r_min(i) = minRIenc;
    r_max(i) = maxRIenc;    
           
    RIenc = imresize(RIenc, hdrv_residual_scaling, 'bilinear');
    
    %writing residuals
    writeVideo(writerObj_residuals, RIenc);
end

close(writerObj_residuals);

%tone mapping final pass
readerObj_residuals = VideoReader(nameResiduals);

nameTMO = [nameOut,'_WS05_tmo.',fileExt];
writerObj_tmo = VideoWriter(nameTMO, hdrv_profile);
writerObj_tmo.Quality = hdrv_quality;
open(writerObj_tmo);

r_maxTMO = zeros(1,hdrv.totalFrames);

for i=1:hdrv.totalFrames
    disp(['Processing frame ',num2str(i)]);
    
    %HDR frame
    [frame, hdrv] = hdrvGetFrame(hdrv, i);
    [r,c,col] = size(frame);
    
    %Tone mapped frame
    RIenc = double(read(readerObj_residuals, i))/255;
    RIenc = RIenc(:,:,1);
    RIenc = RIenc * (r_max(i) - r_min(i)) + r_min(i);
    RI = 2.^(RIenc * 32 - 16);

    if(hdrv_residual_scaling < 1.0)
        RI = imresize(RI, [r,c], 'bilinear');
    end
    
    %Tone mapped image
    frameTMO = zeros(size(frame));
    for j=1:col
        frameTMO(:,:,j) = frame(:,:,j) ./ RI;
    end
    frameTMO = RemoveSpecials(frameTMO);
           
    r_maxTMO(i) = MaxQuart(frameTMO,0.999);
    frameTMO = ClampImg(frameTMO/r_maxTMO(i),0,1);    
    
    %writing residuals
    writeVideo(writerObj_tmo, frameTMO.^(1.0/tmo_gamma));
end
close(writerObj_tmo);

save([nameOut,'_WS05_info.mat'], 'r_min','r_max','r_maxTMO');

hdrvclose(hdrv);

%removing the temporary file for tone mapping
delete([nameOut,'_WS05_tmo_tmp.',fileExt]);

end
