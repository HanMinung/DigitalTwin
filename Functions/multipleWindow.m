function [res1, res2, res3, res4, res5, res6, res7, res8, res9] = multipleWindow(cls1, cls2, cls3, cls4, cls5, cls6, cls7, cls8, cls9)

    res1 = windowSliding(cls1);
    res2 = windowSliding(cls2);
    res3 = windowSliding(cls3);
    res4 = windowSliding(cls4);
    res5 = windowSliding(cls5);
    res6 = windowSliding(cls6);
    res7 = windowSliding(cls7);
    res8 = windowSliding(cls8);
    res9 = windowSliding(cls9);

end
