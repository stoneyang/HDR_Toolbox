function [val, eMax, eMin] = mPSNR(img1, img2, eMin, eMax)
%
%
%      [val, eMax, eMin] = mPSNR(img1, img2, eMin, eMax)
%
%
%       Input:
%           -img1: input image
%           -img2: input image
%           -eMin: the minimum exposure for computing mPSNR. If not given it is
%           automatically inferred.
%           -eMax: the maximum exposure for computing mPSNR. If not given it is
%           automatically inferred.
%
%       Output:
%           -val: the multiple-exposure PSNR value. Higher values means
%           better quality.
%           -eMax: the maximum exposure for computing mPSNR
%           -eMin: the minimum exposure for computing mPSNR
% 
%     Copyright (C) 2006  Francesco Banterle
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

[r,c,col]=size(img1);

if(~exist('eMin')||~exist('eMax'))
    L     = lum(img2);
    LLog2 = log2(L+1e-6);
    minL  = min(min(LLog2));
    maxL  = max(max(LLog2));

    if(minL<0)
        eMin = floor(minL);
    else
        eMin = ceil(minL);
    end

    if(maxL<0)
        eMax = floor(maxL);
    else
        eMax = ceil(maxL);
    end
end

if(CheckSameImage(img1,img2)==0)
    error('The two images are different they can not be used or there are more than one channel.');
end

if((eMax-eMin)<=0)
    error('eMin can be bigger than eMax!');
end

invGamma = 1.0/2.2;%inverse gamma value

eVec =[];
eMean=[];

MSE=0;
acc=0;
for i=eMin:eMax
    espo=2^i;%Exposure
   
    tImg1 = ClampImg(round(255*((espo*img1).^invGamma))/255,0,1);
    val = mean(tImg1(:));%mean value

    if((val>0.1)&&(val<0.9))
        eMean = [eMean, val];
        eVec  = [eVec,  i];
        
        tImg2 = ClampImg(round(255*((espo*img2).^invGamma))/255,0,1);

        delta = 255*(tImg1-tImg2);        
        deltaSquared = sum(delta.^2, 3); 
        
        MSE=MSE+mean(deltaSquared(:));
        acc=acc+1;
    end
end

eMax = max(eVec);
eMin = min(eVec);

val = -1;

if(acc>0)
    MSE = MSE/acc;
    val = 10*log10(3*255^2/MSE);
end

end