clc; clear; close all;

% List of folder names
folders = {'c2', 'c3', 'c4', 'c5', 'c6'}; %,    'c1'

% Loop through each folder
for folder_idx = 1:length(folders)
    folder_name = folders{folder_idx};
    folder_files = dir(fullfile(folder_name, '*.mat'));
    
    % Initialize an empty table to store features for the current folder
    all_features_folder = table();
    
    % Column names
    col_names = {'F_x', 'F_y', 'F_z', 'g_x', 'g_y', 'g_z', 'V_RMS'};
    
    % Loop through each .mat file in the folder
    for file_idx = 1:length(folder_files)
        file_name = fullfile(folder_files(file_idx).folder, folder_files(file_idx).name);
        data_struct = load(file_name);
        
        % Get the field name and extract the data
        field_name = fieldnames(data_struct);
        data_array = data_struct.(field_name{1});
        
        % Convert the data array to a table
        data = array2table(data_array, 'VariableNames', col_names);
        
        % Calculate the magnitude for F and g columns
        F_mag = sqrt(sum(data{:, 1:3}.^2, 2));
        g_mag = sqrt(sum(data{:, 4:6}.^2, 2));
        
        % Add the magnitudes to the table
        data.F_mag = F_mag;
        data.g_mag = g_mag;
        
        % Initialize an empty table to store features for the current file
        all_features = table();
        
        % Calculate time and frequency domain features for each column
        for col_idx = 1:9
            col_name = data.Properties.VariableNames{col_idx};
            numeric_data = table2array(data(:, col_idx));
            time_feature_table = cnc_timeFeatures(numeric_data, col_name);
            freq_feature_table = cnc_freqFeatures(numeric_data, col_name);
            
            % Combine the feature tables
            feature_table = [time_feature_table, freq_feature_table];
            
            % Add the combined features for the current column to the all_features table
            if col_idx == 1
                all_features = feature_table;
            else
                all_features = [all_features, feature_table];
            end
        end
        
        % Add the combined features for the current file to the all_features_folder table
        all_features_folder = [all_features_folder; all_features];
    end
    
    % Save the features table to a .mat file
    save(fullfile(folder_name, 'features.mat'), 'all_features_folder');
end
