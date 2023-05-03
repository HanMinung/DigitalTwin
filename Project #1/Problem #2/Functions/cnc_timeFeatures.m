function output = cnc_timeFeatures(input, col_name)
   
    x = input; 

    xfeature = table();
%     N=width(x);

    % mean and STD
    xfeature.mean=mean(x);
    xfeature.std=std(x);

    % RMS
    xfeature.rms=rms(x);
%     my_rms= sqrt(mean(x.^2));
    
    % square root average
    xfeature.sra= (mean(sqrt(abs(x)))).^2;    
%     % Average of Absolute Value
%     xfeature.aav=mean(abs(x));

    % Energy (sum of power_2)
    xfeature.energy=sum(x.^2);
    
%     % Peak
%     xfeature.peak= max(abs(x));
    
    % Peak2Peak
    xfeature.ppv=peak2peak(x);
        
    % Impulse Factor
    xfeature.if=max(abs(x))/mean(abs(x));
    %     xfeature.if=xfeature.peak/xfeature.aav;

    
    % Shape Factor
    xfeature.sf=xfeature.rms/mean(abs(x));
%     xfeature.sf=xfeature.rms/xfeature.aav;
    
    % Crest Factor
    xfeature.cf= max(abs(x)) / xfeature.rms;
%     xfeature.cf= xfeature.peak / xfeature.rms;
      
    % Marginal(Clearance) Factor
    xfeature.mf=max(abs(x))/xfeature.sra;
%     xfeature.mf=xfeature.peak/xfeature.sra;
    
    % Skewness(외도)
%     disp(['Data type: ', class(x), ' - Size: ', num2str(size(x, 1)), 'x', num2str(size(x, 2))]);
    xfeature.sk=skewness(x);
%     xsk = mean(((x - xfeature.mean)/xfeature.std).^3);
     
    % Kurtosis(첨도)
    xfeature.kt=kurtosis(x);
%     xkt = mean(((x - xfeature.mean)/xfeature.std).^4);
       
%     %길이
%     xfeature.length = length(x);


    output = xfeature;
    output.Properties.VariableNames = strcat(col_name, '_', output.Properties.VariableNames);
end