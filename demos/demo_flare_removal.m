clear all;
close all;
clc;
clf;

hdrImg = hdrimread('e:\yangfan\data\hdr\input\trafficLight.hdr');
[Lmax, Lmin, dynRg, dynRgLog] = dynamic_range(hdrImg, 'e:\yangfan\data\hdr\output\trafficLight_lum.tif', 'e:\yangfan\data\hdr\output\trafficLight_lum_map.tif');
[imgOut, imgGlare, PSF] = RemovingGlare(hdrImg);

hdrimwrite(imgOut, 'e:\yangfan\data\hdr\input\trafficLight_flare_removed.hdr');
hdrimwrite(imgGlare, 'e:\yangfan\data\hdr\input\trafficLight_glare.hdr');