function target_exposure = GetTargetExposure(stack, folder_name, format)
%
%
%       stackOut = SiftAlignment(stack, bStackOut, folder_name, format,
%       target_exposure)
%
%       This function shifts pixels on the right with wrapping of the moved
%       pixels. This can be used as rotation on the Y-axis for environment
%       map encoded as longituted-latitude encoding.
%
%       Input:
%           -stack: a stack (4D) containing all images.
%           -folder_name: the folder name where the stack is stored. This flag
%           is valid if stack is empty, [].
%           -format: the file format of the stack. This flag is valid if
%           stack is empty, [].
%
%       Output:
%           -target_exposure: the index of the target exposure for alignment.
%
%     Copyright (C) 2013-15  Francesco Banterle
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

bStack = ~isempty(stack);

if(~bStack)
    lst = dir([folder_name, '/*.', format]);
    n = length(lst);
else
    n = size(stack, 4);
end

disp('Finding the best target exposure...');
values = zeros(n, 1);
for i=1:n
    if(bStack)
        img_tmp = stack(:,:,:,i);
    else
        img_tmp = ldrimread([folder_name, '/', lst(i).name], 0);
    end
    
    values(i) = mean(img_tmp(:));
    clear('img_tmp');
end

[~, indx] = sort(values);
    
target_exposure = indx(round(n / 2));

disp('OK');
    
end