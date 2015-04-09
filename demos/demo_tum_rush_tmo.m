%
%       HDR Toolbox demo:
%	   1) Load "Bottles_Small.pfm" HDR image
%	   2) Show the image in linear mode
%	   3) Show the image in gamma mode
%	   4) Tone map and show the image using Tumblin & Rushmeier's TMO 
%	   5) Save the tone mapped image as PNG
%
%       Author: Fan Yang
%       Copyright April 2015 (c)
%
%

disp('1) Load the image Bottles_Small.pfm using hdrimread');
img = hdrimread('Bottles_Small.hdr');

disp('2) Show the image Bottles_Small.pfm in linear mode using imshow');
h = figure(1);
set(h,'Name','HDR visualization in Linear mode at F-stop 0');
GammaTMO(img, 1.0, 0, 1);

disp('3) Show the image Bottles_Small.hdr applying gamma');
h = figure(2);
set(h,'Name','HDR visualization with gamma correction, 2.2, at F-stop 0');
GammaTMO(img, 2.2, 0, 1);

disp('4) Show the image Bottles_Small.hdr applying Tumblin & Rushmeier''s Tmo');
h = figure(3);
set(h,'Name','Tone mapped image using TumblinRushmeierTMO');
imgTMO = TumblinRushmeierTMO(img);
imshow(imgTMO);

disp('5) Save the tone mapped image as a PNG.');
imwrite(imgTMO, 'Bottles_Small_TumblinRushmeierTMO.png');