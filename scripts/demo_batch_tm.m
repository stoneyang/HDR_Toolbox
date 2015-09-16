clear all
clc
clf

disp('====================Batch experiments of TMOs=====================');
disp('= 1) Load filenames of input files and output files;             =');
disp('= 2) Calculate the dynamic range of input files;                 =');
disp('= 3) Run the TMOs sequentially;                                  =');

names = {'Bottles_Small', 'CS_Warwick', 'groveC', 'groveD', 'memorial',...
    'camp_daylight_10am_sanfran', 'camp_daylight_10am_sanfran_02',...
    'camp_daylight_10am_sanfran_barn', 'camp_daylight_10am_sanfran_barn_006',...
    'camp_daylight_10am_sanfran_barn_006_c', 'camp_daylight_10am_sanfran_barn_006_d',...
    'camp_daylight_10am_sanfran_barn_007b', 'camp_daylight_10am_sanfran_barn_007c',...
    'camp_daylight_10am_sanfran_barn_007d', 'camp_daylight_10am_sanfran_barn_007e',...
    'camp_daylight_12pm_singapore', 'camp_daylight_12pm_singapore_4checkers_lamp',...
    'camp_daylight_17', 'camp_night_full_glare_indoor',...
    'camp_night_jeep_head_on', 'camp_night_jeep_head_on2',...
    'nave', 'Oxford_Church', 'rosette', 'vinesunset'};, %'NotreDame1'

TMOs = {'Ashikhmin', 'Banterle', 'Chiu', 'Drago', 'Durand', 'exponential',...
    'Fairchild', 'Fattal', 'Ferwerda', 'KimKautzConsistent', 'Krawczyk',...
    'Lischinski', 'logarithmic', 'normalize', 'Pattanaik', 'Raman',...
    'Reinhard', 'ReinhardBil', 'ReinhardDevlin', 'Schlick', 'TumblinRushmeier',...
    'VanHateren', 'WardGlobal', 'WardHistAdj', 'Yee'};

records = cell(numel(TMOs), numel(names));

% names assembly line
inputPrefix = 'e:\yangfan\data\hdr\input\';
inputSuffix = '.hdr';

outputPrefix = 'e:\yangfan\data\hdr\output\';
outputLumSuffix = '_lum.tif';
outputLumMapSuffix = '_lum_map.tif';

outputHDRSuffix = '_hdr.tif';
outputGammaSuffix = '_gamma.tif';
outputTMSuffix = '.png';

recordsFile = strcat(outputPrefix, 'records.csv');

% calculation line
tic
for i = 1 : numel(names)
    name = names{i};
    inputFile = strcat(inputPrefix, name, inputSuffix);
    outputLum = strcat(outputPrefix, name, outputLumSuffix);
    outputLumMap = strcat(outputPrefix, name, outputLumMapSuffix);
    outputHDR = strcat(outputPrefix, name, outputHDRSuffix);
    outputGamma = strcat(outputPrefix, name, outputGammaSuffix);
    
    inputImg = hdrimread(inputFile);
    [Lmax, Lmin, dynRg, dynRgLog] = dynamic_range(inputImg, outputLum, outputLumMap);
    
    records(1,i) = {name};
    records(2,i) = {Lmax};
    records(3,i) = {Lmin};
    records(4,i) = {dynRg};
    records(5,i) = {dynRgLog};
    
    img = hdr_condition(inputImg, outputHDR, outputGamma);

    for j = 1 : numel(TMOs)
        TMO = TMOs{j};
        outputTMFile = strcat(outputPrefix, name, '_', TMO, outputTMSuffix);
        
        disp(strcat({'Start tone mapping of '}, name, {' using '}, TMO, {' ...'}));
        [~, execTime] = tone_mapping(img, TMO, outputTMFile);
        
        records(j+5,i) = {execTime};
    end
end
avgTime = toc / numel(names);

% export data
ds = cell2dataset(records);
export(ds, 'file' ,recordsFile, 'delimiter', ',');

disp('==============Summary of Batch experiments of TMOs================');
disp(' ');
disp(strcat({'Overall execution time: '}, num2str(toc), {' seconds'}));
disp(strcat({'Number of HDR inputs: '}, num2str(numel(names))));
disp(strcat({'Number of TMOs: '}, num2str(numel(TMOs))));
disp(strcat({'Average execution time of each outer for loop: '}, num2str(avgTime), {' seconds'}));
disp('================End of Batch experiments of TMOs==================');