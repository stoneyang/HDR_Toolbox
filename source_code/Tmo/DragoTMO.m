function [imgOut, Drago_LMax] = DragoTMO(img, Drago_Ld_Max, Drago_b, Drago_LMax)
%
%
%        [imgOut, Drago_LMax] = DragoTMO(img, Drago_Ld_Max, Drago_b, Drago_LMax)
%
%
%        Input:
%           -img: input HDR image
%           -Drago_Ld_Max: maximum output luminance of the LDR display
%           -Drago_b: bias parameter to be in (0,1]. The default value is 0.85 
%           -Drago_LMax: maximum luminance to be used in case of tone
%           mapping HDR videos
%
%        Output:
%           -imgOut: tone mapped image
%           -Drago_LMax: max luminance in img
% 
%     Copyright (C) 2010-13 Francesco Banterle
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

%Is it a three color channels image?
check13Color(img);

if(~exist('Drago_Ld_Max','var'))
    Drago_Ld_Max = 100; %cd/m^2
end

if(~exist('Drago_b','var'))   
    Drago_b = 0.85;
end

%Luminance channel
L=lum(img);

LMax = 0;

if(~exist('Drago_LMax','var'))
    LMax = max(L(:));
else
    LMax = Drago_LMax*0.5+0.5*max(L(:));%smoothing in case of videos
    Drago_LMax = LMax;
end

constant = log(Drago_b)/log(0.5);
costant2 = (Drago_Ld_Max/100)/(log10(1+LMax));

Ld = costant2*log(1+L)./log(2+8*((L/LMax).^constant));

%Changing luminance
imgOut = ChangeLuminance(img, L, Ld);

end
