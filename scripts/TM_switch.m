function I_out = TM_switch(I_in, TM)
	switch TM
        case 'AshDrg'
            disp('apply Ashikhmined Drago TMO');
            I_tm = AshikhminedDragoTMO(I_in);
            I_gamma = GammaDrago(I_tm);
            I_out = I_gamma;
        case 'Ash'
            disp('apply Ashikhmin TMO');
        case 'Ban'
            disp('apply Banterle TMO');
        case 'Bru'
            disp('apply Bruce Expo Blend TMO');
        case 'Chiu'
            disp('apply Chiu TMO');
        case 'Drg'
            disp('apply Drago TMO');
        case 'Durand'
            disp('apply Durand TMO');
        case 'exp'
            disp('apply exponential TMO');
        case 'Fattal'
            disp('apply Fattal TMO');
        case 'Fwd'
            disp('apply Ferwerda TMO');
        case 'gamma'
            disp('apply Gamma TMO');
        case 'KK'
            disp('apply Kim & Kautz TMO');
        case 'Kck'
            disp('apply Krawczyk TMO');
        case 'Kuang'
            disp('apply Kuang TMO');
        case 'Lck'
            disp('apply Lischinski TMO');
        case 'log'
            disp('apply logTMO');
        case 'mtn'
            disp('apply Merten TMO');
        case 'norm'
            disp('apply normalization');
        case 'Patt'
            disp('apply Pattanaik TMO');
        case 'Ram'
            disp('apply Raman TMO');
        case 'ReBil'
            disp('apply Reinhard Bilateral TMO');
        case 'ReDev'
            disp('apply Reinhard Devlin TMO');
        case 'Re'
            disp('apply Reinhard TMO');
        case 'Sch'
            disp('apply Schlick TMO');
        case 'TR'
            disp('apply Tumblin Rushmeier TMO');
        case 'Van'
            disp('apply Van Harteren TMO');
        case 'Ward'
            disp('apply Ward global TMO');
        case 'WHA'
            disp('apply Ward histogram adjustment TMO');
        case 'Yee'
            disp('apply Yee TMO');
	end
end