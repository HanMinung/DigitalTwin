function [BPFO, BPFI, BSF] = faultFreq()

    D1 = 37.05; 
    D2 = 24.95; 
    N_B = 13;   
    Beta = 6.05;            % contact angle
    P_D = (D1 + D2) / 2; 
    B_D = (D1 - D2) / 2;
    fr = 500 / 60; 
    
    BPFO    = fr * N_B / 2 *(1 - (B_D / P_D) * cosd(Beta));
    BPFI    = fr * N_B / 2 *(1 + (B_D / P_D) * cosd(Beta));
    BSF     = fr * (P_D / B_D) * (1 - ((B_D / P_D)* cosd(Beta))^2);

end