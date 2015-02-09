function imgOut = CombineLDR(stack, stack_exposure, lin_type, lin_fun, weight_type, bLogDomain, bMeanWeight, bRobertson)
%
%       imgOut = CombineLDR(stack, stack_exposure, lin_type, lin_fun, weight_type, bLogDomain, bMeanWeight, bRobertson)
%
%
%        Input:
%           -stack: a sequence of LDR images with values in [0,1].
%           -stack_exposure: a sequence of exposure values associated to
%                            images in the stack
%           -lin_type: the linearization function:
%                      - 'linear': images are already linear
%                      - 'gamma2.2': gamma function 2.2 is used for
%                                    linearisation;
%                      - 'sRGB': images are encoded using sRGB
%                      - 'tabledDeb97': a tabled RGB function is used for
%                                       linearisation passed as input in
%                                       lin_fun using Debevec and Malik
%                                       method
%           -lin_fun: extra parameters for linearization, see lin_type
%           -weight_type:
%               - 'all':   weight is set to 1
%               - 'hat':   hat function 1-(2x-1)^12
%               - 'Deb97': Debevec and Malik 97 weight function
%               - 'Gauss': a Gaussian function as weight function.
%                          This function produces good results when some 
%                          under-exposed or over-exposed images are present
%                          in the stack.
%           -bLogDomain, if it is set to 1 it enables the merge of the exposure
%	        the logarithmic domain, otherwise in the linear domain. This value
%           is set to 1 by default.
%           -bMeanWeight:
%           -bRobertson: if it is set to 1 it enables the Robertson's
%           modification for assembling exposures for reducing noise.
%
%        Output:
%           -imgOut: the combined HDR image from the stack
%
%     Copyright (C) 2011-15 Francesco Banterle
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

if(~exist('bLogDomain', 'var'))
    bLogDomain = 1;
end

if(~exist('bMeanWeight', 'var'))
    bMeanWeight = 1;
end

if(~exist('bRobertson', 'var'))
    bRobertson = 0;
end

[r, c, col, n] = size(stack);

imgOut    = zeros(r, c, col, 'single');
totWeight = zeros(r, c, col, 'single');

for i=1:n
    weight   = [];
    tmpStack = stack(:,:,:,i);

    if(isa(tmpStack, 'single'))
        tmpStack = ClampImg(tmpStack, 0.0, 1.0);
    end
    
    if(isa(tmpStack, 'double'))
        tmpStack = ClampImg(single(tmpStack), 0.0, 1.0);
    end

    if(isa(tmpStack, 'uint8'))
        tmpStack = single(tmpStack) / 255.0;
    end

    if(isa(stack, 'uint16'))
        tmpStack = single(tmpStack) / 65535.0;
    end

    weight  = WeightFunction(tmpStack, weight_type, bMeanWeight);

    switch lin_type
        case 'gamma2.2'
            tmpStack = tmpStack.^2.2;

        case 'sRGB'
            tmpStack = ConvertRGBtosRGB(tmpStack, 1);
        
        case 'tabledDeb97'
            tmpStack = tabledFunction(round(tmpStack * 255), lin_fun);            
        otherwise
    end
   
    %Calculation of the weight function    
    t = stack_exposure(i);
    
    if(t > 0.0)
        if(bRobertson)
            imgOut = imgOut + (weight .* tmpStack) * t;
            totWeight = totWeight + weight * t * t;
        else
            if(bLogDomain)
                imgOut = imgOut + weight .* (log(tmpStack) - log(t));
                totWeight = totWeight + weight;                
            else
                imgOut = imgOut + (weight .* tmpStack) / t;
                totWeight = totWeight + weight;
            end
        end
    end
end

if(~isempty(find(totWeight <= 0.0)))
    disp('WARNING: the stack has saturated pixels in all the stack, please use ''Gauss'' weighting function to mitigate artifacts.');
end

imgOut = (imgOut ./ totWeight);

if(~bRobertson && bLogDomain)
    imgOut = exp(imgOut);
end

imgOut = RemoveSpecials(imgOut);

end
