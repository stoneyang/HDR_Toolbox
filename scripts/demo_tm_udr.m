testUDR

name = 'trafficLight';

TMOs = {'Ashikhmin', 'Chiu', 'Drago', 'Durand', 'exponential',...
    'Fairchild', 'Fattal', 'Ferwerda', 'KimKautzConsistent', 'Krawczyk',...
    'Lischinski', 'logarithmic', 'normalize', 'Pattanaik', 'Raman',...
    'Reinhard', 'ReinhardBil', 'ReinhardDevlin', 'Schlick', 'TumblinRushmeier',...
    'VanHateren', 'WardGlobal', 'WardHistAdj'};, %'Banterle', 'Yee'

records = cell(numel(TMOs), numel(name));

outputPrefix = 'e:\yangfan\data\hdr\output\';
outputLumSuffix = '_lum.tif';
outputLumMapSuffix = '_lum_map.tif';

outputHDRSuffix = '_hdr.tif';
outputGammaSuffix = '_gamma.tif';
outputTMSuffix = '.png';

recordsFile = strcat(outputPrefix, 'trafficLight_records.csv');

% calculation line
tic
outputLum = strcat(outputPrefix, name, outputLumSuffix);
outputLumMap = strcat(outputPrefix, name, outputLumMapSuffix);
outputHDR = strcat(outputPrefix, name, outputHDRSuffix);
outputGamma = strcat(outputPrefix, name, outputGammaSuffix);
        
[Lmax, Lmin, dynRg, dynRgLog] = dynamic_range(a, outputLum, outputLumMap);
    
records(1,1) = {name};
records(2,1) = {Lmax};
records(3,1) = {Lmin};
records(4,1) = {dynRg};
records(5,1) = {dynRgLog};
    
img = hdr_condition(a, outputHDR, outputGamma);

for j = 1 : numel(TMOs)
    TMO = TMOs{j};
    outputTMFile = strcat(outputPrefix, name, '_', TMO, outputTMSuffix);
        
    disp(strcat({'Start tone mapping of '}, name, {' using '}, TMO, {' ...'}));
    [~, execTime] = tone_mapping(img, TMO, outputTMFile);
        
    records(j+5,1) = {execTime};    
end

% export data
ds = cell2dataset(records);
export(ds, 'file' ,recordsFile, 'delimiter', ',');

disp('==============Summary of Batch experiments of TMOs================');
disp(' ');
disp(strcat({'Overall execution time: '}, num2str(toc), {' seconds'}));
disp(strcat({'Number of HDR inputs: '}, num2str(numel(name))));
disp(strcat({'Number of TMOs: '}, num2str(numel(TMOs))));
disp('================End of Batch experiments of TMOs==================');