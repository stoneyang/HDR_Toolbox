clear all
clf

disp('====================Batch experiments of TMOs=====================');
disp('= 1) Load filenames of input files and output files;             =');
disp('= 2) Calculate the dynamic range of input files;                 =');
disp('= 3) Run the TMOs sequentially;                                  =');

names = {'CS_Warwick', 'Oxford_Church'};
TMOs = {'Ashikhmin', 'Banterle', 'Chiu', 'Drago', 'Durand', 'exponential',...
    'Fairchild', 'Fattal', 'Ferwerda', 'KimKautzConsistent', 'Krawczyk',...
    'Lischinski', 'logarithmic', 'normalize', 'Pattanaik', 'Raman',...
    'Reinhard', 'ReinhardBil', 'ReinhardDevlin', 'Schlick', 'TumblinRushmeier',...
    'VanHateren', 'WardGlobal', 'WardHistAdj', 'Yee'};

inputPrefix = 'e:\yangfan\data\hdr\input\';
inputSuffix = '.hdr';

outputPrefix = 'e:\yangfan\data\hdr\output\';
outputLumSuffix = '_lum.tif';
outputLumMapSuffix = '_lum_map.tif';

outputHDRSuffix = '_hdr.tif';
outputGammaSuffix = '_gamma.tif';
outputTMSuffix = '.png';

tic
for i = 1 : numel(names)
    name = names{i};
    inputFile = strcat(inputPrefix, name, inputSuffix);
    outputLum = strcat(outputPrefix, name, outputLumSuffix);
    outputLumMap = strcat(outputPrefix, name, outputLumMapSuffix);
    outputHDR = strcat(outputPrefix, name, outputHDRSuffix);
    outputGamma = strcat(outputPrefix, name, outputGammaSuffix);
        
    [dynRg, dynRgLog] = dynamic_range(inputFile, outputLum, outputLumMap);

    tic
    for j = 1 : numel(TMOs)
        TMO = TMOs{j};
        outputTMFile = strcat(outputPrefix, name, '_', TMO, outputTMSuffix);
        [imgTMO, execTime] = tone_mapping(inputFile, TMO, outputHDR, outputGamma, outputTMFile);
    end
end
avgTime = toc / numel(names);

disp('==============Summary of Batch experiments of TMOs================');
disp(' ');
disp(strcat({'Overall execution time: '}, num2str(toc), {' seconds'}));
disp(strcat({'Number of HDR inputs: '}, num2str(numel(names))));
disp(strcat({'Number of TMOs: '}, num2str(numel(TMOs))));
disp(strcat({'Average execution time of each outer for loop: '}, num2str(avgTime), {' seconds'}));
disp('================End of Batch experiments of TMOs==================');