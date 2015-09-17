function I_out = color_imaging(inputFile, bAWB, AWB, catType, bTM, TM)
    [path, name, ext] = fileparts(inputFile);
    if strcmp(ext, '.hdr')
        I = hdrimread(inputFile);
    else
        I = imread(inputFile);
    end
    
    if bAWB
        disp('use AWB');    
        I_AWB = AWB_switch(I, catType, AWB);
    end
    
    if bTM
        disp('use TM');
        I_tm = TM_switch(I_AWB, TM);
    end
    
    I_out = I_tm;
    outputFile = strcat(path, name, '_', AWB, '_', catType, '_', TM, '.png');
    imwrite(I_out, outputFile);
end
