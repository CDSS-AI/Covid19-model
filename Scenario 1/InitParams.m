function pm = InitParams()
    pm.NB_VARIANTS = 2; 
    pm.NB_AGE_GROUPS = 5;
    pm.Sinit = 500; 
    pm.I1init = 0; 
    pm.I2init = 0; 
    pm.Rinit = 0; 
    
    pm.beta = 0;
    pm.delta_1 = 0.05;
    pm.delta_2 = 0.5; %death of variant 1
    pm.delta_3 = 0.07;
    pm.delta_4 = 0.04; %death of variant 2
    pm.lambda = 0.5;
    pm.phi = 0.7;
    pm.phi_2 = 0.9;
    pm.theta = 0.001;
end 