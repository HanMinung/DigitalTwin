# Digital twin & Automation 

Writer : HanMinung

Semester : Spring semester, 2023

Univ : Handong global university

School Mechanical and control engineering



## Contents

[TOC]



## 1. Introduction

### 1.1. PHM

* Prognostics and Health management
* Technology that collects information on machines, equipment, etc., detects, analyzes, and diagnoses abnormal situations in the system, predicts the time of failure in advance, and optimizes management.

### 1.2. Terminology

* fault
  * Abnormal state of system 
* failure
  * An event from faults
  * Permanent interuption
* malfunction
  * Temporary interruption

### 1.3. Usage

* Mainly occurring in industrial sites include failure due to inner or outer cracks of bearings, and a process of diagnosing failures is required.

### 1.4. Process

* Acquire data
* Preprocess data : denoise
* Extract condition indicator : feature extraction
  * methods of feature extraction
    * Complex envelope analysis
    * Statistical features
    * Wavelet package analysis
    * Short time fourier transform
* Train model : machine learning
* Test and Deploy 



## 2. Part 1 : Feature extraction

### 2.1. Terminology

* Variance

  * Deviation within the same class data

* Covariance (공분산)

  * Relation between two random variables, may not be independant

  * Cov(x, y) > 0 : y increases when x increases

    Cov(x, y) < 0 : y decreases when x decreases

  * 공분산을 표준편차로 나눠주면, [-1, 1]의 값에 놓이게 되고 이를 correlation이라 한다.

  * Covariance matrix 

    <img src="https://user-images.githubusercontent.com/99113269/223763450-57552df1-9e80-4973-a173-ff80ae8d81a0.png" alt="image" style="zoom: 50%;" />

    대각 성분을 중심으로 서로 대칭구조

* Correlation

  * scaled covariance

  * $$
    cor(x,y) = \rho(x,y) = cov(x,y)/(\sigma(x)*\sigma(y))
    $$

    

* Nomalization

  * Mahalnobis distance
    * 평균과 표준편차로 표현될 때 표준편차의 크기로 거리를 산정
    * 평균과의 거리가 표준편차의 몇배인지를 나타내는 값
  * The goal of normalization
    * transform features to be on a similar scale, to improve the performance and training stability 

* RMS

  * Root mean square

* Square root average

  * Squared mean value of the square roots of the absolute amplitude 

* Shape factor (형상 계수)

  * RMS / mean of absolute value
  * Dependant on signal shape but independent of signal dimension
  
* Impulse factor

  * Peak / mean level 

* Crest factor

  * Peak / RMS
  * provide early warning for faults
  
* Marginal factor

  * Peak / SRA
  * Maximum for healthy bearing but decreased for defected
  
* Skewness, Kurtosis

  * Skewness (왜도)
    * 3rd standardized moment
    * Measures the symmetry of the distribution
    * 양수인 경우 좌측으로 치우친 분포
    * 음수인 경우 우측으로 치우친 분포
  * Kurtosis (첨도)
    * 4th standardized moment
    * Degree of presence of outliers in the distribution
    * Faults can increase outliers
    * Leptokurtic
      * 양수인 경우, 정규 분포보다 긴 꼬리를 가지고, 분포가 보다 중앙부분에 덜 집중되어 중앙부분이 뾰족한 모양이 된다. 
    * Platykurtic
      * 첨도가 0보다 작아, 정규분포보다 짧은 꼬리를 가지고 분포가 중앙부분에 더 집중되어 완만한 모양을 가지게 된다.

* 위 자료들을 바탕으로, 어떠한 신호의 시간 영역에서의 특성, 주파수 영역에서의 특성을 아는 것이 중요하기 때문에, 신호의 특성들을 뽑아주는 함수가 필요하다.

```matlab
function xfeature = timeFeatures(input) 
    
    x =  input;
    xfeature = table;
    N = length(x);
    
    xfeature.mean = mean(x);
    xfeature.std = std(x);
    xfeature.rms = sqrt(sum(power(x,2))/N);
    xfeature.sra = power((sum(sqrt(abs(x)))/N),2);
    xfeature.aav = sum(abs(x))/N;
    xfeature.energy = sum(x.^2);
    xfeature.peak = max(x);
    xfeature.ppv = peak2peak(x);
    xfeature.if = xfeature.peak/xfeature.aav;
    xfeature.sf = xfeature.rms/xfeature.aav;
    xfeature.cf = max(abs(x))/xfeature.rms;
    xfeature.mf = xfeature.peak/xfeature.sra;
    xfeature.sk = skewness(x);
    xfeature.kt = kurtosis(x);

end
```

```matlab
function freqfeature = freqFeatures(P)

    freqfeature = table;
    N = length(P);

    freqfeature.fc = sum(P)/N;
    freqfeature.rmsf = sqrt(sum(P.^2)/N);
    freqfeature.rvf = sqrt(sum((P-freqfeature.fc).^2)/N);

end
```



### 2.2. Window

* Window is used to damp out the effects of the Gibbs phenomenon that results from truncation of an infinite series.

* 윈도우는 샘플 된 구간의 맨 앞쪽과 뒤쪽의 신호가 0으로 변하게 하고, 나머지 구간을 모두 0으로 간주하도록 유도한다.

* DFT를 위한 구간의 시작과 끝나는 위치에 신호를 0으로 만들어 주는 효과를 준다.

  <img src="https://user-images.githubusercontent.com/99113269/223947063-30462bcf-c068-47f7-b9e3-6b83d11cc1ac.png" alt="image" style="zoom: 67%;" />

* Rectangular window, sine window, Hanning window, Hamming window, Blackman window, Gaussian window 등등이 존재한다.
* Gibbs phenomenon으로 인해 특정 주파수를 가지는 신호를 FFT를 하게 되면, 그 주파수 뿐만 아니라, 다른 대역의 주파수 역시 관찰이 된다.
* 이를 막기 위해, 다음과 같은 Hamming window를 입력 신호에 곱하여 FFT를 취하는 방법을 주로 사용한다.

<img src="https://user-images.githubusercontent.com/99113269/223951068-3fa5942a-bec1-41fb-b6bf-e457c812f0fc.png" alt="image" style="zoom:70%;" />



### Short time Fourier Transformation

* Linear time-frequency representation useful in the analysis of nonstationary multicomponent signals.

* FFT의 경우, 분석을 하게 되면 특정 신호의 주파수 성분에 대해 알수 있지만, 어느 시점에 존재하는지에 대한 여부는 알 수 없다.

* 다음과 같이 시간에 따라 주파수 성분이 달라지는 신호에 대해 FFT 및 STFT 결과는 다음과 같다.

  <img src="https://user-images.githubusercontent.com/99113269/223952606-d07b7918-ab0e-453d-8dc0-5dd5c350cf4c.png" alt="image" style="zoom: 67%;" />

  ![image](https://user-images.githubusercontent.com/99113269/223953118-b240d1fe-4aeb-4b74-81ed-a68fb56c4ade.png)

* MATLAB으로 관찰해본 결과는 다음과 같다.

  ```matlab
  ts = 0:1/1e3:2;
  f0 = 100;
  f1 = 200;
  fs=1e3;						% 1000 hz sampling frequency
  
  x = chirp(ts,f0,1,f1);		% Frequency varying signal
  
  [S,F,T] = stft(x, fs, 'Window', hamming(128,'periodic'), 'OverlapLength',50, 'FrequencyRange','onesided')
  
  figure
  waterfall(F,T,abs(S)')
  helperGraphicsOpt(1)
  
  function helperGraphicsOpt(ChannelId)
  	ax = gca;
  	ax.XDir = 'reverse';
  	ax.ZLim = [0 30];
  	ax.Title.String = ['Input Channel: ' num2str(ChannelId)];
  	ax.XLabel.String = 'Frequency (Hz)';
  	ax.YLabel.String = 'Time (seconds)';
  	ax.View = [30 45];
  end
  ```

  <img src="https://user-images.githubusercontent.com/99113269/223953820-2a4f5ee4-21d5-438d-8c20-05db451f3b47.png" alt="image" style="zoom: 80%;" />





### 2.3. Wavelet transformation

* 특정 신호의 scale과 shifting을 통해 시간 간격 및 주파수 해상도를 때에 따라 다르게 가져가는 기법

* 높은 주파수의 신호에 대해서는 resolution을 높게 가져가고, 반대의 신호에 대해서는 resolution을 낮게 가져가는 기법이다.

  <img src="https://user-images.githubusercontent.com/99113269/223956190-87ae9e4e-a95f-434e-94fd-8f080dba57a5.png" alt="image" style="zoom: 40%;" />



### 2.4. Wavelet Multi-Level Decomposition

* This method is used to decompose low frequency signals iteratively
* Often used in bearing fault diagnosis

<img src="https://user-images.githubusercontent.com/99113269/223956673-4cc5b875-d4f3-4abd-884a-743c7cbe8ea4.png" alt="image" style="zoom:50%;" />

* We can feature vector composed with many signals of different frequencies

* sample code of MATLAB

  ```matlab
  close all, clear all 
  
  Fs = 1000;              % Sampling frequency                    
  T = 1/Fs;               % Sampling period       
  N = 1000;               % Length of signal
  t = (0:N-1) * T;        % Time vector
  
  Fa=[1 10 50 100]
  
  X=0;
  
  for i=1:2
  	% combination of 1 and 10 Hz signal
      X = X + sin(2.0*pi*Fa(i)*t);
  end
  
  % 'wavedec' parameter
  - x : signal
  - 3 : level of decomposition
  - return value (c): decomposed result of input signal
  - return value (l): bookkeeping vector (레벨별 계수의 개수 및 원신호의 길이를 포함)
  
  [c,l] = wavedec(X,3,'db2');
  approx = appcoef(c,l,'db2');
  [cd1,cd2,cd3] = detcoef(c,l,[1 2 3]);
  
  figure()
  subplot(4,1,1)
  plot(approx)
  title('Approximation Coefficients')
  subplot(4,1,2)
  plot(cd3)
  title('Level 3 Detail Coefficients')
  subplot(4,1,3)
  plot(cd2)
  title('Level 2 Detail Coefficients')
  subplot(4,1,4)
  plot(cd1)
  title('Level 1 Detail Coefficients')
  ```

* Original signal

<img src="https://user-images.githubusercontent.com/99113269/223958589-86c993b4-6758-44eb-93b8-f59fe5ee63af.png" alt="image" style="zoom:67%;" />

<img src="C:\Users\hanmu\AppData\Roaming\Typora\typora-user-images\image-20230309171004560.png" alt="image-20230309171004560" style="zoom:67%;" />





## 3. Part 2 : Machine Learning (1)

### 3.1. machine learning (1) : Contents and flow

* Supervised Classification
  * Logistic Regression
  * LDA
  * SVM
  * Decision Tree
  * Random Forrest
  * Neutral Network
* Unsupervised (Cluster)
  * K-NN
* Workflow for maching learning
  1. Data loading
  2. Preprocessing
  3. Feature extraction from preprocessed data
  4. Machine learning with such features
  5. Repetition for selecting best model
  6. system reflection with best model



### 3.2. Linear regression

#### 3.2.1. Concept

<img src="https://user-images.githubusercontent.com/99113269/227145082-d3550d5e-8e27-476e-9af6-260356e1c512.png" alt="image" style="zoom:45%;" />

#### 3.2.2. Gradient descent

* Extrema point is located at gradient = 0
* Minimize cost/loss function : J(w)
* Control the step size with learning rate

<img src="https://user-images.githubusercontent.com/99113269/227145337-a84a859c-ce5b-4bac-8709-fe4d1bb50505.png" alt="image" style="zoom:50%;" />



#### 3.2.3. Gradient descent example code

* Example code of gradient descent when p = 1

  ```matlab
  N=100;
  X = randn(N,1);
  Y = X*2 + 3+randn(N,1);
  
  %  Variable
  lamda=0.1;	t0 = 0.5;	t1 = 0.5;	e = 1;	itrN = 1000;	k=0;
  
  while(e > 0.001 || k < itrN)
      
      h = t1 .* X + t0;
  
      dJt1 = (-1) * mean(X .* (Y-h));
      dJt0 = (-1) * mean(Y - h);
  
      t1_new = t1 - lamda .* dJt1;
      t0_new = t0 - lamda .* dJt0;
  
      e = 0.5 * (abs((t1_new-t1))+abs((t0_new-t0)));
      
      t1 = t1_new;
      t0 = t0_new;
  
      k=k+1;
  
  end
  ```

* Example code of gradient descent when p=2

  ```matlab
  X = randn(100,2);
  Y = X * [2;4] + 3+ randn(100,1);
  
  %  Variable
  lamda=0.1;	t0 = 0.5;	t1 = 0.5;	t2 = 0.5;	e = 1;	itrN = 1000;	k = 0;
  
  while(e > 0.001 || k < itrN)
      
      h = X * [t1 ; t2] + t0;
      
      dJt2 = -(mean(X(:, 2) .* (Y - h)));
      dJt1 = -(mean(X(:, 1) .* (Y - h)));
      dJt0 = (-1) * mean(Y - h);
      
      t2_new = t2 - lamda .* dJt2;
      t1_new = t1 - lamda .* dJt1;
      t0_new = t0 - lamda .* dJt0;
  
      e = 0.5 * (abs((t2_new - t2)) + abs((t1_new - t1)) + abs((t0_new - t0)));
      
      t2 = t2_new;
      t1 = t1_new;
      t0 = t0_new;
  
      k=k+1;
  
  end
  ```





### 3.3. Classification

* Estimating optimal decision boundary to classify categorical data

* Non-linear function : Polynomial, Gaussian

  

#### 3.3.1. Logistic regression

* Logistic regression : classification learning algorithm

* A regression model for categorical data 

* Apply gradient descent method to find optimal parameter `theta ` to minimize the cost function

* Why do we use sigmoid function ?

  * Categorical data, bound prediction output within 0 ~ 1
  * Probability for class y = 1 for given data x

* Concepts

  <img src="https://user-images.githubusercontent.com/99113269/227254570-9dd4fed9-a598-49a1-b713-d3ee4cf22a6c.png" alt="image" style="zoom: 90%;" />



#### 3.3.2. Logistic regression example 1 : fisheriris

```matlab
clear 

load fisheriris

X = meas(:,1:2);               					% select two features : 꽃받침 길이, 너비
sp = categorical(species);
Ystat = sp == 'setosa';   	    				% Binary classfication : setosa vs no setosa    

Mdl = fitclinear(X,Ystat,'Learner','logistic')  % Process of fitting generalized regression model 
z = Mdl.Bias + X * Mdl.Beta;					% Form : Wx + b

Y = 1./ (1 + exp(-z));							% Logistic regression 

Y1indx = find(sp == 'setosa');					% 50 x 1
Y0indx = find(sp ~= 'setosa');					% 100 x 1

figure
plot(z(Y1indx),Y(Y1indx),'k.')
hold on
plot(z(Y0indx),Y(Y0indx),'b*')
hold off
```

<img src="https://user-images.githubusercontent.com/99113269/227261369-503dfdf6-c589-4a29-8ffa-f7590e9f767f.png" alt="image" style="zoom:70%;" />



#### 3.3.3. Logistic regression example 2 : CWRU bearing dataset

```matlab
clear

% Class : Inner & Outer
load("../3_MachingLearning/CRWU_Datas/example_train.mat");

feature1 = "sv";         					% skewness value of time data
feature2 = "ipf";       				 	% impulse factor

% two classes : Xtrain table about sv, ipf feature
Xtrain(:, 1) = table2array(glob_all_train(:, feature1));
Xtrain(:, 2) = table2array(glob_all_train(:, feature2));

Ytrain = class_cwru_train;                  % fault class
classKeep = ~strcmp(Ytrain,'normal');       % eliminate normal class

X = Xtrain(classKeep,:);  					% X : SV value , IF value of fault data
Y = Ytrain(classKeep);						% Y : Inner or Outer

f = figure;
gscatter(X(:,1), X(:,2), Y,'rb','os');
xlabel('Feature 1');
ylabel('Feature 2');
```

<img src="https://user-images.githubusercontent.com/99113269/227266802-9e3815ba-d6c3-4ccf-b6d5-6e52ea20c446.png" alt="image" style="zoom: 67%;" />



#### 3.3.4. Bayesian classification

* Calulation of bayesian estimation : 

<img src="https://user-images.githubusercontent.com/99113269/227698523-666554ab-a8be-47a3-82bd-92b151165e81.png" alt="image" style="zoom:33%;" />

* Bayesian classification은 지도 학습의 일종. 
* Training data set을 가지고 classifier 모델을 학습시킨뒤, test set을 가지고 classifier 모델의 성능을 평가한다. 
* 성능은 performance, accuracy, precision, recall 등으로 측정할 수 있다. 

* Process of bayesian classification

  * 두 클래스 w_1, w_2에 대해서

  $$
  if\quad P(w_1|x) > P(w_2|x)\quad then, \;chosoe \;w_1 else\; chosse\; w_2
  $$

* Example of bayesian classification

  <img src="https://user-images.githubusercontent.com/99113269/227699172-d37158ab-3054-4961-b8f9-51d66c730ae2.png" alt="image" style="zoom:50%;" />

#### 3.3.5. LDA : Linear Discriminant Analysis

A bayesian classification with assumption of 

* Likelihood P(x|wi) : Normal Distribution (Gaussian form)
* Each class has equal covariance 

Boundary for class k is defined as follows :

<img src="https://user-images.githubusercontent.com/99113269/227699354-b71d180c-9014-43bf-bd23-991c1e705c3e.png" alt="image" style="zoom:50%;" />

If covariance is different for each class, quadratic discriminant analysis is performed

<img src="https://user-images.githubusercontent.com/99113269/227699501-7da87a24-24c8-4eb7-b535-38b4af78479a.png" alt="image" style="zoom:50%;" />

​	

#### 3.5.6. Evaluation

* Precision, Recall, Accuracy, Confusion Matrix

  <img src="https://user-images.githubusercontent.com/99113269/227700271-59b1d8eb-c495-47d5-9292-2adf61fd582c.png" alt="image" style="zoom:50%;" />

* TPR (sensitivity or erecall)

  * 데이터 세트의 총 양성 인스턴스 수에 대한 올바르게 분류된 양성 인스턴스의 비율

* FPR (false positive ratio)

  * 데이터 세트의 총 음성 인스턴스 수에 대한 잘못 분류된 음성 인스턴스의 비율
  * FNR과 FPR 모두 잘못 분류된 인스턴스 집합을 기준으로 계산한다.
    * FNR : 음성으로 잘못 분류된 양성 사례의 비율을 측정
    * FPR : 양성으로 잘못 분류된 음성 사례의 비율을 측정

$$
True Positive Ratio \;(TPR) = \frac {True Positive}{True Positivie + False Positive} \\\\
False Positive Ratio \;(FPR) = \frac {False Positive}{False Positive + True Negative}
$$

* How can we calculate accuracy with calculated precision and recall?
  $$
  Accuracy = \frac{True Positive + True Negative}{True Positive + False Positive + True Negative + False Negative}
  $$
  



#### 3.5.7. LDA, LQA example : CWRU bearing data 

* Data sets : class (normal, inner, outer)
  * feature 1 : sv
  * feature 2 : impulse factor

<img src="https://user-images.githubusercontent.com/99113269/227702393-6e4443b2-54d5-4ed6-ac19-9040afc3e93b.png" alt="image" style="zoom:50%;" />

```matlab
% fit classification discriminant
lda = fitcdiscr(X,Y);								% default : LDA
ldaResubErr = resubLoss(lda)						% Calculation of misclassification of training set

ldaClass = resubPredict(lda);						% classified 'ldaClass' based on trained model

figure
ldaResubCM = confusionchart(Y,ldaClass);			
```

<img src="https://user-images.githubusercontent.com/99113269/227705785-f805bf84-db83-447c-af0c-8e021224b3ca.png" alt="image" style="zoom:50%;" />

* Misclassification plot

```matlab
bad = ~strcmp(ldaClass, Y);

figure
gscatter(X(:,1),X(:,2),Y)
hold on;
plot(X(bad,1), X(bad,2), 'kx');
hold off;
xlabel('Feature 1')
ylabel('Feature 2')
```

<img src="https://user-images.githubusercontent.com/99113269/227705819-0722c92e-f4a0-4a0d-976d-b6a4f24dd104.png" alt="image" style="zoom:50%;" />







## 4. Part 2 : Machine Learning (2)

### 4.1. SVM 

* Margin : shortest distance between the observation and the decision boundary
* Hyperplane boundary to classify the feature X as the label
* Hyperplane is expressed with two parameters.
* Terminology : Margin, Slack

​		마진 평면을 넘어가는 인스턴스를 허용하는 서포트 벡터 머신을 soft margin SVM 이라 한다.

<img src="C:\Users\hanmu\AppData\Roaming\Typora\typora-user-images\image-20230325195404559.png" alt="image-20230325195404559" style="zoom:50%;" />

​		이 방법을 사용할 때에는 마진 평면을 넘어가는 인스턴스에 대해 페널티를 부여 `Zeta` 

​		패널티 : 자신이 속한 클래스의 마진 평면에서 떨어진 거리

* C-SVM의 목적 함수 :

  <img src="https://user-images.githubusercontent.com/99113269/227712966-934c063a-9555-46e6-906a-cf23d01c3890.png" alt="image" style="zoom:50%;" />

  <img src="https://user-images.githubusercontent.com/99113269/227713324-b70dfc1a-abb2-47b4-8196-cb4cd7f83e18.png" alt="image" style="zoom: 40%;" />

* 데이터가 복잡해지는 경우, 선형으로 구분할 수 없는 경우가 발생하고, 차원을 올려 비선형 boundary를 만들어주게 된다.

  * Polynomial
  * Gaussian RBF



#### 4.1.1. SVM example :  Circular distribution

<img src="https://user-images.githubusercontent.com/99113269/227714005-ca5f4948-c897-41c8-add4-cd109e54929a.png" alt="image" style="zoom:50%;" />

```matlab
cl = fitcsvm(dataC,theclass,'KernelFunction','rbf','BoxConstraint',Inf,'ClassNames',[-1,1]);
  
mlResubErr = resubLoss(cl)								% misclassification error  on the training set.
mlClass = resubPredict(cl);								% Confusion matrix on the training set
	
figure()
ldaResubCM = confusionchart(theclass,mlClass);

% Predict scores on the grid
d = 0.02;

[x1Grid,x2Grid] = meshgrid(min(dataC(:,1)) : d:max(dataC(:,1)), min(dataC(:,2)) : d : max(dataC(:,2)));
xGrid = [x1Grid(:),x2Grid(:)];
[~,scores] = predict(cl,xGrid);

% Plot the data and the decision boundary
figure;
h(1:2) = gscatter(dataC(:,1),dataC(:,2),theclass,'rb','.');
hold on
ezpolar(@(x)1);
h(3) = plot(dataC(cl.IsSupportVector,1),dataC(cl.IsSupportVector,2),'ko');
contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'k');
legend(h,{'-1','+1','Support Vectors'});
axis equal
hold off
```

<img src="https://user-images.githubusercontent.com/99113269/227714260-eb0af5bb-4402-4807-b5e7-acf8cdf16cdc.png" alt="image" style="zoom: 67%;" />



### 4.2. Decision Tree

* Impurity : 해당 범주 안에 서로 다른 데이터가 얼마나 섞여 있는가?
* Entropy : 불순도를 수치적으로 나타낸 척도
* CART : Classification and Regression Tree
  * Popular method for decision tree
  * Finds the feature and criteria that best differentiate the data that maximize information gain or minimize the impurity



#### 4.2.1. Impurity - Gini index

* Decision tree의 분리 성능을 평가하기 위한 지표 

* 어떤 기준을 적용한뒤, 결과의 불순도가 낮을수록 좋다.

* 0에 가까울 수록, 그 클래스에 속한 불순도가 낮으므로 좋다. 
  $$
  GINI(t)=1- \sum(p(j|t))^2
  $$
  

#### 4.2.2. Example of Gini index

<img src="https://user-images.githubusercontent.com/99113269/227862816-ea2d5d5a-3f79-4850-8ace-5bb4907602f8.png" alt="image" style="zoom: 33%;" />



#### 4.2.3. Impurity - Entropy & Information gain

* Entropy or Information gain

* 데이터가 불순할 수록 얻을 수 있는 정보량은 적다.

* High value of entropy : Insufficient informations to determine.
  $$
  Entropy(t) = -\sum P(j|t)\log_2(P(j|t))
  $$



#### 4.2.4. Example of Entropy

<img src="https://user-images.githubusercontent.com/99113269/227864329-3c968bae-614b-4cfe-8794-894b1742b488.png" alt="image" style="zoom: 33%;" />















