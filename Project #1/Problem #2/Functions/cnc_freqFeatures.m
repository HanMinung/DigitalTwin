function output = cnc_freqFeatures(input, col_name)

    x=input;
    
    xfeature = table();
    L=length(x);
    Y = fft(x);
    P2 = abs(Y/L);
    P = P2(1:L/2+1);
    P(2:end-1) = 2*P(2:end-1);
    
    xfeature.fc = mean(P);
    xfeature.rmsf = sqrt(mean(P.^2));
    xfeature.rvf = sqrt(mean((P - xfeature.fc).^2));

%     xfeature.length = length(x);
    

    output = xfeature;
    output.Properties.VariableNames = strcat(col_name, '_', output.Properties.VariableNames);
end