% load all .mat extension files
% Function to load oversampled data
% path should be modified when a new task is given
% # of classes should be modified


folderPath = 'C:\Users\hanmu\Desktop\DigitalTwin\Assignment\Assignment_2_oversampled';
addpath(folderPath);

% % Get list of .mat extension files in folder
% matFiles = dir(fullfile(folderPath, '*.mat'));
% 
% % Load data from each .mat file one by one
% for i = 1:numel(matFiles)
%     
%     filePath = fullfile(matFiles(i).folder, matFiles(i).name);
%    
%     load(filePath);
% 
% end

load('BALL07.mat');