function returnVal = envTbl()

    % Ball Fault 7, 14, 21 inch
    load('Ball_DE_0007.mat', 'X118_DE_time');    load('Ball_DE_0007.mat', 'X118_FE_time');
    load('Ball_FE_0007.mat', 'X282_FE_time');    load('Ball_FE_0007.mat', 'X282_DE_time');
    load('Ball_DE_0014.mat', 'X185_DE_time');    load('Ball_DE_0014.mat', 'X185_FE_time');
    load('Ball_FE_0014.mat', 'X286_FE_time');    load('Ball_FE_0014.mat', 'X286_DE_time');
    load('Ball_DE_0021.mat', 'X222_DE_time');    load('Ball_DE_0021.mat', 'X222_FE_time');
    load('Ball_FE_0021.mat', 'X290_FE_time');    load('Ball_FE_0021.mat', 'X290_DE_time');
    
    % Inner Fault 7 14 21 inch
    load('IR_DE_0007.mat', 'X105_DE_time');    load('IR_DE_0007.mat', 'X105_FE_time');
    load('IR_FE_0007.mat', 'X278_FE_time');    load('IR_FE_0007.mat', 'X278_DE_time');
    load('IR_DE_0014.mat', 'X169_DE_time');    load('IR_DE_0014.mat', 'X169_FE_time');
    load('IR_FE_0014.mat', 'X274_FE_time');    load('IR_FE_0014.mat', 'X274_DE_time');
    load('IR_DE_0021.mat', 'X209_DE_time');    load('IR_DE_0021.mat', 'X209_FE_time');
    load('IR_FE_0021.mat', 'X270_FE_time');    load('IR_FE_0021.mat', 'X270_DE_time');
    
    % Outer Fault 7 14 21 inch
    load('OR_DE_0007.mat', 'X130_DE_time');     load('OR_DE_0007.mat', 'X130_FE_time');
    load('OR_FE_0007.mat', 'X294_FE_time');     load('OR_FE_0007.mat', 'X294_DE_time');
    load('OR_DE_0014.mat', 'X197_DE_time');     load('OR_DE_0014.mat', 'X197_FE_time');
    load('OR_FE_0014.mat', 'X313_FE_time');     load('OR_FE_0014.mat', 'X313_DE_time');
    load('OR_DE_0021.mat', 'X234_DE_time');     load('OR_DE_0021.mat', 'X234_FE_time');
    load('OR_FE_0021.mat', 'X315_FE_time');     load('OR_FE_0021.mat', 'X315_DE_time');
    
    % Normal data
    load('Normal_1.mat', 'X097_DE_time', 'X097_FE_time');
    load('Normal_2.mat', 'X098_DE_time', 'X098_FE_time');
    load('Normal_3.mat', 'X099_DE_time', 'X099_FE_time');
    load('Normal_4.mat', 'X100_DE_time', 'X100_FE_time');
    
    Ball_DE_07 = envelopFeature(X118_DE_time, X118_FE_time,"Ball_07","DE"); Ball_DE_07(:,37) = []; 
    Ball_FE_07 = envelopFeature(X282_DE_time, X282_FE_time,"Ball_07","FE"); 
    
    Ball_DE_14 = envelopFeature(X185_DE_time, X185_FE_time,"Ball_14","DE"); Ball_DE_14(:,37) = [];
    Ball_FE_14 = envelopFeature(X286_DE_time, X286_FE_time,"Ball_14","FE"); 
    
    Ball_DE_21 = envelopFeature(X222_DE_time, X222_FE_time,"Ball_21","DE"); Ball_DE_21(:,37) = [];
    Ball_FE_21 = envelopFeature(X290_DE_time, X290_FE_time,"Ball_21","FE"); 
    
    Inner_DE_07 = envelopFeature(X105_DE_time, X105_FE_time,"Inner_07","DE"); Inner_DE_07(:,37) = [];
    Inner_FE_07 = envelopFeature(X278_DE_time, X278_FE_time,"Inner_07","FE"); 
    
    Inner_DE_14 = envelopFeature(X169_DE_time, X169_FE_time,"Inner_14","DE"); Inner_DE_14(:,37) = [];
    Inner_FE_14 = envelopFeature(X274_DE_time, X274_FE_time,"Inner_14","FE");
    
    Inner_DE_21 = envelopFeature(X209_DE_time, X209_FE_time,"Inner_21","DE"); Inner_DE_21(:,37) = [];
    Inner_FE_21 = envelopFeature(X270_DE_time, X270_FE_time,"Inner_21","FE"); 
    
    Outer_DE_07 = envelopFeature(X130_DE_time, X130_FE_time,"Outer_07","DE"); Outer_DE_07(:,37) = [];
    Outer_FE_07 = envelopFeature(X294_DE_time, X294_FE_time,"Outer_07","FE");
    
    Outer_DE_14 = envelopFeature(X197_DE_time, X197_FE_time,"Outer_14","DE"); Outer_DE_14(:,37) = [];
    Outer_FE_14 = envelopFeature(X313_DE_time, X313_FE_time,"Outer_14","FE"); 
    
    Outer_DE_21 = envelopFeature(X234_DE_time, X234_FE_time,"Outer_21","DE"); Outer_DE_21(:,37) = [];
    Outer_FE_21 = envelopFeature(X315_DE_time, X315_FE_time,"Outer_21","FE"); 
    
    Normal1 = envelopFeature(X097_DE_time, X097_FE_time,"Normal","DE"); Normal1(:,37) = []; 
    Normal2 = envelopFeature(X097_DE_time, X097_FE_time,"Normal","FE");            
    
    env_table = [Ball_DE_07 Ball_FE_07;     Ball_DE_14 Ball_FE_14;      Ball_DE_21 Ball_FE_21   ;...
                 Inner_DE_07 Inner_FE_07;   Inner_DE_14 Inner_FE_14;    Inner_DE_21 Inner_FE_21 ;...
                 Outer_DE_07 Outer_FE_07;   Outer_DE_14 Outer_FE_14;    Outer_DE_21 Outer_FE_21 ;...
                 Normal1 Normal2];
    
    returnVal = env_table;

end