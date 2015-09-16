database = 6;
% subbase = 6;

% for subbase = 1:1:6
    [fileDir, ~, ~] = filenameCombinator(database);

    fileList = dir(fileDir);
    nFiles = length(fileList);

    for idx = 1:nFiles 
        [~,~] = GFTMO(database, idx); 
        close all; clc; 
        [~,~] = GFTMO(database, idx, 'Yang'); 
        close all; clc;
        [~,~] = GFTMO(database, idx, 'Ash'); 
        close all; clc;
        [~,~] = GFTMO(database, idx, 'Drg'); 
        close all; clc;
    end
% end