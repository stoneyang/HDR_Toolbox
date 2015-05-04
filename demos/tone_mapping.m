function [imgTMO, execTime] = tone_mapping(inputImg, TMO, outputTM)
%
%
%      [imgTMO, execTime] = tone_mapping(inputImg, TMO, outputTM)
%
%
%       Input:
%           -inputImg:     input HDR image
%           -TMO:          tone mapping method
%           -outputTM:     filename of output image
%       Output:
%           -imgTMO:       image after tone mapping
%           -execTime:     execution time of TMO
% 
%     Copyright (C) 2015  Fan Yang
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
    disp('Show the results applying TMO');
    h = figure(3);
    set(h,'Name','Tone mapped image using TMO');
    disp(TMO);
    [imgTMO, execTime] = tone_mapping_switch(inputImg, TMO);
    %% TODO: numbers of TMOs DO NOT need gamma correction or 2.2 value!
    GammaTMO(imgTMO, 2.2, 0, 1);
    %%
    disp(strcat({'Execution time of '}, TMO, {': '}, num2str(execTime), {' seconds'}));
    
    disp('5) Save the tone mapped image as a PNG.');
    imwrite(GammaTMO(imgTMO, 2.2, 0, 0), outputTM);
end

function [imgTMO, execTime] = tone_mapping_switch(img, TMO)
    switch(TMO)
        case 'Ashikhmin'
            tic
            imgTMO = AshikhminTMO(img);
            execTime = toc;
        case 'Banterle'
            tic
            imgTMO = BanterleTMO(img);
            execTime = toc;
        case 'Chiu'
            tic
            imgTMO = ChiuTMO(img);
            execTime = toc;
        case 'Drago'
            tic
            imgTMO = DragoTMO(img);
            execTime = toc;
        case 'Durand'
            tic
            imgTMO = DurandTMO(img);
            execTime = toc;
        case 'exponential'
            tic
            imgTMO = ExponentialTMO(img);
            execTime = toc;
        case 'Fairchild'
            tic
            imgTMO = KuangTMO(img);
            execTime = toc;
        case 'Fattal'
            tic
            imgTMO = FattalTMO(img);
            execTime = toc;
        case 'Ferwerda'
            tic
            imgTMO = FerwerdaTMO(img);
            execTime = toc;
        case 'KimKautzConsistent'
            tic
            imgTMO = KimKautzConsistentTMO(img);
            execTime = toc;
        case 'Krawczyk'
            tic
            imgTMO = KrawczykTMO(img);
            execTime = toc;
        case 'Lischinski'
            tic
            imgTMO = LischinskiTMO(img);
            execTime = toc;
        case 'logarithmic'
            tic
            imgTMO = LogarithmicTMO(img);
            execTime = toc;
        case 'normalize'
            tic
            imgTMO = NormalizeTMO(img);
            execTime = toc;
        case 'Pattanaik'
            tic
            imgTMO = PattanaikVisualAdaptationStaticTMO(img);
            execTime = toc;
        case 'Raman'
            tic
            imgTMO = RamanTMO(img);
            execTime = toc;
        case 'Reinhard'
            tic
            imgTMO = ReinhardTMO(img);
            execTime = toc;
        case 'ReinhardBil'
            tic
            imgTMO = ReinhardBilTMO(img);
            execTime = toc;
        case 'ReinhardDevlin'
            tic
            imgTMO = ReinhardDevlinTMO(img);  
            execTime = toc;
        case 'Schlick'
            tic
            imgTMO = SchlickTMO(img);
            execTime = toc;
        case 'TumblinRushmeier'
            tic
            imgTMO = TumblinRushmeierTMO(img);
            execTime = toc;
        case 'VanHateren'
            tic
            imgTMO = VanHaterenTMO(img);
            execTime = toc;
        case 'WardGlobal'
            tic
            imgTMO = WardGlobalTMO(img);
            execTime = toc;
        case 'WardHistAdj'
            tic
            imgTMO = WardHistAdjTMO(img);
            execTime = toc;
        case 'Yee'
            tic
            imgTMO = YeeTMO(img);
            execTime = toc;
    end
end