% Used for lab3

function xfeature = getTimefeatures(data)

    Width = width(data);
    N = length(data);

    xfeature = table();

    for Idx = 1 : Width

        newRow = table();

        newRow.mean = mean(data(:,Idx));
        newRow.std = std(data(:,Idx));
        newRow.rms = sqrt(sum(power(data(:,Idx),2))/N);
        newRow.sra = power((sum(sqrt(abs(data(:,Idx))))/N),2);
        newRow.aav = sum(abs(data(:,Idx)))/N;
        newRow.energy = sum(data(:,Idx).^2);
        newRow.peak = max(data(:,Idx));
        newRow.ppv = peak2peak(data(:,Idx));
        newRow.if = newRow.peak/newRow.aav;
        newRow.sf = newRow.rms/newRow.aav;
        newRow.cf = max(abs(data(:,Idx)))/newRow.rms;
        newRow.mf = newRow.peak/newRow.sra;
        newRow.sk = skewness(data(:,Idx));
        newRow.kt = kurtosis(data(:,Idx));

        % To append
        xfeature = [xfeature; newRow];
        
    end

end