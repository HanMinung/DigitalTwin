% function freqfeature = freqFeatures(P, name)
% 
%     freqfeature = table('RowNames', name);
%     N = length(P);
% 
%     freqfeature.fc = sum(P)/N;
%     freqfeature.rmsf = sqrt(sum(P.^2)/N);
%     freqfeature.rvf = sqrt(sum((P-freqfeature.fc).^2)/N);
% 
% end

% function freqfeature = freqFeatures(P)
% 
%     freqfeature = table();
%     N = length(P);
% 
%     freqfeature.fc = sum(P)/N;
%     freqfeature.rmsf = sqrt(sum(P.^2)/N);
%     freqfeature.rvf = sqrt(sum((P-freqfeature.fc).^2)/N);
% 
% end


% Version 3 : 자체적으로 FFT를 취하고 그에 따라 feature를 뽑아주는 함수
function freqFeature = freqFeatures(data, L, Fs)

    [f, P] = getFFT(data, L, Fs);

    N = length(P);
    
    freqFeature = table();

    freqFeature.fc = sum(P)/N;
    freqFeature.rmsf = sqrt(sum(P.^2)/N);
    freqFeature.rvf = sqrt(sum((P - freqFeature.fc).^2)/N);

end