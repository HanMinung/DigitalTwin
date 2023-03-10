function xfeature = timeFeatures(input) 
    
    x =  input;
    xfeature = table;
    N = length(x);
    
    xfeature.mean = mean(x);
    xfeature.std = std(x);
    xfeature.rms = sqrt(sum(power(x,2))/N);
    xfeature.sra = power((sum(sqrt(abs(x)))/N),2);
    xfeature.aav = sum(abs(x))/N;
    xfeature.energy = sum(x.^2);
    xfeature.peak = max(x);
    xfeature.ppv = peak2peak(x);
    xfeature.if = xfeature.peak/xfeature.aav;
    xfeature.sf = xfeature.rms/xfeature.aav;
    xfeature.cf = max(abs(x))/xfeature.rms;
    xfeature.mf = xfeature.peak/xfeature.sra;
    xfeature.sk = skewness(x);
    xfeature.kt = kurtosis(x);
   

end
