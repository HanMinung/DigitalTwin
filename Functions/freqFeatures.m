function freqfeature = freqFeatures(P)

    freqfeature = table;
    N = length(P);

    freqfeature.fc = sum(P)/N;
    freqfeature.rmsf = sqrt(sum(P.^2)/N);
    freqfeature.rvf = sqrt(sum((P-freqfeature.fc).^2)/N);

end