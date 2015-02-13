function imgOut = KuangTMO(img, type_param, p_param, average_surrond_param)
%
%
%       imgOut = KuangTMO(img, type_param, p_param)
%
%       Input:
%           -img: an HDR image in the RGB color space
%           -type_param:
%               'calibrated': values in img are calibrated.
%               'unknown': default value; the maximum point is set to 
%               20,000 cd/m^2 as suggeted in the original paper.
%           -p_param: a value in [0.6, 0.85]
%           -average_surrond_param: 
%               'dark':
%               'average':
%               'dim':
%
%       Output:
%           -imgOut: tone mapped image
% 
%     Copyright (C) 2015  Francesco Banterle
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
%     "iCAM06: A refined image appearance model for HDR image rendering"
% 	  by Jiangtao Kuang, Garrett M. Johnson, and Mark D. Fairchild
%     in J. Vis. Commun. Image R. 18 (2007) 406–-414
%

%is it a three color channels image?
check3Color(img);

if(~exist('p_param', 'var'))
    p_param = 0.7;
end

p_param = ClampImg(p_param, 0.6, 0.85);

if(~exist('type_param', 'var'))
    type_param = 'unknown';
end

if(strcmp(type_param, 'unknown'))
    L = lum(img);
    img = (img / max(L(:))) * 2e4;
end

if(~exist('average_surrond_param', 'var'))
    average_surrond_param = 'average';
end

%converting from RGB to XYZ
imgXYZ = ConvertRGBtoXYZ(img, 0);

[r, c, col] = size(img);
minSize = min([r, c]);

%decomposing the image into detail and base layers: Section 2.2 of the
%original paper
sigma_s = minSize * 0.02; %as in the original paper
sigma_r = 0.35; %as in the original paper

imgBase = zeros(size(img));
for i=1:col
    tmp = log10(imgXYZ(:,:,i));
    imgBase(:,:,i) = 10.^bilateralFilter(tmp, [], min(tmp(:)), max(tmp(:)), sigma_s, sigma_r);
end

imgDetail = imgXYZ ./ imgBase;

%computing Chromatic adaptation: Section the 2.3 of the original paper
M_CAT02 = [ 0.7328 0.4296 -0.1624;...
           -0.7036 1.6975  0.0061;...
            0.003  0.0136  0.9834];

img_RGB_w = ConvertLinearSpace(GaussianFilterWindow(imgXYZ, max([r, c]), 8), M_CAT02);

imgRGB = ConvertLinearSpace(imgBase, M_CAT02); %Equation 5       
        
Y_W = lum(img_RGB_w);
L_A = 0.2 * Y_W;

D = CIECAM02_DegreeAdaptation(L_A);

wp_D65_XYZ = [96.047, 100, 108.883]; %D65 white point in XYZ
wp_D65_RGB = ConvertLinearSpace(reshape(wp_D65_XYZ, 1, 1, 3), M_CAT02);

imgRGB_c = zeros(size(imgRGB));
for i=1:col
    %Equation 6, 7, 8
    imgRGB_c(:,:,i) = imgRGB(:,:,i) .* (wp_D65_RGB(i) .* D ./ img_RGB_w(:,:,i) + (1.0 - D));
end

%non-linear tone compression: Section 2.4 of the original paper
M_HPE = [   0.38971 0.68898 0.07868; ...
            0.22981 1.18340 0.04641; ...
            0.0     0.0     1.0];
            
imgRGB_p = ConvertLinearSpace(imgXYZ, M_HPE * inv(M_CAT02)); %Equation 9

F_L = CIECAM02_F_L(L_A);

p = p_param;
imgRGB_p_a = zeros(size(img));
for i=1:col
    %Equation 10, 11, 12
    tmp = (F_L .* imgRGB_p(:,:,i) ./ Y_W).^p;
    imgRGB_p_a(:,:,i) = (400 * tmp) ./ (27.13 + tmp) + 0.1;
end

clear('imgRGB_p');

imgDetail = StevensonDetailEnhancement(imgDetail, F_L); %Equation 24

%Hunt's model
S = lum(imgRGB_c);
S_w = max(S(:));
S_t = S ./ S_w;

L_LS = 5 * L_A;

B_S = 0.5 ./ (1 + 0.3 *(L_LS .* S_t ).^0.3) + ...
      0.5 ./ (1 + 5 * L_LS); %Equation 19

j = 1e-4 ./ (L_LS + 1e-4); %Equation 18
  
F_LS = 3800 * j.^2 .* L_LS + ... 
       0.2 * (1 - j.^2).^4 .* L_LS.^(1 / 6); %Equation 16

tmp = (F_LS .* S_t).^p;
A_S = 3.05 * B_S .* (400 * tmp ./ (27.13 + tmp) ) + 0.3; %Equation 15

imgRGB_tc = zeros(size(imgRGB_p_a));
for i=1:col
    imgRGB_tc(:,:,i) = imgRGB_p_a(:,:,i) + A_S; %Equation 20
end

clear('imgRGB_p_a');

%image attribute adjustments: Section 2.6
img_wd_XYZ = ConvertRGBtoXYZ(imgRGB_tc, 0) .* imgDetail;

clear('imgDetail');
clear('imgRGB_tc');

imgIPT = ConvertXYZtoIPT(img_wd_XYZ, 0);

gamma_value = 1.0; %Equation 27
switch average_surrond_param
    case 'dark'
        gamma_value = 1.5;
        
    case 'dim'
        gamma_value = 1.25
        
    case 'average'
        gamma_value = 1.0;
        
    otherwise
        gamma_value = 1.0;
end

imgIPT(:,:,1) = NormalizedGamma(imgIPT(:,:,1), gamma_value);

%computing color
C = IPTColorfullness(imgIPT);
L_A = imgBase(:,:,2) * 0.2;
F_L = CIECAM02_F_L(L_A);
scale = (F_L + 1).^0.2 .* (1.29 * C.^2 - 0.27 * C + 0.42) ./ (C.^2 - 0.31 * C + 0.42);

for i=2:col
    %Equation 25, 26
    imgIPT(:,:,i) = imgIPT(:,:,i) .* scale; 
end

imgOut = ConvertRGBtoXYZ(ConvertXYZtoIPT(imgIPT, 1), 1); 

imgOut = ClampImg(imgOut / MaxQuart(imgOut, 0.99), 0.0, 1.0);

disp('WARNING: the output image has D65 as whitepoint.');

end
