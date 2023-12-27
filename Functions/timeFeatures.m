% Version 1 : getfeature and return the table

% function xfeature = timeFeatures(input, name) 
%     
%     x =  input;
%     xfeature = table('RowNames', name);
%     N = length(x);
% 
%     xfeature.mean = mean(x);
%     xfeature.std = std(x);
%     xfeature.rms = sqrt(sum(power(x,2))/N);
%     xfeature.sra = power((sum(sqrt(abs(x)))/N),2);
%     xfeature.aav = sum(abs(x))/N;
%     xfeature.energy = sum(x.^2);
%     xfeature.peak = max(x);
%     xfeature.ppv = peak2peak(x);
%     xfeature.if = xfeature.peak/xfeature.aav;
%     xfeature.sf = xfeature.rms/xfeature.aav;
%     xfeature.cf = max(abs(x))/xfeature.rms;
%     xfeature.mf = xfeature.peak/xfeature.sra;
%     xfeature.sk = skewness(x);
%     xfeature.kt = kurtosis(x);
%    
% 
% end

% Version 2 : getfeature and return the table with no name;

function xfeature = timeFeatures(input) 
    
    x =  input;
    N = length(x);
    xfeature = table();

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
