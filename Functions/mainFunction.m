% function output = mainFunction(numSegments, overlapRatio, inputFiles, varNames, outputPrefixes)
function output = mainFunction(numSegments, overlapRatio, inputFiles, varNames, outputPrefixes)

    % Load input data
    data = cell(1, length(inputFiles));

    for i = 1:length(inputFiles)
        tempData = load(inputFiles{i}, varNames{i});
        data{i} = tempData.(varNames{i});
    end
    
    % Process input data with sliding window and timeFeatures function
    output = processInputData(data, numSegments, overlapRatio, outputPrefixes);
    
end

function output = processInputData(data, numStments, overlapRatio, outputPrefixes)

    % Initialize output table
    output = table();
    
    % Process each input data with sliding window and timeFeatures function
    for dataIdx = 1:length(data)
        totalData = length(data{dataIdx});
        window_size = ceil(totalData / (numStments - overlapRatio * (numStments - 1)));
        stepSize = ceil(window_size * (1 - overlapRatio));
        
        % Compute the number of windows based on num_segments
        num_windows = numStments;
        
        for i = 1:num_windows
            
            start_idx = 1 + (i - 1) * stepSize;
            end_idx = min(start_idx + window_size - 1, totalData); 
            segment_data = data{dataIdx}(start_idx:end_idx);
            segment_name = sprintf('%s_%d', outputPrefixes{dataIdx}, i);
            segment_features = timeFeatures(segment_data);
            segment_features.Properties.RowNames = {segment_name};
            output = [output; segment_features];
        end
    end
    
end

function output = timeFeatures(input)

    x = input; 

    % Initialize xfeature without RowNames
    xfeature = table();

    % mean and STD
    xfeature.mean=mean(x);
    xfeature.std=std(x);

    xfeature.rms=rms(x);
    my_rms= sqrt(mean(x.^2));
    
    xfeature.sra= (mean(sqrt(abs(x))))^2;
    
    xfeature.aav=mean(abs(x));

    xfeature.energy=sum(x.^2);
    
    xfeature.peak= max(abs(x));
    
    xfeature.ppv = peak2peak(x);
        
    xfeature.if = xfeature.peak/xfeature.aav;
    
    xfeature.sf= xfeature.rms/xfeature.aav;
    
    xfeature.cf= xfeature.peak / xfeature.rms;
      
    xfeature.mf=xfeature.peak/xfeature.sra;
    
    xfeature.sk=skewness(x);
    xsk = mean(((x - xfeature.mean)/xfeature.std).^3);
     
    xfeature.kt=kurtosis(x);
    xkt = mean(((x - xfeature.mean)/xfeature.std).^4);
       
    % length of data : for frequency features
    L = length(x);
    Y = fft(x);
    P2 = abs(Y/L);
    P = P2(1:ceil(L/2+1));
    P(2:end-1) = 2 * P(2:end-1);
    
    xfeature.fc = mean(P);

    xfeature.rmsf = sqrt(mean(P.^2));
    
    xfeature.rvf = sqrt(mean((P - xfeature.fc).^2));

    output = xfeature;
    
end
