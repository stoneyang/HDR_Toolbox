function [imgOut, expand_map] = BanterleEO(img, expansion_operator, eo_parameters, BEM_bColorRec, BEM_clamping_threshold, BEM_bHighQuality, gammaRemoval, bNoiseRemoval)
%                                                                                   
%       [imgOut, expand_map] =  BanterleEO(img, expansion_operator, eo_parameters, BEM_BEM_bColorRec, BEM_clamping_threshold, BEM_bHighQuality, gammaRemoval, bNoiseRemoval)
%
%
%        Input:
%           -img: input LDR image. There is no assumption about the
%           linearization of the image. If the gamma was encoded using
%           inverse gamma, this should be removed using the paramter
%           gammaRemoval.
%           -expansion_operator: an expansion function which takes as input
%           img and eo_parameters. This outputs the expanded luminance
%           -eo_parameters: the strecthing factor of the 
%           -BEM_clamping_threshold: if it is greater than 0, this value
%           determines the threshold for clamping light sources. Otherwise
%           this parameter is estimated automatically.
%           -BEM_bColorRec: a boolean value. If it is set 1 the expand map will
%           be calculated for each color channel
%           -BEM_bHighQuality: a boolean value. If it is set to 1,
%           LischinskiMinimization will be used for better quality. This
%           takes more than using the bilateral filter. You may need MATLAB
%           at 64-bit for running high quality edge transer at HD
%           resolution (1920x1080)
%           -gammaRemoval: the gamma value to be removed if img was encoded
%           using gamme encoding
%           -bNoiseRemoval: a boolean value. If it is set 1 it will apply a
%           gentle bilateral filter to the image in order to remove noise
%
%        Output:
%           -imgOut: inverse tone mapped image
%           -expand_map: the generated expand map
%
%     Copyright (C) 2011  Francesco Banterle
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

check13Color(img);

if(~exist('gammaRemoval','var'))
    gammaRemoval = 2.2;
end

%Gamma removal
if(gammaRemoval>0.0)
    img=img.^gammaRemoval;
end

if(~exist('expansion_operator','var'))
    expansion_operator = @InverseReinhard;
end

if(~exist('bNoiseRemoval','var'))
    bNoiseRemoval = 0;
end

if(~exist('BEM_bHighQuality','var'))
    BEM_bHighQuality = 1;
end

col = size(img,3);

%Apply a gentle bilateral filter for removing noise
if(bNoiseRemoval)
    sigma_r = 0.01;

    switch col
        case 1
            img = bilateralFilter(img,[],0.0,1.0,4.0,sigma_r);            
        
        case 3
            imgLab = ConvertXYZtoCIELab(ConvertRGBXYZ(img,0),0);

            for i=1:col
                tmp = imgLab(:,:,i);
                minC = min(tmp(:));
                maxC = max(tmp(:));
                tmp = (tmp-minC)/(maxC-minC);
                imgLab(:,:,i) = bilateralFilter(tmp,[],0.0,1.0,4.0,sigma_r)*(maxC-minC)+minC;
            end 
            
            img = ConvertRGBXYZ(ConvertXYZtoCIELab(imgLab,1),1);
            
        otherwise
            for i=1:col
                img(:,:,i) = bilateralFilter(img(:,:,i),[],0.0,1.0,4.0,sigma_r);
            end           
    end
end

hdrimwrite(img,'img.pfm');
%Luminance expansion
Lexp = expansion_operator(img, eo_parameters);

%Combining expanded and unexpanded luminance channels
expand_map = BanterleExpandMap(img, BEM_bColorRec, BEM_clamping_threshold, 0.95, 'gaussian', BEM_bHighQuality);

L = lum(img);
LFinal = zeros(size(img));
for i=1:col
    LFinal(:,:,i) = L.*(1-expand_map(:,:,i))+Lexp.*expand_map(:,:,i);
    LFinal(:,:,i) = RemoveSpecials(LFinal(:,:,i));
end

clear('Lexp');

%Generate the final image with the new luminance
imgOut = zeros(size(img));
for i=1:col
    imgOut(:,:,i)=(img(:,:,i).*LFinal(:,:,i))./L;
end

imgOut = RemoveSpecials(imgOut);

end
