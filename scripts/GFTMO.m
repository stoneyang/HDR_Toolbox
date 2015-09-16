function [tmImg, I_est] = GFTMO(database, fileIdx, tmo, subbase, sigma, profile, bShow, bDehaze, patch_size, medianRadius, GF_r, GF_eps, GF_detail)
%GFTMO is a function to integrate the different modules in the workflow of
% high dynamic range imaging. 
%
% Input variables:
%  database    : database that contains the input HDR image
%  subbase     : sub-database that contains in the specific database
%  fileIdx     : index of input file among the specified database
%  tmo         : tone mapping operator selected
%  sigma       : sigma in BM3D
%  profile     : profile in BM3D
%  bShow       : whether show intermediate results: 1 - Yes; 0 - No
%  bDehaze     : whether use dehaze algothm: 1 - Yes; 0 - No
%  patch_size  : patch size in dehaze algorithm
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

%% reading input
disp('Reading input');
if (~exist('database', 'var'))
    database = 1;
end

if (~exist('bShow', 'var'))
    bShow = 0;
end

if (exist('subbase', 'var'))
    [inputDir, outputDir, inputSuffix] = filenameCombinator(database, subbase);
else
    [inputDir, outputDir, inputSuffix] = filenameCombinator(database);
end

outputSuffix = '.png';

if (~exist('fileIdx', 'var'))
    fileIdx = 42;
end

fileDir = strcat(inputDir, '*', inputSuffix);
filename = fileSelect(fileDir, fileIdx);

if strcmp(inputSuffix, '.tif')
    hdrImg = im2double(imread(strcat(inputDir, filename, inputSuffix)));
else
    hdrImg = hdrimread(strcat(inputDir, filename, inputSuffix));
end

if (strcmp(inputDir, 'E:\yangfan\DATA\HDRSID\Turkey\'))
    if (~exist('scale', 'var'))
        scale = 0.5;
        hdrImg = imresize(hdrImg, scale);
    end    
end

I = hdrImg ./ 255;

%% smoothing the salt and pepper in each channels
disp('Smoothing the salt and pepper in each channels');
if (~exist('median', 'var'))
    medianRadius = 5;
end
medianPatch = [medianRadius medianRadius];
medianImg(:,:,1) = medfilt2(I(:,:,1), medianPatch);
medianImg(:,:,2) = medfilt2(I(:,:,2), medianPatch);
medianImg(:,:,3) = medfilt2(I(:,:,3), medianPatch);

%% smoothing with edge preserving
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

%% tone mapping using various tone mapping algorithms with corresponding
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
        gammaImg = GammaTMO(tmImg, dragoGamma, 0, 0);
    case 'Yang'
        [tmImg, ~] = YangTMO(enhancedImg);
        gammaImg = GammaTMO(tmImg, dragoGamma, 0, 0);
    otherwise
        disp('Unexpected tmo');
end

if (bShow)
    figure; imshow(gammaImg); title('Tone mapping');
end

%% noise removal using BM3D
disp('Noise removal');
if (~exist('sigma', 'var'))
    sigma = 5;
end

if (~exist('profile', 'var'))
    profile = 'lc';
end

[~, I_est_r] = BM3D(enhancedImg(:,:,1), gammaImg(:,:,1), sigma, profile, bShow);
[~, I_est_g] = BM3D(enhancedImg(:,:,2), gammaImg(:,:,2), sigma, profile, bShow);
[~, I_est_b] = BM3D(enhancedImg(:,:,3), gammaImg(:,:,3), sigma, profile, bShow);

I_est = cat(3, I_est_r, I_est_g, I_est_b);

if (bShow)
    figure; imshow(I_est); title('Noise removal');
end

%% haze removal
if (~exist('bDehaze', 'var'))
    bDehaze = 0;
end

if (bDehaze)
    disp('Haze removal');
    if (~exist('patch_size', 'var'))
        patch_size = 3;
    end

    [~, dehaze, J, T_est, T, A] = removeHaze(I_est, patch_size);

    if (bShow)
        figure; imshow(dehaze); title('Haze removal');
        figure; imshow(J); title('Haze removal -- dark channel prior');
        figure; imshow(T_est); title('Haze removal -- transmission');
        figure; imshow(T); title('Haze removal -- Laplacian');
        figure; imshow(A); title('Haze removal -- estimation of atmospheric light');
    end
end

%% write the results
disp('Saving results');
gammaFilename = strcat(outputDir, filename, '_median', '_r', num2str(medianRadius), ...
    '_GF_r', num2str(GF_r), '_eps', num2str(GF_eps), '_detail', num2str(GF_detail), ...
    '_', tmo, '_dragoB', num2str(dragoB), '_LdMax', num2str(dragoLdMax), ...
    '_Gamma', num2str(dragoGamma), '_Start', num2str(dragoStart), '_Slope', num2str(dragoSlope));
estFilename = strcat(gammaFilename, '_BM3D', '_sigma', num2str(sigma));

if (bDehaze)
    dehazeFilename = strcat(estFilename, '_dehaze', '_patch', num2str(patch_size)); 
    darkChannelFilename = strcat(estFilename, '_dehaze', '_dark');
    transmissionFilename = strcat(estFilename, '_dehaze', '_trans');
    laplacianFilename = strcat(estFilename, '_dehaze', '_laplacian');
    atmosphericLightFilename = strcat(estFilename, '_dehaze', '_atmosphericLight');
end

gammaFilename = strcat(gammaFilename, outputSuffix);
estFilename = strcat(estFilename, outputSuffix);

if (bDehaze)
    dehazeFilename = strcat(dehazeFilename, outputSuffix);
    darkChannelFilename = strcat(darkChannelFilename, outputSuffix);
    transmissionFilename = strcat(transmissionFilename, outputSuffix);
    laplacianFilename = strcat(laplacianFilename, outputSuffix);
    atmosphericLightFilename = strcat(atmosphericLightFilename, outputSuffix);
end

imwrite(gammaImg, gammaFilename);
imwrite(I_est, estFilename);

if (bDehaze)
    imwrite(dehaze, dehazeFilename);
    imwrite(J, darkChannelFilename);
    imwrite(T_est, transmissionFilename);
    imwrite(T, laplacianFilename);
    imwrite(A, atmosphericLightFilename);
end

%% organize the results in the form of html
end