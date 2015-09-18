function I_out = color_imaging(inputFile, bSmooth, bGF, bTM, TM, bDN, bAWB, AWB, catType)
    [path, name, ext] = fileparts(inputFile);
    output = strcat(path, name);
    outputExt = '.png';
    
    if strcmp(ext, '.hdr')
        I = hdrimread(inputFile);
    else
        I = im2double(imread(inputFile));
    end
    I = I ./ 255;
    I_size = size(I);
    
    if bSmooth
        disp('use smoothing');

        medianRadius = 5;
        medianPatch = [medianRadius medianRadius];
        medianImg = zeros(I_size);
        
        medianImg(:,:,1) = medfilt2(I(:,:,1), medianPatch);
        medianImg(:,:,2) = medfilt2(I(:,:,2), medianPatch);
        medianImg(:,:,3) = medfilt2(I(:,:,3), medianPatch);
        
        output = strcat(output, '_median_r', num2str(medianRadius));
    end
    
    if bGF
        disp('use guided filter');
        
        GF_r = 1;
        GF_eps = 0.000001^2;
        GF_detail = 2;
        
        q_size = size(I);
        q = zeros(q_size);
        
        q(:,:,1) = guidedfilter(I(:,:,1), medianImg(:,:,1), GF_r, GF_eps);
        q(:,:,2) = guidedfilter(I(:,:,2), medianImg(:,:,2), GF_r, GF_eps);
        q(:,:,3) = guidedfilter(I(:,:,3), medianImg(:,:,3), GF_r, GF_eps);
        
        enhancedImg = (I - q) * GF_detail + q;
        
        output = strcat(output, '_GF_r', num2str(GF_r), '_eps', num2str(GF_eps), '_detail', num2str(GF_detail));
    end
    
    if bTM
        disp('use TM');
        I_tm = TM_switch(enhancedImg, TM);
        output = strcat(output, '_', TM);
    end   
    
    if bDN
        disp('use DN');
        
        sigma = 5;
        profile = 'lc';
        
        [~, I_est_r] = BM3D(enhancedImg(:,:,1), I_tm(:,:,1), sigma, profile, 0);
        [~, I_est_g] = BM3D(enhancedImg(:,:,2), I_tm(:,:,2), sigma, profile, 0);
        [~, I_est_b] = BM3D(enhancedImg(:,:,3), I_tm(:,:,3), sigma, profile, 0);
        
        I_est = cat(3, I_est_r, I_est_g, I_est_b);
        
        output = strcat(output, '_DN_sigma', num2str(sigma), '_', num2str(profile));
        outputFile = strcat(output, outputExt);
        imwrite(I_est, outputFile);
    end
    
    if bAWB
        disp('use AWB');
        input = outputFile;
        [~, name, ext] = fileparts(input);
        outputFile2 = [name '_' AWB ext];
        I_AWB = AWB_switch(I_est, AWB, catType, input, outputFile2);
        output = strcat(output, '_', AWB, '_', catType);
    end
        
    I_out = I_AWB;
    output = strcat(output, outputExt);
    imwrite(I_out, output);
end
