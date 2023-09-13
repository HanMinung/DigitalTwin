function lossTree = decisionTree(Train,Train_class,Test,Test_class)

    rng(10); 
    
    Tree = fitctree(Train, Train_class);
    
    ResubErr_Tree = resubLoss(Tree)
    
    rng(0)
    
    cvTree = cvpartition(Train_class,'KFold',3);
    cvMdlTree = crossval(Tree,'CVPartition',cvTree); 
    cvErrTree = kfoldLoss(cvMdlTree)
    
    testPred_Tree = predict(Tree, Test);
    trainPred_Tree = predict(Tree, Train);
    
    lossTree = loss(Tree, Test, Test_class);
    
    figure
%     subplot(1,2,1)
    confusionchart(cellstr(Train_class),trainPred_Tree)
    title('Confusion matrix of train data');
    
    figure 
%     subplot(1,2,2)
    confusionchart(cellstr(Test_class),testPred_Tree)
    title('Confusion matrix of test data');

end