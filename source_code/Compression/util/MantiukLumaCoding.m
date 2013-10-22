function lw = MantiukLumaCoding(Lw)
%
%
%       lw = MantiukLumaCoding(Lw)
%
%
%       Input:
%           -Lw: input HDR luminance
%
%       Output:
%           -lw: luma; compressed luminance for MPEG-HDR Algorithm
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

lw = Lw;

lw(Lw<5.604) = 17.554*lw(Lw<5.604);
lw((Lw>=5.604)&(Lw<10469)) = 826.8*(lw((Lw>=5.604)&(Lw<10469)).^0.10013)-884.17;
lw(Lw>=10469) = 209.16*log(lw(Lw>=10469))-731.28;

end