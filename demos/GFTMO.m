function [tmImg, I_est] = GFTMO(tmo, sigma, profile, patch_size, filename, medianRadius, GF_r, GF_eps, GF_detail)
%GFTMO is a function to integrate the different modules in the workflow of
% high dynamic range imaging. 
%
% Input variables:
%  tmo         : tone mapping operator selected
%  sigma       : sigma in BM3D
%  profile     : profile in BM3D
%  patch_size  : patch size in dehaze algorithm
%  filename    : input file name
%  medianRadius: radius of window of median filter
%  GF_r        : r in guided filter
%  GF_eps      : eps in guided filter
%  GF_detail   : detail in guided filter
% 
% Output variables;
%  tmImg       : tone mapped image
%  I_est       : image after noise removal
%
% Fan Yang 06/24/2015

% reading input
disp('Reading input');
inputDir = 'E:\yangfan\DATA\HDR\INPUT\';
outputDir = 'E:\yangfan\DATA\HDR\OUTPUT\AD\';
inputSuffix = '.hdr';

% inputDir = 'E:\yangfan\DATA\HDR_IBL\';
% outputDir = inputDir;
% inputSuffix = '.hdr';

% inputDir = 'E:\yangfan\DATA\WDR_raw_tif\INPUT\calibrated\';
% outputDir = 'E:\yangfan\DATA\WDR_raw_tif\OUTPUT\';
% inputSuffix = '.tif';

outputSuffix = '.png';

if (~exist('filename', 'file'))
    % % read HDR image as input -- single input temporarily
    % filename = 'trafficLight';
    % filename = 'trafficLight_flare_removed'
    % filename = 'cathedral_sub';
    filename = 'camp_daylight_10am_sanfran_barn_006_d';
    % filename = 'office';
    % filename = 'belgium';
    % filename = 'bigFogMap';
    % filename = 'cathedral';
    % filename = 'BigI_big';
    % filename = 'AtriumMorning';
    % filename = 'AtriumNight';
    
    % filename = 'HDR_110_Tunnel\HDR_110_Tunnel_Ref_ROI_1833_811_1610_972';
    % filename = 'HDR_Free_City_Night_Lights\HDR_Free_City_Night_Lights_Ref_1010_370_2060_1530';
    % filename = 'Church_HarvestLobby\Church_HarvestLobby_0_0_1500_1500';
    % filename = 'Church_HarvestLobby\Church_HarvestLobby_1500_0_1500_1500';
    
    % filename = '1_1920x1112_GB_R95_G9_B97';
    % filename = '2_1920x1112_GB_R95_G9_B97';
    % filename = '3_1920x1112_GB_R95_G9_B97';
    % filename = '4_1920x1112_GB_R085_G075_B1';
    % filename = '10_1920x1112_GB_R09_G08_B09';
    % filename = '11_1920x1112_GB_R075_G06_B08';
    % filename = '12_1920x1112_GB_R1_G07_B1';
    % filename = '13_1920x1112_GB_R08_G085_B085';
    % filename = '17_1920x1112_GB_R1_G07_B1';
    % filename = 'jingyihotel_1920x1112_GR_R95_G9_B97';
    % filename = 'linear_raw_1936x1112_GR_2015-04-14-15-21-00-559_GR_R95_G9_B97';
    % filename = 'linear_raw_1936x1112_GR_2015-04-14-15-28-35-184_R95_G9_B97';
    % filename = 'linear_raw_1936x1112_GR_2015-04-14-16-00-12-715_R09_G06_B1';
    % filename = 'linear_raw_1936x1112_GR_2015-04-14-18-43-13-375_R065_G05_B1';
    % filename = 'shiningparking_1920x1112_GR_R95_G9_B97';
    % filename = 'xueyuanroad_1920x1112_GR_R95_G9_B97';
end

if strcmp(inputSuffix, '.tif')
    hdrImg = im2double(imread(strcat(inputDir, filename, inputSuffix)));
else
    hdrImg = hdrimread(strcat(inputDir, filename, inputSuffix));
end
I = hdrImg / 255;

% smoothing the salt and pepper in each channels
disp('Smoothing the salt and pepper in each channels');
if (~exist('median', 'var'))
    medianRadius = 5;
end
medianPatch = [medianRadius medianRadius];
medianImg(:,:,1) = medfilt2(I(:,:,1), medianPatch);
medianImg(:,:,2) = medfilt2(I(:,:,2), medianPatch);
medianImg(:,:,3) = medfilt2(I(:,:,3), medianPatch);

% smoothing with edge preserving
disp('Smoothing with edge preserving');
if (~exist('GF_r', 'var'))
    GF_r = 1;
end

if (~exist('GF_eps', 'var'))
    GF_eps = 0.000001^2;
end

if (~exist('GF_detail', 'var'))
    GF_detail = 2;
end

q_size = size(I);
q = zeros(q_size);
q(:,:,1) = guidedfilter(I(:,:,1), medianImg(:,:,1), GF_r, GF_eps);
q(:,:,2) = guidedfilter(I(:,:,2), medianImg(:,:,2), GF_r, GF_eps);
q(:,:,3) = guidedfilter(I(:,:,3), medianImg(:,:,3), GF_r, GF_eps);
enhancedImg = (I - q) * GF_detail + q;

% tone mapping using various tone mapping algorithms with corresponding
% gamma correction afterwards
disp('Tone mapping');
if (~exist('dragoB', 'var'))
    dragoB = 1.2;
end

if (~exist('dragoLdMax', 'var'))
    dragoLdMax = 100;
end

if (~exist('dragoGamma', 'var'))
    dragoGamma = 2.4;
end

if (~exist('dragoSlope', 'var'))
    dragoSlope = 4.5;
end

if (~exist('dragoStart', 'var'))
    dragoStart = 0.018;
end

if (~exist('tmo', 'var'))
    tmo = 'AshDrg';
end

switch tmo
    case 'AshDrg'
        [tmImg, ~] = AshikhminedDragoTMO(enhancedImg, dragoLdMax, dragoB);
        gammaImg = GammaDrago(tmImg, dragoGamma, dragoSlope, dragoStart);
    case 'Drg'
        tmImg = DragoTMO(enhancedImg, dragoLdMax, dragoB);
        gammaImg = GammaDrago(tmImg, dragoGamma, dragoSlope, dragoStart);
    case 'Ash'
        [tmImg, ~] = AshikhminTMO(enhancedImg);
        gammaImg = GammaTMO(tmImg, 2.4, 0, 0);
    case 'Yang'
        [tmImg, ~] = YangTMO(enhancedImg);
        gammaImg = GammaTMO(tmImg, 2.4, 0, 0);
    otherwise
        disp('Unexpected tmo');
end

figure; imshow(gammaImg); title('Tone mapping');

% noise removal using BM3D
disp('Noise removal');
if (~exist('sigma', 'var'))
    sigma = 20;
end

if (~exist('profile', 'var'))
    profile = 'lc';
end

[~, I_est_r] = BM3D(enhancedImg(:,:,1), gammaImg(:,:,1), sigma, profile);
[~, I_est_g] = BM3D(enhancedImg(:,:,2), gammaImg(:,:,2), sigma, profile);
[~, I_est_b] = BM3D(enhancedImg(:,:,3), gammaImg(:,:,3), sigma, profile);

I_est = cat(3, I_est_r, I_est_g, I_est_b);

figure; imshow(I_est); title('Noise removal');

% haze removal
disp('Haze removal');
if (~exist('patch_size', 'var'))
    patch_size = 3;
end

[~, dehaze, J, T_est, T, A] = removeHaze(I_est, patch_size);

figure; imshow(dehaze); title('Haze removal');
figure; imshow(J); title('Haze removal -- dark channel prior');
figure; imshow(T_est); title('Haze removal -- transmission');
figure; imshow(T); title('Haze removal -- Laplacian');
figure; imshow(A); title('Haze removal -- estimation of atmospheric light');

% write the results
disp('Saving results');
gammaFilename = strcat(outputDir, filename, '_median', '_r', num2str(medianRadius), ...
    '_GF_r', num2str(GF_r), '_eps', num2str(GF_eps), '_detail', num2str(GF_detail), ...
    '_', tmo, '_dragoB', num2str(dragoB), '_LdMax', num2str(dragoLdMax), ...
    '_Gamma', num2str(dragoGamma), '_Start', num2str(dragoStart), '_Slope', num2str(dragoSlope));
estFilename = strcat(gammaFilename, '_BM3D', '_sigma', num2str(sigma));
dehazeFilename = strcat(estFilename, '_dehaze', '_patch', num2str(patch_size)); 
darkChannelFilename = strcat(estFilename, '_dehaze', '_dark');
transmissionFilename = strcat(estFilename, '_dehaze', '_trans');
laplacianFilename = strcat(estFilename, '_dehaze', '_laplacian');
atmosphericLightFilename = strcat(estFilename, '_dehaze', '_atmosphericLight');

gammaFilename = strcat(gammaFilename, outputSuffix);
estFilename = strcat(estFilename, outputSuffix);
dehazeFilename = strcat(dehazeFilename, outputSuffix);
darkChannelFilename = strcat(darkChannelFilename, outputSuffix);
transmissionFilename = strcat(transmissionFilename, outputSuffix);
laplacianFilename = strcat(laplacianFilename, outputSuffix);
atmosphericLightFilename = strcat(atmosphericLightFilename, outputSuffix);

imwrite(gammaImg, gammaFilename);
imwrite(I_est, estFilename);
imwrite(dehaze, dehazeFilename);
imwrite(J, darkChannelFilename);
imwrite(T_est, transmissionFilename);
imwrite(T, laplacianFilename);
imwrite(A, atmosphericLightFilename);

% organize the results in the form of html
end