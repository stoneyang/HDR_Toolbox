function [imgOut, lin_fun] = BuildHDR(stack, stack_exposure, lin_type, lin_fun, weight_type, merge_type, bMeanWeight)
%
%       [imgOut, lin_fun] = BuildHDR(stack, stack_exposure, lin_type, lin_fun, weight_type, merge_type, bMeanWeight)
%
%       This function builds an HDR image from a stack of LDR images.
%
%        Input:
%           -stack: an input stack of LDR images. This has to be set if we
%           the stack is already in memory and we do not want to load it
%           from the disk using the tuple (dir_name, format).
%           -stack_exposure: an array containg the exposure time of each
%           image. Time is expressed in second (s).
%           -lin_type: the linearization function:
%                      - 'linear': images are already linear
%                      - 'gamma2.2': gamma function 2.2 is used for
%                                    linearisation;
%                      - 'sRGB': images are encoded using sRGB
%                      - 'LUT': the lineraziation function is a look-up
%                               table defined stored as an array in the 
%                               lin_fun 
%           -lin_fun: it is the camera response function of the camera that
%           took the pictures in the stack. If it is empty, [], and 
%           type is 'LUT' it will be estimated using Debevec and Malik's
%           method.
%           -weight_type:
%               - 'all':   weight is set to 1
%               - 'hat':   hat function 1-(2x-1)^12
%               - 'Deb97': Debevec and Malik 97 weight function
%               - 'Gauss': Gaussian function as weight function.
%                          This function produces good results when some 
%                          under-exposed or over-exposed images are present
%                          in the stack.
%           -merge_type:
%               - 'linear': it merges different LDR images in the linear
%               domain.
%               - 'log': it merges different LDR images in the natural
%               logarithmic domain.
%               - 'robertson': it merges different LDR images in the linear
%               domain using Robertson et al.'s weighting.
%           -bRobertson: if it is set to 1 it enables the Robertson's
%           modification for assembling exposures for reducing noise.
%           This value is set to 0 by default.
%
%        Output:
%           -imgOut: the final HDR image.
%           -lin_fun: the camera response function.
%
%        Example:
%           This example line shows how to load a stack from disk:
%
%               stack = ReadLDRStack('stack_alignment', 'jpg');               
%               
%               stack_exposure = ReadLDRExif('stack_alignment', 'jpg');
%               
%               BuildHDR(stack, stack_exposure,'tabledDeb97',[],'Deb97');
%
%
%     Copyright (C) 2011-15  Francesco Banterle
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

%merge type, if it is not set the default is 'log'
if(~exist('merge_type', 'var'))
    merge_type = 'linear';
end

if(~exist('bMeanWeight', 'var'))
    bMeanWeight = 0;
end

%is a weight function defined?
if(~exist('weight_type', 'var'))
    weight_type = 'all';
end

%is the linearization type of the images defined?
if(~exist('lin_type', 'var'))
    lin_type = 'gamma2.2';
end

%do we have the inverse camera response function?
if(~exist('lin_fun', 'var'))
    lin_fun = [];
end

if(isempty(stack) || isempty(stack_exposure))
    error('The stack is set empty!');
end

%merging
[r, c, col, n] = size(stack);

imgOut    = zeros(r, c, col, 'single');
totWeight = zeros(r, c, col, 'single');

scale = 1.0;

if(isa(stack, 'uint8'))
    scale = 255.0;
end

if(isa(stack, 'uint16'))
    scale = 65535.0;
end


if(isa(stack, 'double') | isa(stack, 'single'))
    max_val = max(stack(:));
    if(max_val > 1.0) 
        scale = max_val;
    end
end

%is the inverse camera function ok? Do we need to recompute it?
if((strcmp(lin_type, 'LUT') == 1) && isempty(lin_fun))
    [lin_fun, ~] = ComputeCRF(single(stack) / scale, stack_exposure);        
end

%for each LDR image...
for i=1:n
    tmpStack = ClampImg(single(stack(:,:,:,i)) / scale, 0.0, 1.0);
    
    %computing the weight function    
    weight  = WeightFunction(tmpStack, weight_type, bMeanWeight);

    %linearization of the image
    switch lin_type
        case 'gamma2.2'
            tmpStack = tmpStack.^2.2;

        case 'sRGB'
            tmpStack = ConvertRGBtosRGB(tmpStack, 1);
        
        case 'LUT'
            tmpStack = tabledFunction(round(tmpStack * 255), lin_fun);            
        otherwise
    end
   
    %summing things up...
    t = stack_exposure(i);    
    if(t > 0.0)
        switch merge_type
            case 'linear'
                imgOut = imgOut + (weight .* tmpStack) / t;
                totWeight = totWeight + weight;
            
            case 'log'
                imgOut = imgOut + weight .* (log(tmpStack) - log(t));
                totWeight = totWeight + weight;                
            
            case 'robertson'
                imgOut = imgOut + (weight .* tmpStack) * t;
                totWeight = totWeight + weight * t * t;
        end
    end
end

imgOut = (imgOut ./ totWeight);

if(strcmp(merge_type, 'log') == 1)
    imgOut = exp(imgOut);
end

%checking for saturated pixels
bSaturation = 0;
if(~isempty(totWeight <= 0.0))
    bSaturation = 1;
    disp('WARNING: the stack has saturated pixels.');
end

%handling saturated pixels
if(bSaturation)
    [~, index] = min(stack_exposure);
 
    for i=1:col
        max_val = double(max(max(stack(:,:,i,index)))) / (t * scale);
 
        saturation_value = max_val;
        for j=1:n
            if(j ~= index)
                saturation_value = saturation_value + (1.0 / stack_exposure(j));
            end
        end
 
        tmp = imgOut(:,:,i);
        
        tmp((isnan(tmp) | isinf(tmp)) & stack(:,:,i,index) > 0.9) = saturation_value;
        tmp((isnan(tmp) | isinf(tmp)) & stack(:,:,i,index) < 0.5) = 0.0;
         
        imgOut(:,:,i) = tmp;
    end
end
 
%forcing to double type for allowing to be used in some MATLAB functions
imgOut = double(imgOut);

end