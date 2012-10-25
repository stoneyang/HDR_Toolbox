function expand_map=RempelExpandMapPyr(L, video_flag)
%
%		 expand_map=RempelExpandMapPyr(L, video_flag)
%
%        Rempel et al.'s expand maps using Laplacian Pyramids
%
%		 Input:
%			-L: a luminance channel
%			-video_flag: a flag, true if a video is used
%
%		 Output:
%			-expand_map: the final expand map
%
%     Copyright (C) 2012  Francesco Banterle
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

%saturated pixels threshold
thresholdImg=250/255;		%Images
thresholdVideo=230/255;		%Videos

if(~exist('video_flag'))
    video_flag = 0;
end

if(video_flag)
	threshold=thresholdVideo;
else
	threshold=thresholdImg;
end

%binary map for saturated pixels
indx=find(L>threshold);
mask=zeros(size(L));
mask(indx)=1;
mask=double(bwmorph(mask,'clean'));

%Filtering with a 150x150 Gaussian kernel size
mask_pyr = pyrGaussGen(mask,64);
mask_pyr_blur = pyrGaussianBlur(mask_pyr,3);
sbeFil = pyrVal(mask_pyr_blur);

%Normalization
sbeFilMax=max(sbeFil(:));									
if(sbeFilMax>0.0)
	sbeFil=sbeFil/sbeFilMax;
end

%Calculation of the gradients of L using a 5x5 mask to have thick edges
Sy=[-1,-4,-6,-4,-1,...
       -2,-8,-12,-8,-2,...
       0,0,0,0,0,...
       2,8,12,8,2,...
       1,4,6,4,1];
Sx=Sy';

dy=imfilter(L,Sy);
dx=imfilter(L,Sx);

grad=sqrt(dx.^2+dy.^2);         %magnitude of the directional gradient
grad=grad/max(max(grad));
grad_pyr = pyrGaussGen(grad,64);

%threshold for the gradient
tr=0.05;   
edge_stop = round(mask_pyr.base);
tmp=double(bwmorph(edge_stop,'dilate'));
tmp=abs(tmp-edge_stop);
edge_stop(tmp>0&grad_pyr.base<tr)=1;    

n = length(grad_pyr.list); 
for i=1:n
    ind=n-i+1;
    [r,c]=size(grad_pyr.list(ind).detail);    
    edge_stop = imresize(edge_stop, [r,c],'nearest');
    
    tmp=double(bwmorph(edge_stop,'dilate'));
    tmp=abs(tmp-edge_stop);
    edge_stop(tmp>0&grad_pyr.list(ind).detail<tr)=1;    
end
 
%Multiply the flood fill mask with the BEF
expand_map = sbeFil.*edge_stop;

end