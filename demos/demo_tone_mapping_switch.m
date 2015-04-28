function [img, imgTMO] = demo_tone_mapping_switch(filename, TMO, savefilename)
%
%
%      [img, imgTMO] = demo_tone_mapping_switch(filename, TMO, savefilename)
%
%
%       Input:
%           -filename:     filename of input image
%           -TMO:          tone mapping method
%           -savefilename: filename of output image
%       Output:
%           -img:      input HDR image
%           -imgTMO:   image after tone mapping
%
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
    disp('1) Load the image using hdrimread');
    img = hdrimread(filename);
    
    disp('2) Show the image in linear mode using imshow');
    h = figure(1);
    set(h,'Name','HDR visualization in Linear mode at F-stop 0');
    GammaTMO(img, 1.0, 0, 1);
    
    disp('3) Show the image applying gamma');
    h = figure(2);
    set(h,'Name','HDR visualization with gamma correction, 2.2, at F-stop 0');
    GammaTMO(img, 2.2, 0, 1);
    
    disp('4) Show the results applying TMO');
    h = figure(3);
    set(h,'Name','Tone mapped image using TMO');
    imgTMO = tone_mapping_switch(img, TMO);
    GammaTMO(imgTMO, 2.2, 0, 1);
    
    disp('5) Save the tone mapped image as a PNG.');
    imwrite(GammaTMO(imgTMO, 2.2, 0, 0), savefilename);
end

function imgTMO = tone_mapping_switch(img, TMO)
    switch(TMO)
        case 'Ashikhmin'
            imgTMO = AshikhminTMO(img);
        case 'Banterle'
            imgTMO = BanterleTMO(img);
        case 'Chiu'
            imgTMO = ChiuTMO(img);
        case 'Drago'
            imgTMO = DragoTMO(img);
        case 'Durand'
            imgTMO = DurandTMO(img);
        case 'exponential'
            imgTMO = ExponentialTMO(img);
        case 'Fairchild'
            imgTMO = KuangTMO(img);
        case 'Fattal'
            imgTMO = FattalTMO(img);
        case 'Ferwerda'
            imgTMO = FerwerdaTMO(img);
        case 'KimKautzConsistent'
            imgTMO = KimKautzConsistentTMO(img);
        case 'Krawczyk'
            imgTMO = KrawczykTMO(img);
        case 'Lischinski'
            imgTMO = LischinskiTMO(img);
        case 'logarithmic'
            imgTMO = LogarithmicTMO(img);
        case 'normalize'
            imgTMO = NormalizeTMO(img);
        case 'Pattanaik'
            imgTMO = PattanaikVisualStaticTMO(img);
        case 'Raman'
            imgTMO = RamanTMO(img);
        case 'Reinhard'
            imgTMO = ReinhardTMO(img);
        case 'ReinhardBil'
            imgTMO = ReinhardBilTMO(img);
        case 'ReinhardDevlin'
            imgTMO = ReinhardDevlinTMO(img);  
        case 'Schlick'
            imgTMO = SchlickTMO(img);
        case 'TumblinRushmeier'
            imgTMO = TumblinRushmeierTMO(img);
        case 'VanHateren'
            imgTMO = VanHaterenTMO(img);
        case 'WardGlobal'
            imgTMO = WardGlobalTMO(img);
        case 'WardHistAdj'
            imgTMO = WardHistAdjTMO(img);
        case 'Yee'
            imgTMO = YeeTMO(img);
    end
end