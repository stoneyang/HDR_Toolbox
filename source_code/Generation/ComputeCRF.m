function [lin_fun, max_lin_fun] = ComputeCRF(stack, stack_exposure, nSamples, bNormalize, smoothing_term)
%
%       lin_fun = ComputeCRF(stack, stack_exposure, nSamples, bNormalize)
%
%       This function computes camera response function using Debevec and
%       Malik method.
%
%        Input:
%           -stack: a stack of LDR images.
%           -stack_exposure: an array containg the exposure time of each
%           image. Time is expressed in second (s).
%           -nSamples: number of samples for computing the CRF.
%           -bNormalize: if 1 it enables function normalization.
%           -smoothing_term: a smoothing term for solving the linear
%           system.
%
%        Output:
%           -lin_fun: the inverse CRF.
%           -max_lin_fun: maximum value of the inverse CRF.
%
%     Copyright (C) 2014-15  Francesco Banterle
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

if(~exist('nSamples', 'var'))
    nSamples = 100;
end

if(nSamples < 1)
    nSamples = 100;
end

if(~exist('bNormalize', 'var'))
    bNormalize = 1;
end

if(isempty(stack))
    error('ComputeCRF: a stack cannot be empty!');
end

if(isempty(stack_exposure))
    error('ComputeCRF: a stack_exposure cannot be empty!');
end

if(~exist('smoothing_term', 'var'))
    smoothing_term = 20;
end

if(size(stack, 4) ~= length(stack_exposure))
    error('stack and stack_exposure have different number of exposures');
end

if(isa(stack, 'uint8'))
    stack = single(stack) / 255.0;
end

if(isa(stack, 'uint16'))
    stack = single(stack) / 65535.0;
end

if(isa(stack, 'double') | isa(stack, 'single'))
    max_val_stack = max(stack(:));
    if(max_val_stack > 1.0) 
        stack = stack / max_val_stack;
    end
end

col = size(stack, 3);

%Weight function
W = WeightFunction(0:(1 / 255):1, 'Deb97');

%stack sub-sampling
stack_hist = ComputeLDRStackHistogram(stack);
stack_samples = GrossbergSampling(stack_hist, nSamples);

%recovering the CRF
lin_fun = zeros(256, col);
log_stack_exposure = log(stack_exposure);

max_lin_fun = zeros(col, 1);

for i=1:col
    g = gsolve(stack_samples(:,:,i), log_stack_exposure, smoothing_term, W);
    g = exp(g);
    
    lin_fun(:,i) = g;
    max_lin_fun(i) = max(g);
    
    if(bNormalize)
        lin_fun(:,i) = lin_fun(:,i) / max_lin_fun(i);
    end
end

end