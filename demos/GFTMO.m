function [tmImg, I_est] = GFTMO(tmo, filename, medianRadius, GF_r, GF_eps, GF_detail, sigma, profile)

inputDir = 'E:\yangfan\DATA\HDR\INPUT\';
outputDir = 'E:\yangfan\DATA\HDR\OUTPUT\AD\';
inputSuffix = '.hdr';
outputSuffix = '.png';

if (~exist('filename', 'file'))
    % % read HDR image as input -- single input temporarily
    filename = 'trafficLight';
    % filename = 'trafficLight_flare_removed'
    % filename = 'cathedral_sub';
    % filename = 'camp_daylight_10am_sanfran_barn_006_d';
    % filename = 'E:\yangfan\DATA\HDR_IBL\HDR_110_Tunnel\HDR_110_Tunnel_Ref_ROI_1833_811_1610_972';
    % filename = double(imread('E:\yangfan\DATA\WDR_raw_tif\INPUT\xueyuanroad_1920x1112_GR.tif'));
    % filename = 'office';
    % filename = 'belgium';
    % filename = 'bigFogMap';
    % filename = 'cathedral';
    % filename = 'BigI_big';
    % filename = 'AtriumMorning';
    % filename = 'AtriumNight';
end
hdrImg = hdrimread(strcat(inputDir, filename, inputSuffix));
I = hdrImg / 255;

% smoothing the salt and pepper in each channels
if (~exist('median', 'var'))
    medianRadius = 5;
end
medianPatch = [medianRadius medianRadius];
medianImg(:,:,1) = medfilt2(I(:,:,1), medianPatch);
medianImg(:,:,2) = medfilt2(I(:,:,2), medianPatch);
medianImg(:,:,3) = medfilt2(I(:,:,3), medianPatch);

% smoothing with edge preserving
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
end

% noise removal using BM3D
if (~exist('sigma', 'var'))
    sigma = 5;
end

if (~exist('profile', 'var'))
    profile = 'lc';
end

[~, I_est_r] = BM3D(enhancedImg(:,:,1), gammaImg(:,:,1), sigma, profile);
[~, I_est_g] = BM3D(enhancedImg(:,:,2), gammaImg(:,:,2), sigma, profile);
[~, I_est_b] = BM3D(enhancedImg(:,:,3), gammaImg(:,:,3), sigma, profile);

I_est = cat(3, I_est_r, I_est_g, I_est_b);

% displaying the results
figure; imshow(gammaImg);
figure; imshow(I_est);

% write the results
gammaFilename = strcat(outputDir, filename, '_median', '_r', num2str(medianRadius), '_GF_r', num2str(GF_r), '_eps', num2str(GF_eps), '_detail', num2str(GF_detail), tmo, 'drago_b', num2str(dragoB), '_LdMax', num2str(dragoLdMax), '_Gamma', num2str(dragoGamma), outputSuffix);
estFilename = strcat(outputDir, filename, '_median', '_r', num2str(medianRadius), '_GF_r', num2str(GF_r), '_eps', num2str(GF_eps), '_detail', num2str(GF_detail), tmo, 'drago_b', num2str(dragoB), '_LdMax', num2str(dragoLdMax), '_Gamma', num2str(dragoGamma), '_BM3D', '_sigma', num2str(sigma), outputSuffix);
imwrite(gammaImg, gammaFilename);
imwrite(I_est, estFilename);

% organize the results in the form of html
end