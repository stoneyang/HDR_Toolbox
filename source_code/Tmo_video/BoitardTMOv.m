function BoitardTMOv(hdrv, filename, tmo_operator, tmo_gamma)
%
%
%       BoitardTMOv(hdrv, filename, tmo_operator, tmo_gamma)
%
%
%       Input:
%           -hdrv: a HDR video structure
%           -filename: output filename (if it has an image extension,
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

if(~exist('tmo_operator'))
    tmo_operator = @ReinhardTMO;
end

if(~exist('tmo_gamma'))
    tmo_gamma = 2.2;
end

[hm_v, max_v, min_v, mean_v] = hdrvAnalysis(hdrv);

[max_log_mean_HDR,index] = max(hm_v);
[frame, hdrv] = getNextFrame(hdrv, index);

frame_tmo = tmo_operator(RemoveSpecials(frame));
max_log_mean_LDR = logMean(lum(frame_tmo));

name = RemoveExt(filename);
ext = fileExtension(filename);
for i=1:hdrv.totalFrames
    [frame, hdrv] = getNextFrame(hdrv, i);
    frameOut = BoitardTMOv_frame(RemoveSpecials(frame), max_log_mean_HDR, max_log_mean_LDR, tmo_operator, tmo_gamma);

    imwrite(frameOut,[name,num2str(1000+i),'.',ext]);
    
end


end