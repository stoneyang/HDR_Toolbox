clear all;
close all;
clc;

% read HDR image as input -- single input temporarily
% hdrImg = hdrimread('E:\yangfan\DATA\HDR\INPUT\trafficLight.hdr');
hdrImg = double(imread('E:\yangfan\DATA\WDR_raw_tif\INPUT\xueyuanroad_1920x1112_GR.tif'));
I = hdrImg / 255;

% smoothing the salt and pepper in each channels
medianRadius = 3;
medianPatch = [medianRadius medianRadius];
medianImg(:,:,1) = medfilt2(I(:,:,1), medianPatch);
medianImg(:,:,2) = medfilt2(I(:,:,2), medianPatch);
medianImg(:,:,3) = medfilt2(I(:,:,3), medianPatch);

snrHdrMedian = SNR(I, medianImg);

% smoothing with edge preserving
r = 1;
eps = 0.000001^2;
detail = 2;

q_size = size(I);
q = zeros(q_size);
q(:,:,1) = guidedfilter(I(:,:,1), medianImg(:,:,1), r, eps);
q(:,:,2) = guidedfilter(I(:,:,2), medianImg(:,:,2), r, eps);
q(:,:,3) = guidedfilter(I(:,:,3), medianImg(:,:,3), r, eps);
enhancedImg = (I - q) * detail + q;

snrHdrGuided = SNR(I, enhancedImg);

% tone mapping using various tone mapping algorithms with corresponding
% gamma correction afterwards
dragoB = 0.95;
dragoLdMax = 100;
dragoGamma = 2.2;
dragoSlope = 4.5;
dragoStart = 0.018;

dragoImg = DragoTMO(enhancedImg, dragoLdMax, dragoB);
dragoImg = GammaDrago(dragoImg, dragoGamma, dragoSlope, dragoStart);

snrHdrDrago = SNR(hdrImg, dragoImg);

% smoothing the grain noise
avgRadius = 5;
avgPatch = [avgRadius avgRadius];
avgH = fspecial('average', avgPatch);
avgImg = imfilter(dragoImg, avgH);

snrHdrAvg = SNR(hdrImg, avgImg);

% sharpening the tone mapped results
gaussianH = padarray(2, [2 2]) - fspecial('gaussian', [5 5], 2);
sharpened = imfilter(avgImg, gaussianH);

snrHdrSharpen = SNR(hdrImg, sharpened);

% displaying the results
figure; imshow(hdrImg);
figure; imshow(medianImg);
figure; imshow(dragoImg);
figure; imshow(avgImg);
figure; imshow(sharpened);

disp(strcat('SNR after enhancement using guided filter: ', num2str(snrHdrGuided), 'dB'));
disp(strcat('SNR after smoothing the pepper noise: ', num2str(snrHdrMedian), 'dB'));
disp(strcat('SNR after tone mapping using Drago''s algorithm: ', num2str(snrHdrDrago), 'dB'));
disp(strcat('SNR after smoothing the tone mapped image: ', num2str(snrHdrAvg), 'dB'));
disp(strcat('SNR after sharpening: ', num2str(snrHdrSharpen), 'dB'));

% write the results
% imwrite(dragoImg, 'E:\yangfan\data\hdr\output\trafficLight_GuidedFilteredSmoothingDrago.png');
% imwrite(sharpened, 'E:\yangfan\data\hdr\output\trafficLight_GuidedFilteredSmoothingDrago_sharpened.png');

% compute the SNRs of each stage

% organize the results in the form of html