folderPath = 'C:\Users\hanmu\Desktop\DigitalTwin\Project #1\Problem #1\dataset';
addpath(folderPath);

% Get list of .mat extension files in folder
matFiles = dir(fullfile(folderPath, '*.mat'));

% Load data from each .mat file one by one
for i = 1:numel(matFiles)
    
    filePath = fullfile(matFiles(i).folder, matFiles(i).name);
   
    load(filePath);

end
