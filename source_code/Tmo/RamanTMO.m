function imgOut = RamanTMO( img, directory, format)
%
%
%        imgOut = RamanTMO( img, directory, format)
%
%
%        Input:
%           -img: input HDR image
%           -directory: the directory where to fetch the exposure stack in
%           the case img=[]
%           -format: the format of LDR images ('bmp', 'jpg', etc) in case
%                    img=[] and the tone mapped images is built from a sequence of
%                    images in the current directory
%
%        Output:
%           -imgOut: tone mapped image
%
%        Note: Gamma correction is not needed because it works on gamma
%        corrected images.
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

%stack generation
stack=[];

if(~isempty(img))
    %Convert the HDR image into a stack
    [stack,stack_exposure] = GenerateExposureBracketing(img,1);
else
    %load images from the current directory
    images=dir([directory,'/','*.',format]);
    n = length(images);
    for i=1:n
        stack(:,:,:,i) = single(imread([directory,'/',images(i).name]))/255.0;
    end
end

C = 70.0/255.0; %As reported in Raman and Chaudhuri Eurographics 2009 short paper

%number of images in the stack
[r,c,col,n]=size(stack);

K1 = 1.0;%As reported in Raman and Chaudhuri Eurographics 2009 short paper
K2 = 1.0/10.0;%As reported in Raman and Chaudhuri Eurographics 2009 short paper
sigma_s = K1 * min([r,c]);
stackMax = max(stack(:));
stackMin = min(stack(:));
sigma_r = K2 * (stackMax-stackMin);

%Computation of weights for each image
total = zeros(r,c);
weight = zeros(r,c,n);
for i=1:n
    L = lum(stack(:,:,:,i));
    L_filtered = bilateralFilter(L,[],stackMin,stackMax,sigma_s,sigma_r);
    weight(:,:,i) = C + abs(L-L_filtered);
    total = total + weight(:,:,i);
end

%merging
imgOut = zeros(r,c,col);
for i=1:n
    for j=1:col
        tmp = stack(:,:,j,i).*weight(:,:,i)./total;
        imgOut(:,:,j) = imgOut(:,:,j) + RemoveSpecials(tmp);
    end
end

%Clamping
imgOut = ClampImg(imgOut,0.0,1.0);

disp('This algorithm outputs images with gamma encoding. Inverse gamma is not required to be applied!');
end