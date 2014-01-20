function MantiukBackwardHDRvEnc(hdrv, name, hdrv_profile, hdrv_quality)
%
%
%       MantiukBackwardHDRvEnc(hdrv, name, hdrv_profile, hdrv_quality)
%
%
%       Input:
%           -hdrv: HDR image
%           -name: is output name of the image
%           -hdrv_profile: 
%           -hdrv_quality: is JPEG output quality in [0,100]
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
%     The paper describing this technique is:
%     "Backward Compatible High Dynamic Range MPEG Video Compression"
% 	  by Rafal Mantiuk, Alexander Efremov, Karol Myszkowski, and Hans-Peter Seidel 
%     in ACM SIGGRAPH 2006
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

nameOut = RemoveExt(name);
fileExt = fileExtension(name);
nameResiduals = [nameOut,'_residuals.',fileExt];

%Opening hdr stream
hdrv = hdrvopen(hdrv);

%Opening compression streams
StaticTMOv(hdrv, name, @ReinhardTMO, -1.0, hdrv_quality, hdrv_profile);

%video Residuals pass
readerObj = VideoReader(name);

writerObj_residuals = VideoWriter(nameResiduals, hdrv_profile);
writerObj_residuals.Quality = hdrv_quality;
open(writerObj_residuals);

RFv = zeros(256,hdrv.totalFrames);
Qv  = zeros(256,hdrv.totalFrames);

for i=1:hdrv.totalFrames
    disp(['Processing frame ',num2str(i)]);
    
    %HDR frame
    [frame, hdrv] = hdrvGetFrame(hdrv, i);
    frame_Y = lum(frame);
    frame_luma = MantiukLumaCoding(frame_Y, 0);
    
    %Tone mapped frame
    frameTMO = double(read(readerObj, i));  
 
    %Residuals
    Ld = round(lum(frameTMO));
    [imgR, RF, Q] = MantiukResidualImage(Ld, frame_luma);
    
    %Residuals filtering    
    writeVideo(writerObj_residuals, (imgR + 127)/255);
    RFv(:,i) = RF;
    Qv(:,i) = Q;
end

close(writerObj_residuals);

save([nameOut,'_RF.dat'], 'RFv','Qv');

hdrvclose(hdrv);

end