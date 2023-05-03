clc; clear; close all;

% List of folder names
folders = {'c1', 'c2', 'c3', 'c4', 'c5', 'c6'}; %, 'c2', 'c3', 'c4', 'c5', 'c6'

% Loop through each folder
for folder_idx = 1:length(folders)
    folder_name = folders{folder_idx};
    folder_files = dir(fullfile(folder_name, '*.csv'));
    
    % Loop through each .csv file in the folder
    for file_idx = 1:length(folder_files)
        file_name = fullfile(folder_files(file_idx).folder, folder_files(file_idx).name);
        data = readtable(file_name, 'VariableNamingRule', 'preserve');
        
        % Convert table to a matrix and save as a .mat file
        matrix_data = table2array(data);
        mat_file_name = strrep(file_name, '.csv', '.mat');
        save(mat_file_name, 'matrix_data');
    end
end