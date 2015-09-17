function I_AWB = AWB_switch(I, catType, AWB)
    switch catType
    	case 'vonKries'
        	disp('apply von Kries CAT');
        case 'bradford'
            disp('apply bradford CAT');
        case 'sharp'
            disp('apply sharp CAT');
        case 'CMCCAT2000'
            disp('apply CMCCAT2000 CAT');
        case 'CAT02'
            disp('apply CAT02 CAT');
        case 'XYZ'
            disp('apply XYZ CAT');
        otherwise
            disp('no CAT''s fed!');
    end
        
    switch AWB
        case 'grayWorld'
            disp('apply gray world method');
            maxIter = 1;
            I_AWB = gray_world(I, catType, maxIter);
        case 'simplestAWB'
            disp('apply simplest AWB method');
            satLvl = 0.01;
            I_AWB = simplest_AWB(I, satLvl);
        case 'robustAWB'
            disp('apply robust AWB method');
        case 'sensorCorrelation'
            disp('apply sensor correlation method');
        otherwise
            disp('no correct method''s fed!');
    end
end