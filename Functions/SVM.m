function lossSVM = SVM(Train,Train_class,Test,Test_class)

    rng(10);
    
    SVM = fitcecoc(Train,cellstr(Train_class), 'ClassNames',unique(Train_class(:,1)));
    
    ResubErr_SVM = resubLoss(SVM)
    rng(0);
    
    cv_SVM = cvpartition(cellstr(Train_class),'KFold',3);
    cvMdl_SVM = crossval(SVM,'CVPartition',cv_SVM); 
    cvErr_SVM = kfoldLoss(cvMdl_SVM)
    
    testPred_SVM = predict(SVM,Test);
    trainPred_SVM = predict(SVM,Train);
    lossSVM = loss(SVM, Test, Test_class);
    
    figure
    subplot(1,2,1)
    confusionchart(cellstr(Train_class),trainPred_SVM)
    title('Confusion matrix of train data');
    
    subplot(1,2,2)
    confusionchart(cellstr(Test_class),testPred_SVM)
    title('Confusion matrix of test data');

end