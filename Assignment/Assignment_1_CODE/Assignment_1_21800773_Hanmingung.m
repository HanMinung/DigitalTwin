clc; clear all; close all;

% -------------------------------------------------------------------------
% DE - drive end accelerometer data
% FE - fan end accelerometerd
% BA - base accelerometer data

% 098 : Normal data
% 131 : Outer crack
% 106 : Inner crack
% 119 : Ball fault

% TFT   : 기본 열 주파수
% BPFI  : 내륜 볼 통과 주파수
% BPFO  : 외륜 볼 통과 주파수
% BSF   : 볼 자전 주파수

% --------------------------- Bearing spec --------------------------------
% n     : # of ball           | value : 9 [n]
% fr    : shaft frequency     | value : 0.016667 * 1772 ( RPM to HZ * RPM )
% angle : contact angle       | value : 0 [deg]
% D     : pitch               | value : 39.04 [mm]
% d     : diameter of ball    | value : 7.94 [mm]
% -------------------------------------------------------------------------

addpath('../Bearingdata/');
addpath('../../Functions');

load('ball_007_1hp.mat');
load('inner_007_1hp.mat');
load('normal_1hp.mat');
load('outer_007_1hp.mat');

% Variable declaration
Fs = 12000;     % [Hz]
ncomb = 10;

Len = struct('X098', length(X098_DE_time), ...
             'X106', length(X106_DE_time), ...
             'X119', length(X119_DE_time), ...
             'X131', length(X131_DE_time) );

Spec = struct('n'    , 9               , ...
              'fr'   , 0.016667 * 1772 , ...
              'angle', 0               , ...
              'D'    , 39.04           , ...
              'd'    , 7.94            );

% cos value is 1 since contact angle is zero
Bearing_freq = struct('FTF' , (Spec.fr/2) * (1 - (Spec.d/Spec.D)), ...
                      'BPFO', (Spec.n * Spec.fr/2) * (1 - (Spec.d /Spec.D)), ...
                      'BPFI', (Spec.n * Spec.fr/2) * (1 + (Spec.d /Spec.D)), ...
                      'BSF' , (Spec.D/(2 * Spec.d)) * (1 - power((Spec.d/Spec.D),2)));


Time_features = struct('X098_DE', timeFeatures(X098_DE_time, "X098_DE"), ...
                       'X106_DE', timeFeatures(X106_DE_time, "X106_DE"), ...
                       'X119_DE', timeFeatures(X119_DE_time, "X119_DE"), ...
                       'X131_DE', timeFeatures(X131_DE_time, "X131_DE") );


Freq_features = struct('X098_DE', freqFeatures(X098_DE_time, "X098_DE"), ...
                       'X106_DE', freqFeatures(X106_DE_time, "X106_DE"), ...
                       'X119_DE', freqFeatures(X119_DE_time, "X119_DE"), ...
                       'X131_DE', freqFeatures(X131_DE_time, "X131_DE") );


Flen = struct('X098_DE', Fs * (0:(Len.X098/2))/Len.X098, ...
              'X106_DE', Fs * (0:(Len.X106/2))/Len.X106, ...
              'X119_DE', Fs * (0:(Len.X119/2))/Len.X119, ...
              'X131_DE', Fs * (0:(Len.X131/2))/Len.X131 );


FFT = struct('X098_DE', getFFT(X098_DE_time, Len.X098, Fs), ...
             'X106_DE', getFFT(X106_DE_time, Len.X106, Fs), ...
             'X119_DE', getFFT(X119_DE_time, Len.X119, Fs), ...
             'X131_DE', getFFT(X131_DE_time, Len.X131, Fs) );


time = struct('X098', (0 : Len.X098 - 1)/Fs, ...
              'X106', (0 : Len.X106 - 1)/Fs, ...
              'X119', (0 : Len.X119 - 1)/Fs, ...
              'X131', (0 : Len.X131 - 1)/Fs );


mergedTime = vertcat(Time_features.X098_DE, Time_features.X106_DE,Time_features.X119_DE, Time_features.X131_DE);

mergedFreq = vertcat(Freq_features.X098_DE, Freq_features.X106_DE, Freq_features.X119_DE, Freq_features.X131_DE);

%% TIME DOMAIN SIGNAL

figure(1);
plot(time.X098, X098_DE_time');
xlabel("Time [sec]");   ylabel("Acceleration [g]");   grid minor;   title("Normal data");        
xlim([0 0.3]);   ylim([-0.3 0.3]);

figure(2);
plot(time.X131, X131_DE_time');
xlabel("Time [sec]");   ylabel("Acceleration [g]");   grid minor;   title("Outer crack data");        
xlim([0 0.2]);   ylim([-4 4]);

figure(3);
plot(time.X106, X106_DE_time');
xlabel("Time [sec]");   ylabel("Acceleration [g]");   grid minor;   title("Inner crack data");        
xlim([0 0.06]);   ylim([-1.8 1.8]);

figure(4);
plot(time.X119, X119_DE_time');
xlabel("Time [sec]");   ylabel("Acceleration [g]");   grid minor;   title("Ball fault data");        
xlim([0 0.05]);   ylim([-0.5 0.5]);


%% TIME-DOMAIN FEATURES

class = {'Normal', 'Outer crack', 'Inner crack', 'Ball fault'};
barX = categorical(class, class);

stdY = [Time_features.X098_DE.std, Time_features.X131_DE.std, Time_features.X106_DE.std, Time_features.X119_DE.std];
rmsY = [Time_features.X098_DE.rms, Time_features.X131_DE.rms, Time_features.X106_DE.rms, Time_features.X119_DE.rms];
ifY = [Time_features.X098_DE.if, Time_features.X131_DE.if, Time_features.X106_DE.if, Time_features.X119_DE.if];
skewnessY = [Time_features.X098_DE.sk, Time_features.X131_DE.sk, Time_features.X106_DE.sk, Time_features.X119_DE.sk];

figure(1);
bar(barX, stdY, 'facecolor', [0.1 0.6 0.7]);
title('STD'); grid minor;   

figure(2);
bar(barX, rmsY, 'facecolor', [0.1 0.6 0.7]);
title('RMS'); grid minor;     

figure(3);
bar(barX, ifY, 'facecolor', [0.1 0.6 0.7]);
title('Impulse factor'); grid minor;     

figure(4);
bar(barX, skewnessY, 'facecolor', [0.1 0.6 0.7]);
title('Skewness'); grid minor;     

%% PSD : power spectrum density

figure()
[psdF098, psdX098_DE] = getPSD(X098_DE_time, Len.X098, Fs, 'log');
plot(psdF098(1:end-2)', psdX098_DE, 'b-', Linewidth = 0.05);
grid minor; xlabel("frequency [hz]");   ylabel("PSD [dB]");     title("PSD of normal data");

figure()
[psdF131, psdX131_DE] = getPSD(X131_DE_time, Len.X131, Fs, 'log');
plot(psdF131(1:end-2)', psdX131_DE, 'b-', Linewidth = 0.05);
grid minor; xlabel("frequency [hz]");   ylabel("PSD [dB]");     title("PSD of outer crack data");

figure()
[psdF119, psdX119_DE] = getPSD(X119_DE_time, Len.X119, Fs, 'log');
plot(psdF119(1:end-2)', psdX119_DE, 'b-', Linewidth = 0.05);
grid minor; xlabel("frequency [hz]");   ylabel("PSD [dB]");     title("PSD of inner crack data");

figure()
[psdF106, psdX106_DE] = getPSD(X106_DE_time, Len.X106, Fs, 'log');
plot(psdF106(1:end-2)', psdX106_DE, 'b-', Linewidth = 0.05);
grid minor; xlabel("frequency [hz]");   ylabel("PSD [dB]");     title("PSD of ball fault data");


%% FFT result / Frequency domain features

figure(1)
plot(Flen.X098_DE, FFT.X098_DE);
xlabel("frequency [hz]");   ylabel("Mag");  title("FFT result of normal data"); grid minor;

freq_X098 = freqFeatures(X098_DE_time, "X098");
xlim([0 3000]);

figure(2)
plot(Flen.X131_DE, FFT.X131_DE);
xlabel("frequency [hz]");   ylabel("Mag");  title("FFT result of Outer crack data"); grid minor;

freq_X131 = freqFeatures(X131_DE_time, "X131");

figure(3)
plot(Flen.X106_DE, FFT.X106_DE);
xlabel("frequency [hz]");   ylabel("Mag");  title("FFT result of Inner crack data"); grid minor;
xlim([0 5000]);

freq_X106 = freqFeatures(X106_DE_time, "X106");

figure(4)
plot(Flen.X119_DE, FFT.X119_DE);
xlabel("frequency [hz]");   ylabel("Mag");  title("FFT result of Ball fault data"); grid minor;

freq_X119 = freqFeatures(X119_DE_time, "X119");

class = {'Normal', 'Outer crack', 'Inner crack', 'Ball fault'};
barX = categorical(class, class);

rmsfY = [Freq_features.X098_DE.rmsf, Freq_features.X131_DE.rmsf, Freq_features.X106_DE.rmsf, Freq_features.X119_DE.rmsf];
rvfY = [Freq_features.X098_DE.rvf, Freq_features.X131_DE.rvf, Freq_features.X106_DE.rvf, Freq_features.X119_DE.rvf];

figure(5);
bar(barX, rmsfY, 'facecolor', [0.1 0.6 0.7]);
title('rmsf'); grid minor;   

figure(6);
bar(barX, rvfY, 'facecolor', [0.1 0.6 0.7]);
title('rvf'); grid minor;   


%% STFT 

figure(1)
stft(X098_DE_time, Fs, 'Window', hamming(6000,'periodic'), 'OverlapLength', 128,'FrequencyRange','onesided');
colormap jet

figure(2)
[S,F,T] = stft(X098_DE_time,Fs, 'Window', hamming(6000,'periodic'), "OverlapLength", 128,'FrequencyRange','onesided');
waterfall(F,T,abs(S)');
helperGraphicsOpt(1);
title("STFT of normal data");

figure(3)
stft(X131_DE_time, Fs, 'Window', hamming(6000,'periodic'), 'OverlapLength', 128,'FrequencyRange','onesided');
colormap jet

figure(4)
[S,F,T] = stft(X131_DE_time,Fs, 'Window', hamming(6000,'periodic'), "OverlapLength", 128,'FrequencyRange','onesided');
waterfall(F,T,abs(S)');
helperGraphicsOpt(1);
title("STFT of Outer crack data");

figure(5)
stft(X106_DE_time, Fs, 'Window', hamming(6000,'periodic'), 'OverlapLength', 128,'FrequencyRange','onesided');
colormap jet

figure(6)
[S,F,T] = stft(X106_DE_time,Fs, 'Window', hamming(6000,'periodic'), "OverlapLength", 128,'FrequencyRange','onesided');
waterfall(F,T,abs(S)');
helperGraphicsOpt(1);
title("STFT of Inner crack data");

figure(7)
stft(X119_DE_time, Fs, 'Window', hamming(6000,'periodic'), 'OverlapLength', 128,'FrequencyRange','onesided');
colormap jet

figure(8)
[S,F,T] = stft(X119_DE_time,Fs, 'Window', hamming(6000,'periodic'), "OverlapLength", 128,'FrequencyRange','onesided');
waterfall(F,T,abs(S)');
helperGraphicsOpt(1);
title("STFT of Ball fault data");


%% Envelop extraction & Power spectrum - power spectrum of envelop signal

[pEnvNormal, fEnvNormal, xEnvNormal, tEnvNormal] = envspectrum(X098_DE_time, Fs);
[pEnvOuter, fEnvOuter, xEnvOuter, tEnvOuter] = envspectrum(X131_DE_time, Fs);
[pEnvInner, fEnvInner, xEnvInner, tEnvInner] = envspectrum(X106_DE_time, Fs);
[pEnvBall, fEnvBall, xEnvBall, tEnvBall] = envspectrum(X119_DE_time, Fs);

Envelop(1).value = pEnvNormal;  Envelop(2).value = fEnvNormal;   Envelop(3).value = xEnvNormal;     Envelop(4).value = tEnvNormal;
Envelop(5).value = pEnvOuter;  Envelop(6).value = fEnvOuter;   Envelop(7).value = xEnvOuter;     Envelop(8).value = tEnvOuter;
Envelop(9).value = pEnvInner;  Envelop(10).value = fEnvInner;   Envelop(11).value = xEnvInner;     Envelop(12).value = tEnvInner;
Envelop(13).value = pEnvBall;  Envelop(14).value = fEnvBall;   Envelop(15).value = xEnvBall;     Envelop(16).value = tEnvBall;


tbllegend=[{'Normal'},{'Outer fault'},{'Inner fault'},{'Ball fault'}];

for idx = 1 : 4
   
    figure(idx)
    plot(Envelop((4*idx)).value, Envelop((4*idx)-1).value, 'b-', LineWidth = 2);
    
    legend(tbllegend(idx), FontSize = 14);
    xlabel('Time (s)'); ylabel('Acceleration (g)'); title('Envelope signal'); grid minor; 
    xlim([0 0.06]);

end


for idx = 1 : 4

    figure(idx + 4)
    plot(Envelop((4*idx-2)).value, Envelop((4*idx)-3).value, 'b-', LineWidth = 1.5);
    
    if idx == 1 

        helperPlotCombs(ncomb, Bearing_freq.FTF);
        xlim([0 Bearing_freq.FTF*ncomb])
    end

    if idx == 2

        helperPlotCombs(ncomb, Bearing_freq.BPFO);
        xlim([0 Bearing_freq.BPFO*ncomb])
    end

    if idx == 3

        helperPlotCombs(ncomb, Bearing_freq.BPFI);
        xlim([0 Bearing_freq.BPFI*ncomb])
   end

   if idx == 4

        helperPlotCombs(ncomb, Bearing_freq.BSF);
        xlim([0 Bearing_freq.BSF*ncomb])
   end
    
    legend(tbllegend(idx), FontSize = 14);
    xlabel("Frequency [hz]"); ylabel("Peak amplitude"); title("Envelope Spectrum"); grid minor;

end


figure(9)
plot(Envelop((8)).value, Envelop(7).value, 'b-', LineWidth = 2);
hold on;
plot(time.X131, X131_DE_time');
xlim([0 0.06]);

%%  Kurtogram

level = 9;
figure()
kurtogram(X098_DE_time, Fs, level);
[~, ~, ~, fcNorm, wcNorm, BWNorm] = kurtogram(X098_DE_time, Fs);
figure()
pkurtosis(X098_DE_time, Fs, wcNorm);
title("Normal data");
helperSpectrogramAndSpectralKurtosis(X098_DE_time, Fs, level);

level = 5;
figure()
kurtogram(X131_DE_time, Fs, level);
[~, ~, ~, fcOut, wcNorm, BWOut] = kurtogram(X131_DE_time, Fs);
figure()
pkurtosis(X131_DE_time, Fs, wcNorm);
title("Outer data");
helperSpectrogramAndSpectralKurtosis(X131_DE_time, Fs, level);

level = 7;
figure()
kurtogram(X106_DE_time, Fs, level);
[~, ~, ~, fcIn, wcNorm, BWIn] = kurtogram(X106_DE_time, Fs);
figure()
pkurtosis(X106_DE_time, Fs, wcNorm);
title("Inner data");
helperSpectrogramAndSpectralKurtosis(X106_DE_time, Fs, level);

level = 9;
figure()
kurtogram(X119_DE_time, Fs, level);
[~, ~, ~, fcBall, wcNorm, BWBall] = kurtogram(X119_DE_time, Fs);
figure()
pkurtosis(X119_DE_time, Fs, wcNorm);
title("Ball data");
helperSpectrogramAndSpectralKurtosis(X119_DE_time, Fs, level);


%% Filter design and its application for appripriate Kurtogram
% All fault data except ball fault

bpfBall = designfilt('bandpassfir', 'FilterOrder', 4, 'CutoffFrequency1', fcBall-BWBall/2, ...
                 'CutoffFrequency2', fcBall+BWBall/2, 'SampleRate', Fs);

xOuterBpf = filter(bpfBall, X119_DE_time);
[pBall, Fball, xBall, tBall] = envelopExtract(xOuterBpf, Fs);

figure(1);
plot(time.X119, X119_DE_time', LineWidth = 1);
hold on;    grid minor;     xlim([0 0.06]);
plot(tEnvBall, xEnvBall, LineWidth = 2);
title("Envelop of raw signal : Ball fault");
legend('Raw signal','Envelop');

figure(2);
plot(time.X119, xOuterBpf, LineWidth = 1);
hold on;    grid minor;     xlim([0.005 0.06]);
plot(tBall, xBall, LineWidth = 2);
title("Envelop of filtered signal : Ball fault");
legend('filtered signal','Envelop');

figure(3);
plot(Fball, pBall, LineWidth = 2);
helperPlotCombs(ncomb, Bearing_freq.BSF);
xlim([0 Bearing_freq.BSF*ncomb]);   grid minor;     title("FFT of filtered signal envelop");        legend('FFT', 'BSF');