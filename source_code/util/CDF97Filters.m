function [analysisLow, analysisHigh, SynthLow, SynthHigh] = CDF97Filters()
%
%
%       [analysisLow, analysisHigh, SynthLow, SynthHigh] = CDF97Filters()
%
%
%       Input:
%
%       Output:
%           -analysisLow: CDF 9/7 analysis low-pass filter
%           -analysisHigh: CDF 9/7 analysis high-pass filter
%           -SynthLow: CDF 9/7 synthesis low-pass filter
%           -SynthHigh: CDF 9/7 synthesis high-pass filter
%
%     Copyright (C) 2013-14  Francesco Banterle
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

analysisLow     = [0.026748757411, -0.016864118443, -0.078223266529, 0.266864118443, 0.602949018236, 0.266864118443, -0.078223266529, -0.016864118443, 0.026748757411];
analysisHigh    = [0, 0.091271763114, -0.057543526229, -0.591271763114, 1.11508705, -0.591271763114, -0.057543526229, 0.091271763114, 0];
SynthLow        = [0, -0.091271763114, -0.057543526229, 0.591271763114, 1.11508705 , 0.591271763114, -0.057543526229, -0.091271763114,0];
SynthHigh       = [0.026748757411, 0.016864118443, -0.078223266529, -0.266864118443, 0.602949018236, -0.266864118443, -0.078223266529 , 0.016864118443, 0.026748757411];

end