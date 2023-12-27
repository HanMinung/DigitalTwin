function KNNloss = KNN(Train, trainClass, Test, testClass)

    rng(10);
    
    % mdl generation
    KNN = fitcknn(Train,trainClass,'NumNeighbors', 3, 'Standardize',1);
    
    resuberror_KNN = resubLoss(KNN);
    
    rng(0);
    
    cvKNN = cvpartition(trainClass, 'KFold', 3);
    cvMdlKNN = crossval(KNN, 'CVPartition', cvKNN);
    cvErrKNN = kfoldLoss(cvMdlKNN);
    
    testPred_KNN = predict(KNN, Test);
    trainPred_KNN = predict(KNN,Train);
    
    KNNloss =loss(KNN, Test, testClass);
    
    figure
    subplot(1,2,1)
    confusionchart(cellstr(trainClass),trainPred_KNN)
    title('Confusion matrix of train data');
    
    subplot(1,2,2)
    confusionchart(cellstr(testClass),testPred_KNN)
    title('Confusion matrix of test data');
    
end