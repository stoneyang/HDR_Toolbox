%
%       HDR Toolbox demo Fusion:
%	   1) Apply Fusion Operator by Raman and Chaudhuri at images in stack folder
%	   2) Show the image without gamma encoding, because it is working in
%	   gamma space
%	   3) Save the tone mapped image as PNG
%	   4) Apply Fusion Operator by Mertne and Chaudhuri at images in stack folder
%	   5) Show the image without gamma encoding, because it is working in
%	   gamma space
%	   6) Save the tone mapped image as PNG
%       Author: Francesco Banterle
%       Copyright June 2012 (c)
%
%

disp('1) Apply Fusion Operator by Raman and Chaudhuri at images in stack folder');
imgTMO = RamanTMO([],'stack','jpg');

disp('2) Show the image after fusion, note that there is no need of gamma correction!');
figure(1);
GammaTMO(imgTMO, 1.0, 0, 1);

disp('3) Save the tone mapped image as a PNG.');
hdrimwrite(imgTMO, 'venice_calle_raman_TMO.png');

disp('4) Apply Fusion Operator by Raman and Chaudhuri at images in stack folder');
imgTMO = MertensTMO([],'stack','jpg');

disp('5) Show the image after fusion, note that there is no need of gamma correction!');
figure(2);
GammaTMO(imgTMO, 1.0, 0, 1);

disp('6) Save the tone mapped image as a PNG.');
hdrimwrite(imgTMO, 'venice_calle_mertens_TMO.png');
