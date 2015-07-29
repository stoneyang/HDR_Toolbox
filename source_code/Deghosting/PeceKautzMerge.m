function imgOut = PeceKautzMerge(imageStack, folder_name, format, iterations, ke_size, kd_size, ward_percentile)
%
%
%        imgOut = PeceKautzMerge(imageStack, folder_name, format, iterations, kernelSize, ward_percentile)
%
%
%        Input:
%           -imageStack: an exposure stack of LDR images
%           -folder_name: the folder where to fetch the exposure imageStack in
%           the case imageStack=[]
%           -format: the format of LDR images ('bmp', 'jpg', etc) in case
%                    imageStack=[] and the tone mapped images is built from a sequence of
%                    images in the current folder_name
%           -iterations: number of iterations for improving the movements'
%           mask
%           -ke_size: size of the erosion kernel
%           -kd_size: size of the dilation kernel
%           -ward_percentile: 
%
%        Output:
%           -imgOut: tone mapped image
%
%        Note: Gamma correction is not needed because it works on gamma
%        corrected images.
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
%     The paper describing this technique is:
%     "Bitmap Movement Detection: HDR for Dynamic Scenes"
% 	  by Fabrizio Pece, Jan Kautz
%     in Conference on Visual Media Production (CVMP)
%     London, UK, November 2010
%

%imageStack generation
if(~exist('imageStack', 'var'))
    imageStack = [];
end

if(isempty(imageStack))
    imageStack = ReadLDRStack(folder_name, format, 1);
end
       
if(isa(imageStack, 'uint8'))
    imageStack = single(imageStack) / 255.0;
end
       
if(isa(imageStack, 'uint16'))
    imageStack = single(imageStack) / 655535.0;
end

if(~exist('iterations', 'var'))
    iterations = 1;
end

if(~exist('ke_size', 'var'))
    ke_size = 3;
end

if(~exist('kd_size', 'var'))
    kd_size = 17;
end

if(~exist('ward_percentile', 'var'))
    ward_percentile = 0.6;
end

%number of images in the stack
[r, c, col, n] = size(imageStack);

%Computation of weights for each image
total  = zeros(r, c);
weight = ones(r, c, n);
for i=1:n
    %calculation of the weights
    L = lum(imageStack(:,:,:,i));  

    weight(:,:,i) = MertensWellExposedness(imageStack(:,:,:,i));
    
    weight(:,:,i) = weight(:,:,i) .* MertensContrast(L);
     
    weight(:,:,i) = weight(:,:,i) .* MertensSaturation(imageStack(:,:,:,i));
    
    weight(:,:,i) = weight(:,:,i) + 1e-12;  
end

[moveMask, num] = PeceKautzMoveMask(imageStack, iterations, ke_size, kd_size, ward_percentile);
weight_move = weight;
for i=0:num
    indx = find(moveMask == i);
    
    Wvec = zeros(n,1);
    for j=1:n
        W = weight(:,:,j);
        Wvec(j) = mean(W(indx));
    end
    [~, j] = max(Wvec);

    W = zeros(r, c);
    W(indx) = 1;
    weight_move(:,:,j) = weight_move(:,:,j) .* (1 - W) + W;
    
    for k=1:n
        if(j ~= k)
            weight_move(:,:,k) = weight_move(:,:,k) .* (1 - W);
        end
    end
end

%Normalization of weights
for i=1:n
    %hdrimwrite(weight_move(:,:,i),['weight_move',num2str(i),'.pfm']);
    total = total + weight_move(:,:,i);
end

%empty pyramid
tf = [];
for i=1:n
    %Laplacian pyramid: image
    pyrImg = pyrImg3(imageStack(:,:,:,i), @pyrLapGen);

    %Gaussian pyramid: weight_i
    weight_i = RemoveSpecials(weight_move(:,:,i) ./ total);
    pyrW   = pyrGaussGen(weight_i);

    %Multiplication image times weights
    tmpVal = pyrLstS2OP(pyrImg, pyrW, @pyrMul);
   
    if(i == 1)
        tf = tmpVal;
    else
        %accumulation
        tf = pyrLst2OP(tf, tmpVal, @pyrAdd);    
    end
end

%Evaluation of Laplacian/Gaussian Pyramids
imgOut = zeros(r, c, col);
for i=1:col
    imgOut(:,:,i) = pyrVal(tf(i));
end

%Clamping
imgOut = ClampImg(imgOut, 0.0, 1.0);

disp('This algorithm outputs images with gamma encoding. Inverse gamma is not required to be applied!');
end

