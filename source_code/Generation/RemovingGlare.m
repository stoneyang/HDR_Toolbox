function [imgOut, imgGlare, PSF] = RemovingGlare( img )
%
%       [imgOut, imgGlare, PSF] = RemovingGlare( img )
%
%       This function estimates the PSF of a camera from a single HDR image
%       and it removes veiling glare
%
%        Input:
%           -img: an HDR image
%
%        Output:
%           -imgOut: the input HDR image, img, with reduced glare
%           -imgGlare: the removed glare
%           -PSF: the estimated point spread function
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
%

[r,c,col] = size(img);

Icr = imresize(img, [round(r*128/c), 128], 'bilinear');

Igr = lum(Icr); 

thr = 1000.0 * min(Igr(Igr>0.0));

%getting hot pixels' positions
[y_h, x_h] = find(Igr>thr);

%getting dark pixels' positions
[y_d, x_d] = find(Igr<=thr);

m = length(y_h);
n = length(y_d);
A = zeros(n, 4);

tot = sum(Igr(Igr>thr));

for i=1:length(y_d)
   A(i, 1) = tot;
   
   for j=1:m
       r2 = (x_h(j) - x_d(i)).^2 + (y_h(j) - y_d(i)).^2;
       r  = sqrt(r2);
       
       if(r>=3) 
           P_j = Igr(y_h(j), x_h(j));

           A(i, 2) = A(i, 2) + P_j/r;
           A(i, 3) = A(i, 3) + P_j/r2;
           A(i, 4) = A(i, 4) + P_j/(r2*r);
       end
   end
end

b = Igr(Igr<=thr);

C = A\b;

[x, y] = meshgrid(1:33,1:33);
x = x - 16;
y = y - 16;
r = max(sqrt(x.^2 + y.^2),3);
PSF = C(1) + C(2)./r + C(3)./(r.^2) + C(4)./(r.^3);

col = zeros(m, 3);
for i=1:m
    col(i, :) = Icr(y_h(i), x_h(i), :); 
end

pos = [x_h'; y_h'];

[imgOut, counter_map] = imSplat(size(Icr, 1), size(Icr, 2),PSF, pos, col);

%compensation
while(1)
    ind = find(imgOut>Icr);
       
    if(isempty(ind))
        break
    end
    
    scale = Icr(ind(1)) / imgOut(ind(1)) * 0.99;
    
    imgOut = imgOut * scale;
end 

imgGlare = imresize(imgOut, [size(img, 1), size(img, 2)], 'bilinear');

imgOut = (img - imgGlare);

end

