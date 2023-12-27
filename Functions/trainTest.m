function [Train, trainCls, Test, testCls] = trainTest(table)

    envLen = length(table.cls);
    
    rng('default');
    envPartition = cvpartition(envLen,'Holdout', 0.3);
    
    idxTrain = training(envPartition);
    trainCls = table.cls(idxTrain,:);
    Train = table(idxTrain,:);
    
    Train(:,end) = [];
    
    idxTest = test(envPartition);
    testCls = table.cls(idxTest,:);
    Test = table(idxTest,:);

end

