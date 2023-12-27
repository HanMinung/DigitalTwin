function freqFeatures = getFreqfeatures(data, Fs)

    L = length(data);
    freqFeatures = table();

    for Idx = 1 : width(data)
        
        newRow = table();
        [freq, mag] = getFFT(data(:,Idx),L,Fs);
        N = length(mag);

        newRow.fc = sum(mag)/N;
        newRow.rmsf = sqrt(sum(mag.^2)/N);
        newRow.rvf = sqrt(sum((mag-newRow.fc).^2)/N);

        % To append
        freqFeatures = [freqFeatures; newRow];
        
    end

end