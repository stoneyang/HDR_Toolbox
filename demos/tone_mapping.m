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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% TODO: numbers of TMOs DO NOT need gamma correction or 2.2 value!
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % GammaTMO(imgTMO, 2.2, 0, 1);

    disp(strcat({'Execution time of '}, TMO, {': '}, num2str(execTime), {' seconds'}));
    
    disp('Save the tone mapped image as a PNG.');
    imwrite(imgTMO, outputTM);
end

function [imgTMO, execTime] = tone_mapping_switch(img, TMO)
    switch(TMO)
        case 'Ashikhmin' % Ashikhmin2002
            tic
            imgTMO = AshikhminTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'Banterle'  % Banterle2012
            tic
            imgTMO = BanterleTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'Chiu'      % Chiu1993
            tic
            imgTMO = ChiuTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'Drago'     % Drago2003
            tic
            imgTMO = DragoTMO(img);
            execTime = toc;
            imgTMO = GammaDrago(imgTMO); 
            imshow(imgTMO);
        case 'Durand'    % Durand2002
            tic
            imgTMO = DurandTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'exponential'
            tic
            imgTMO = ExponentialTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'Fairchild'  % Kuang2007
            tic
            imgTMO = KuangTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'Fattal'     % Fattal2002
            tic
            imgTMO = FattalTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'Ferwerda'   % Ferwerda1996
            tic
            imgTMO = FerwerdaTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'KimKautzConsistent'  % Kim2008
            tic
            imgTMO = KimKautzConsistentTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'Krawczyk'    % Krawczyk2005b & Krawczyk2005c
            tic
            imgTMO = KrawczykTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'Lischinski'  % Lischinski2006
            tic
            imgTMO = LischinskiTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'logarithmic'
            tic
            imgTMO = LogarithmicTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'normalize'
            tic
            imgTMO = NormalizeTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'Pattanaik'  % Pattanaik2000
            tic
            imgTMO = PattanaikVisualAdaptationStaticTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'Raman'  % Raman2009
            tic
            imgTMO = RamanTMO(img);
            execTime = toc;
            %imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'Reinhard' % Reinhard2002 & Reinhard2003
            tic
            imgTMO = ReinhardTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'ReinhardBil'
            tic
            imgTMO = ReinhardBilTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'ReinhardDevlin' % Reinhard2005
            tic
            imgTMO = ReinhardDevlinTMO(img);  
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 1.6, 0, 1);  % as suggested in the original paper
        case 'Schlick'  % Schlick1994
            tic
            imgTMO = SchlickTMO(img, 'nonuniform', 1/0.005, 8, 1, 0); % k = 0 usually the best
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'TumblinRushmeier' % TumblinRushmeier1993
            tic
            imgTMO = TumblinRushmeierTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'VanHateren'  % VanHateren2006
            tic
            imgTMO = VanHaterenTMO(img);
            execTime = toc;
            %imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'WardGlobal'  % Ward1994
            tic
            imgTMO = WardGlobalTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'WardHistAdj' % Ward1997 & Larson1997
            tic
            imgTMO = WardHistAdjTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
        case 'Yee' % Yee2003
            tic
            imgTMO = YeeTMO(img);
            execTime = toc;
            imgTMO = GammaTMO(imgTMO, 2.2, 0, 1);
    end
end