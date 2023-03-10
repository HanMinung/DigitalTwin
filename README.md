# Digital twin & Automation 

Writer : HanMinung

Semester : Spring semester, 2023

Univ : Handong global university

Department : Mechanical and control engineering



## Contents

[TOC]



## Introduction

### PHM

* Prognostics and Health management
* Technology that collects information on machines, equipment, etc., detects, analyzes, and diagnoses abnormal situations in the system, predicts the time of failure in advance, and optimizes management.

### Terminology

* fault
  * Abnormal state of system 
* failure
  * An event from faults
  * Permanent interuption
* malfunction
  * Temporary interruption

### Usage

* Mainly occurring in industrial sites include failure due to inner or outer cracks of bearings, and a process of diagnosing failures is required.

### Process

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



## Part 1 : Feature extraction

### Terminology

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



### Window

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





### Wavelet transformation

* 특정 신호의 scale과 shifting을 통해 시간 간격 및 주파수 해상도를 때에 따라 다르게 가져가는 기법

* 높은 주파수의 신호에 대해서는 resolution을 높게 가져가고, 반대의 신호에 대해서는 resolution을 낮게 가져가는 기법이다.

  <img src="https://user-images.githubusercontent.com/99113269/223956190-87ae9e4e-a95f-434e-94fd-8f080dba57a5.png" alt="image" style="zoom: 40%;" />



### Wavelet Multi-Level Decomposition

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

* 

* 

* 

* 

  

  

  

  















