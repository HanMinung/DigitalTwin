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
load('Normal_3.mat', 'X099_DE_time', 'X099_FE_time');
load('Normal_4.mat', 'X100_DE_time', 'X100_FE_time');