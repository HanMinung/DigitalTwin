% load all .mat extension files
% path should be modified when a new task is given
% # of classes should be modified

% function [cls1, cls2, cls3, cls4, cls5, cls6, cls7, cls8, cls9, cls10] = dataLoad()
% 
%     folderPath = 'C:\Users\hanmu\Desktop\DigitalTwin\Assignment\Assignment_2_Bearingdata';
%     addpath(folderPath);
%     
%     % Get list of .mat extension files in folder
%     matFiles = dir(fullfile(folderPath, '*.mat'));
%     
%     % Load data from each .mat file one by one
%     for i = 1:numel(matFiles)
%         
%         filePath = fullfile(matFiles(i).folder, matFiles(i).name);
%        
%         load(filePath);
%     
%     end
%     
%     cls1 = vertcat(X118_DE_time, X282_FE_time);     % Ball   0007 DE FE
%     cls2 = vertcat(X282_DE_time, X286_FE_time);     % Ball   0014 DE FE
%     cls3 = vertcat(X222_DE_time, X290_FE_time);     % Ball   0021 DE FE
%     cls4 = vertcat(X105_DE_time, X278_FE_time);     % Inner  0007 DE FE
%     cls5 = vertcat(X169_DE_time, X274_FE_time);     % Inner  0014 DE FE
%     cls6 = vertcat(X209_DE_time, X270_FE_time);     % Inner  0021 DE FE
%     cls7 = vertcat(X130_DE_time, X294_FE_time);     % Outer  0007 DE FE
%     cls8 = vertcat(X197_DE_time, X313_FE_time);     % Outer  0014 DE FE
%     cls9 = vertcat(X234_DE_time, X315_FE_time);     % Outer  0021 DE FE
%     cls10 = vertcat(X097_DE_time, X097_FE_time);     
% 
% end


function [BALL07, BALL14, BALL21, INNER07, INNER14, INNER21, OUTER07, OUTER14, OUTER21, NORMAL] = dataLoad() 

    folderPath = 'C:\Users\hanmu\Desktop\DigitalTwin\Assignment\Assignment_2_Bearingdata';
    addpath(folderPath);
    
    % Ball Fault 7, 14, 21 inch
    load('Ball_DE_0007.mat', 'X118_DE_time');
    load('Ball_FE_0007.mat', 'X282_FE_time');
    load('Ball_DE_0014.mat', 'X185_DE_time');
    load('Ball_FE_0014.mat', 'X286_FE_time');
    load('Ball_DE_0021.mat', 'X222_DE_time');
    load('Ball_FE_0021.mat', 'X290_FE_time');
    
    % Inner Fault 7 14 21 inch
    load('IR_DE_0007.mat', 'X105_DE_time');
    load('IR_FE_0007.mat', 'X278_FE_time');
    load('IR_DE_0014.mat', 'X169_DE_time');
    load('IR_FE_0014.mat', 'X274_FE_time');
    load('IR_DE_0021.mat', 'X209_DE_time');
    load('IR_FE_0021.mat', 'X270_FE_time');
    
    % Outer Fault 7 14 21 inch
    load('OR_DE_0007.mat', 'X130_DE_time');
    load('OR_FE_0007.mat', 'X294_FE_time');
    load('OR_DE_0014.mat', 'X197_DE_time');
    load('OR_FE_0014.mat', 'X313_FE_time');
    load('OR_DE_0021.mat', 'X234_DE_time');
    load('OR_FE_0021.mat', 'X315_FE_time');
    
    % Normal data
    load('Normal_1.mat', 'X097_DE_time', 'X097_FE_time');
    load('Normal_2.mat', 'X098_DE_time', 'X098_FE_time');
%     load('Normal_3.mat', 'X099_DE_time', 'X099_FE_time');
%     load('Normal_4.mat', 'X100_DE_time', 'X100_FE_time');

    % Sliding window     
    num_segments = 15;
    overlap_ratio = 0;

    % Ball 07 Data 
    input_files = {'Ball_DE_0007.mat', 'Ball_FE_0007.mat'};
    variable_names = {'X118_DE_time', 'X282_FE_time'};
    output_prefixes = {'Ball_07_DE', 'Ball_07_FE'};
    BALL07 = mainFunction(num_segments, overlap_ratio, input_files, variable_names, output_prefixes);

    % Ball 14
    input_files = {'Ball_DE_0014.mat', 'Ball_FE_0014.mat'};
    variable_names = {'X185_DE_time', 'X286_FE_time'};
    output_prefixes = {'Ball_14_DE', 'Ball_14_FE'};
    BALL14 = mainFunction(num_segments, overlap_ratio, input_files, variable_names, output_prefixes);
    
    % Ball 21
    input_files = {'Ball_DE_0021.mat', 'Ball_FE_0021.mat'};
    variable_names = {'X222_DE_time', 'X290_FE_time'};
    output_prefixes = {'Ball_21_DE', 'Ball_21_FE'};
    BALL21 = mainFunction(num_segments, overlap_ratio, input_files, variable_names, output_prefixes);

    % inner 07
    input_files = {'IR_DE_0007.mat', 'IR_FE_0007.mat'};
    variable_names = {'X105_DE_time', 'X278_FE_time'};
    output_prefixes = {'Inner_07_DE', 'Inner_07_FE'};
    INNER07 = mainFunction(num_segments, overlap_ratio, input_files, variable_names, output_prefixes);

    % inner 14
    input_files = {'IR_DE_0014.mat', 'IR_FE_0014.mat'};
    variable_names = {'X169_DE_time', 'X274_FE_time'};
    output_prefixes = {'Inner_14_DE', 'Inner_14_FE'};
    INNER14 = mainFunction(num_segments, overlap_ratio, input_files, variable_names, output_prefixes);
    
    % inner 21
    input_files = {'IR_DE_0021.mat', 'IR_FE_0021.mat'};
    variable_names = {'X209_DE_time', 'X270_FE_time'};
    output_prefixes = {'Inner_21_DE', 'Inner_21_FE'};
    INNER21 = mainFunction(num_segments, overlap_ratio, input_files, variable_names, output_prefixes);

    % outer 07
    input_files = {'OR_DE_0007.mat', 'OR_FE_0007.mat'};
    variable_names = {'X130_DE_time', 'X294_FE_time'};
    output_prefixes = {'Outer_07_DE', 'Outer_07_FE'};
    OUTER07 = mainFunction(num_segments, overlap_ratio, input_files, variable_names, output_prefixes);

    % outer 14
    input_files = {'OR_DE_0014.mat', 'OR_FE_0014.mat'};
    variable_names = {'X197_DE_time', 'X313_FE_time'};
    output_prefixes = {'Outer_14_DE', 'Outer_14_FE'};
    OUTER14 = mainFunction(num_segments, overlap_ratio, input_files, variable_names, output_prefixes);

    % outer 21
    input_files = {'OR_DE_0021.mat', 'OR_FE_0021.mat'};
    variable_names = {'X234_DE_time', 'X315_FE_time'};
    output_prefixes = {'Outer_21_DE', 'Outer_21_FE'};
    OUTER21 = mainFunction(num_segments, overlap_ratio, input_files, variable_names, output_prefixes);

    % Normal data
    % Normal data는 데이터가 크기 떄문에 2개 사용
    num_segments = 15;
    overlap_ratio = 0;
    % input_files = {'Normal_1.mat', 'Normal_2.mat', 'Normal_3.mat', 'Normal_4.mat'};
    input_files = {'Normal_1.mat', 'Normal_2.mat'};
    variable_names = {'X097_DE_time', 'X098_FE_time'};
    output_prefixes = {'Normal1_DE', 'Normal2_FE'};
    NORMAL = mainFunction(num_segments, overlap_ratio, input_files, variable_names, output_prefixes);

end