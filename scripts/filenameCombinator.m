function [inputDir, outputDir, inputSuffix] = filenameCombinator(database, subbase)

if(~exist('subbase', 'var'))
    subbase = 1;
end

switch database
    case 1
        inputDir = 'E:\yangfan\DATA\HDR\INPUT\';
        outputDir = 'E:\yangfan\DATA\HDR\OUTPUT\AD\';
        inputSuffix = '.hdr';
    case 2
        inputDir = 'E:\yangfan\DATA\HDR_IBL\';
        inputDir = filenameCombinator2(subbase, inputDir);
        outputDir = strcat(inputDir, 'OUTPUT\');
        inputSuffix = '.hdr';
    case 3
        inputDir = 'E:\yangfan\DATA\WDR_raw_tif\INPUT\calibrated\';
        outputDir = 'E:\yangfan\DATA\WDR_raw_tif\OUTPUT\';
        inputSuffix = '.tif';
    case 4
        inputDir = 'E:\yangfan\DATA\HDRSID\Turkey\';
        outputDir = strcat(inputDir, 'OUTPUT\');
        inputSuffix = '.hdr';
    case 5
        inputDir = 'E:\yangfan\DATA\hdrStanfordData\';
        outputDir = strcat(inputDir, 'OUTPUT\');
        inputSuffix = '.hdr';
    case 6
        inputDir = 'E:\yangfan\LITERATURE\Imaging&Vision\HDRI\ReinhardBook\CDROM\hdr\';
        outputDir = strcat(inputDir, 'OUTPUT\');
        inputSuffix = '.hdr';
    case 7
        inputDir = 'E:\yangfan\DATA\WDR_raw_tif\INPUT\ºìÂÌµÆraw\20150701_day\calibrated\';
        outputDir = 'E:\yangfan\DATA\WDR_raw_tif\OUTPUT\';
        inputSuffix = '.tif';
    case 8
        inputDir = 'E:\yangfan\DATA\WDR_raw_tif\INPUT\ºìÂÌµÆraw\20150708_night\calibrated\';
        outputDir = 'E:\yangfan\DATA\WDR_raw_tif\OUTPUT\';
        inputSuffix = '.tif';        
    otherwise
        disp('Inproper database number!');
end

end

function inputDir = filenameCombinator2(subbase, inputDir)

switch subbase
    case 1
        inputDir = strcat(inputDir, 'Church_HarvestLobby\');
    case 2
        inputDir = strcat(inputDir, 'HDR_110_Tunnel\');
    case 3
        inputDir = strcat(inputDir, 'HDR_Free_City_Night_Lights\');
    case 4
        inputDir = strcat(inputDir, 'Lake_CraterLake03_sm\');
    case 5
        inputDir = strcat(inputDir, 'MeadowTrail03_sm\');
    case 6
        inputDir = strcat(inputDir, 'Stonewall_Ref\');
    otherwise
        disp('Inproper sub-database number!');
end

end