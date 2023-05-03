clc; clear; close all;

% List of folder names
folderNumbers = [2, 3, 5];


% Loop through each folder
for folderIdx = 1:numel(folderNumbers)
    folderNum = folderNumbers(folderIdx);
    folderName = sprintf('pre_c%d', folderNum);
    fprintf('Processing folder: %s\n', folderName);

%     folder_name = folders{folder_idx};
%     folder_files = dir(fullfile(folder_name, '*.mat'));
    
    % Initialize an empty table to store features for the current folder
    all_features_folder = table();
    
    % Column names
    col_names = {'F_x', 'F_y', 'F_z', 'g_x', 'g_y', 'g_z', 'V_RMS', 'F_mag', 'g_mag'};
    
    % Loop through each .mat file in the folder
    for fileNum = 1:315
        fileName = sprintf('%s/pre_c_%d_%03d.mat', folderName, folderNum, fileNum);
        fprintf('  Processing file: %s\n', fileName);
        data_struct = load(fileName);
        
        % Get the field name and extract the data
        field_name = fieldnames(data_struct);
        data_array = data_struct.(field_name{1});

        % Calculate the magnitude for F and g columns
        data_array(:, 8) = sqrt(sum(data_array(:, 1:3).^2, 2));  % F_mag
        data_array(:, 9) = sqrt(sum(data_array(:, 4:6).^2, 2));  % g_mag

        data_length = length(data_array);
        start_index = floor(data_length * 0.1) + 1;
        end_index = ceil(data_length * 0.9);
        
        % Convert the data array to a table
%         data = array2table(data_array, 'VariableNames', col_names);
        
%         % Calculate the magnitude for F and g columns
%         F_mag = sqrt(sum(data{:, 1:3}.^2, 2));
%         g_mag = sqrt(sum(data{:, 4:6}.^2, 2));
        
%         % Add the magnitudes to the table
%         data.F_mag = F_mag;
%         data.g_mag = g_mag;
        
        % Initialize an empty table to store features for the current file
        all_features = table();
        
        % Calculate time and frequency domain features for each column
        for colIdx = 1:9
            if colIdx == 7
                continue;
            end
            
%             fprintf('    Processing column: %d\n', colIdx);
%             col_name = data.Properties.VariableNames{col_idx};
%             numeric_data = table2array(data(:, col_idx));
            time_feature_table = cnc_timeFeatures(data_array(start_index:end_index, colIdx), col_names{colIdx});
            freq_feature_table = cnc_freqFeatures(data_array(start_index:end_index, colIdx), col_names{colIdx});
            
            % Combine the feature tables
            feature_table = [time_feature_table, freq_feature_table];
            
            % Add the combined features for the current column to the all_features table
            if colIdx == 1
                all_features = feature_table;
            else
                all_features = [all_features, feature_table];
            end
        end
        
        % Add the combined features for the current file to the all_features_folder table
        all_features_folder = [all_features_folder; all_features];
    end
    
    % Save the features table to a .mat file
    save(fullfile(folderName, 'pre_features.mat'), 'all_features_folder');
end