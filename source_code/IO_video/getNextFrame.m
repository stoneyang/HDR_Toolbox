function [frame, hdrv] = getNextFrame(hdrv, frameCounter)
%
%       [frame, hdrv] = hdrimread(filename)
%
%
%        Input:
%           -hdrv: a HDR video structure
%           -frameCounter: a frame to be read, if it is not defined the
%           current frame will be read.
%
%        Output:
%           -frame: the frame at frameCounter
%           -hdrv: the updated HDR video structure
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

maxFrames = length(hdrv.list);

if(~exist('frameCounter'))
    frameCounter = hdrv.frameCounter;
else
    if(frameCounter<1)
        frameCounter = 1;
    end
    
    if(frameCounter>maxFrames)
        frameCounter = maxFrames;
    end
end

frame = hdrimread([hdrv.path,'/',hdrv.list(frameCounter).name]);

hdrv.frameCounter = mod(frameCounter + 1, maxFrames+1);

end