function [output1, output2, output3] = getFeatures(num_segments, overlap_ratio, input_files, variable_names, output_prefixes, class_name)

    % Load input data
    data = cell(1, length(input_files));
    for i = 1:length(input_files)
        temp_data = load(input_files{i}, variable_names{i});
        data{i} = temp_data.(variable_names{i});
    end
    
    % Process input data with sliding window and timeFeatures function
    [output1, output2, output3] = processInputData(data, num_segments, overlap_ratio, output_prefixes, class_name);
    
end

function [output1, output2, output3] = processInputData(data, num_segments, overlap_ratio, output_prefixes, class_name)

    % Initialize output tables
    output1 = table();
    output2 = table();
    output3 = table();
    
    % Calculate fault frequencies
    [BPFO_DE, BPFO_FE, BPFI_DE, BPFI_FE, BSF_DE, BSF_FE] = faultFreq();
    faultFreqs = {BPFO_DE, BPFO_FE, BPFI_DE, BPFI_FE, BSF_DE, BSF_FE};

    % Process each input data with sliding window and timeFeatures function
    for data_idx = 1:length(data)

        total_data = length(data{data_idx});
        window_size = ceil(total_data / (num_segments - overlap_ratio * (num_segments - 1)));
        step_size = ceil(window_size * (1 - overlap_ratio));
        
        % Compute the number of windows based on num_segments
        num_windows = num_segments;
        
        for i = 1:num_windows
            start_idx = 1 + (i - 1) * step_size;
            end_idx = min(ceil(start_idx + window_size - 1), total_data);
            segment_data = data{data_idx}(start_idx:end_idx);
            segment_name = sprintf('%s_%d', output_prefixes{data_idx}, i);
            segment_features1 = staticFeatures(segment_data, class_name);
            segment_features1.Properties.RowNames = {segment_name};
            output1 = [output1; segment_features1];
            
            segment_features2 = envelopeFeatures(segment_data, faultFreqs, class_name);
            segment_features2.Properties.RowNames = {segment_name};
            output2 = [output2; segment_features2];
            
            segment_features3 = waveletFeatures(segment_data, class_name);
            segment_features3.Properties.RowNames = {segment_name};
            output3 = [output3; segment_features3];
        end
    end
    
end

% The original dataFeatures function
function output = staticFeatures(input, class_name)
    x = input; 

    % Initialize xfeature without RowNames
    xfeature = table();
    % mean and STD
    xfeature.mean=mean(x);
    xfeature.std=std(x);

    % RMS
    xfeature.rms=rms(x);
    my_rms= sqrt(mean(x.^2));
    
    % square root average
    xfeature.sra= (mean(sqrt(abs(x))))^2;
    
    % Average of Absolute Value
    xfeature.aav=mean(abs(x));

    % Energy (sum of power_2)
    xfeature.energy=sum(x.^2);
    
    % Peak
    xfeature.peak= max(abs(x));
    
    % Peak2Peak
    xfeature.ppv=peak2peak(x);
        
    % Impulse Factor
    xfeature.if=xfeature.peak/xfeature.aav;
    
    % Shape Factor
    xfeature.sf=xfeature.rms/xfeature.aav;
    
    % Crest Factor
    xfeature.cf= xfeature.peak / xfeature.rms;
      
    % Marginal(Clearance) Factor
    xfeature.mf=xfeature.peak/xfeature.sra;
    
    % Skewness(외도)
    xfeature.sk=skewness(x);
    xsk = mean(((x - xfeature.mean)/xfeature.std).^3);
     
    % Kurtosis(첨도)
    xfeature.kt=kurtosis(x);
    xkt = mean(((x - xfeature.mean)/xfeature.std).^4);
    
    L=length(x);
    Y = fft(x);
    P2 = abs(Y/L);
    P = P2(1:ceil(L/2+1));
    P(2:end-1) = 2*P(2:end-1);
    
    xfeature.fc = mean(P);

    xfeature.rmsf = sqrt(mean(P.^2));
    
    xfeature.rvf = sqrt(mean((P - xfeature.fc).^2));
    
    xfeature.cls = class_name;
    
    % xfeature.length = length(x);

    output = xfeature;
end


function output = envelopeFeatures(input, faultFreqs, class_name)
    
    fs = 12000;
    x = input;
    % Initialize xfeature without RowNames
    xfeature = table();
    
    % Compute envelope spectrum
    [x_pEnv, x_fEnv, ~, ~] = envspectrum(x, fs);

    numRMS = 6; % Number of RMS values to compute
    
    faultNames = {'BPFO_DE', 'BPFO_FE', 'BPFI_DE', 'BPFI_FE', 'BSF_DE', 'BSF_FE'};
    num = ["1st", "2nd", "3th", "4th", "5th", "6th"];
    columnNames = {};


    for i = 1:length(faultFreqs)
        for j = 1 : numRMS

            freqIndices = find(x_fEnv > j * faultFreqs{i} * (1 - 0.01) & x_fEnv < j * faultFreqs{i} * (1 + 0.01));
            
            rmsVal = rms(x_pEnv(freqIndices));
            
            columnName = sprintf('%s_%s', faultNames{i}, num(j));
            xfeature.(columnName) = rmsVal;

        end
    end

    xfeature.cls = class_name;
    output = xfeature;

    
end



% The new waveletFeatures function
function output = waveletFeatures(input, class_name)

    x = input;

    % Initialize xfeature without RowNames
    xfeature = table();
    
    % wavelet
    wpt_x = wpdec(x, 4, 'db4');
    E_x = wenergy(wpt_x);
    
    for i = 1:length(E_x)
        xfeature.(['E' num2str(i)]) = E_x(i);
    end

    xfeature.cls = class_name;
    output = xfeature;

end
