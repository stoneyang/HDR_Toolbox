close all;clear all;

fName = 'trafficLight';
inputDir = 'E:\yangfan\DATA\HDR\INPUT\';
outputDir = 'E:\yangfan\DATA\HDR\OUTPUT\';
hdrSuffix = '.hdr';

I = hdrimread(strcat(inputDir, fName, hdrSuffix))/255;
p = I;

% imgTMO= DragoTMO(I); 
% figure; 
% imgTMO = GammaDrago(imgTMO);
% imshow(imgTMO);
% imwrite(imgTMO, 'E:\yangfan\DATA\HDR_IBL\HDR_110_Tunnel\HDR_110_Tunnel_Ref_Drago.png');

r = 3;
eps = 0.000001^2;
detail = 2;

q = zeros(size(I));
tic;
q(:, :, 1) = guidedfilter(I(:, :, 1), p(:, :, 1), r, eps);
q(:, :, 2) = guidedfilter(I(:, :, 2), p(:, :, 2), r, eps);
q(:, :, 3) = guidedfilter(I(:, :, 3), p(:, :, 3), r, eps);
toc;

% q_sub = zeros(size(I));
% s = 4;
% tic;
% q_sub(:, :, 1) = fastguidedfilter(I(:, :, 1), p(:, :, 1), r, eps, s);
% q_sub(:, :, 2) = fastguidedfilter(I(:, :, 2), p(:, :, 2), r, eps, s);
% q_sub(:, :, 3) = fastguidedfilter(I(:, :, 3), p(:, :, 3), r, eps, s);
% toc;

I_enhanced = (I - q) * detail + q;
% I_enhanced_sub = (I - q) * detail + q_sub;

drago_b = 0.95;
drago_Ld_max = 100;

imgTMO_enhanced = DragoTMO(I_enhanced, drago_Ld_max, drago_b); 
imgTMO_enhanced = GammaDrago(imgTMO_enhanced);
figure; 
imshow(imgTMO_enhanced);
imwrite(imgTMO_enhanced, strcat(outputDir, fName, '_GuidedFilteredDrago', '_r', num2str(r), '_eps', num2str(eps), '_detail', num2str(detail), '_b', num2str(drago_b), '_drago_Ld_max', num2str(drago_Ld_max), '.png'));

H = padarray(2, [2 2]) - fspecial('gaussian', [5 5], 2);
sharpened = imfilter(imgTMO_enhanced, H);
figure;
imshow(sharpened);
imwrite(sharpened, strcat(outputDir, fName, '_GuidedFilteredDrago', '_r', num2str(r), '_eps', num2str(eps), '_detail', num2str(detail), '_b', num2str(drago_b), '_drago_Ld_max', num2str(drago_Ld_max), '_sharpened', '.png'));

% imgTMO_sub= DragoTMO(I_enhanced_sub); 
% figure; 
% imgTMO_sub = GammaDrago(imgTMO_sub);
% imshow(imgTMO_sub);

% figure();
% imshow([I, q, q_sub, I_enhanced, I_enhanced_sub]);%, [0, 1]);
