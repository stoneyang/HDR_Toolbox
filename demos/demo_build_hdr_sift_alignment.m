%
%       HDR Toolbox demo build radiance map:
%	   1) Read a stack of LDR images
%	   2) Read exposure values from the EXIF
%	   3) Estimate the Camera Response Function (CRF)
%      4) Align image using VLFeat''s SIFT
%	   5) Build the radiance map using the stack and stack_exposure
%	   6) Save the radiance map in .hdr format
%	   7) Show the tone mapped version of the radiance map
%
%       Author: Francesco Banterle
%       Copyright 2013-15 (c)
%

clear all;

name_folder = 'stack_alignment';
format = 'jpg';

disp('1) Read a stack of LDR images');
stack = ReadLDRStack(name_folder, format);

disp('2) Read exposure values from the EXIF');
stack_exposure = ReadLDRStackInfo(name_folder, format);

disp('3) Align the stack using VLFeat''s SIFT');
stackOut = SiftAlignment(stack, 1);

disp('4) Estimage the CRF');
[lin_fun, ~] = ComputeCRF(stack, stack_exposure);  
h = figure(1);
set(h, 'Name', 'The Camera Response Function (CRF)');
plot(lin_fun);

disp('5) Build the radiance map using the stack and stack_exposure');
imgHDR = BuildHDR(stackOut, stack_exposure, 'LUT', lin_fun, 'Gauss', 'linear');

disp('6) Save the radiance map in the .hdr format');
hdrimwrite(imgHDR, 'hdr_image_sift_alignment.hdr');

disp('7) Show the tone mapped version of the radiance map');
h = figure(2);
set(h, 'Name', 'Tone mapped version of the built HDR image');
GammaTMO(ReinhardBilTMO(imgHDR), 2.2, 0, 1);

disp('Note that the image needs to be cropped due to alignment');