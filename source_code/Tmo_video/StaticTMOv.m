function StaticTMOv(hdrv, filenameOutput, tmo_operator, tmo_gamma)
%
%
%       StaticTMOv(hdrv, filenameOutput, tmo_operator, tmo_gamma)
%
%
%       Input:
%           -hdrv: a HDR video structure; use hdrvread to create a hdrv
%           structure
%           -filenameOutput: output filename (if it has an image extension,
%           single files will be generated)
%           -tmo_operator: the tone mapping operator to use
%           -tmo_gamma: gamma for encoding the frame
%
%       Output:
%           -frameOut: the tone mapped frame
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
%
%     This function applies a static TMO to an operator without taking into
%     account for temporal coherency
%

if(~exist('filenameOutput','var'))
    date_str = strrep(datestr(now()),' ','_');
    date_str = strrep(date_str,':','_');
    filenameOutput = ['static_tmo_output_',date_str,'.avi'];
end

if(~exist('tmo_operator','var'))
    tmo_operator = @ReinhardBilTMO;
end

if(~exist('tmo_gamma','var'))
    tmo_gamma = 2.2;
end

name = RemoveExt(filenameOutput);
ext = fileExtension(filenameOutput);

bVideo = 0;
writerObj = 0;

if(strfind(ext,'avi')||strfind(ext,'mp4'))
    bVideo = 1;
    writerObj = VideoWriter(filenameOutput);
    writerObj.FrameRate = hdrv.FrameRate;
    open(writerObj);
end

hdrv = hdrvopen(hdrv);

disp('Tone Mapping...');
for i=1:hdrv.totalFrames
    disp(['Processing frame ',num2str(i)]);
    [frame, hdrv] = hdrvGetFrame(hdrv, i);

    %Tone mapping
    frameOut = RemoveSpecials(tmo_operator(frame)); 
    frameOut_gamma = GammaTMO(frameOut,tmo_gamma,0.0,0);
    
    %Storing 
    if(bVideo)
        writeVideo(writerObj,frameOut_gamma);
    else
        imwrite(frameOut_gamma,[name,sprintf('%.10d',i),'.',ext]);
    end
    
end
disp('OK');

if(bVideo)
    close(writerObj);
end

hdrv = hdrvclose(hdrv);

end