clear all;
close all;
clc;

hdrImg = hdrimread('e:\yangfan\data\hdr\input\cathedral.hdr');
[imgOut, imgGlare, PSF] = RemovingGlare(hdrImg);

hdrimwrite(imgOut, 'e:\yangfan\data\hdr\input\cathedral_flare_removed.hdr');
hdrimwrite(imgGlare, 'e:\yangfan\data\hdr\input\cathedral_glare.hdr');