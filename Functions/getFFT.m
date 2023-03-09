%   Usage : function to implement FFT of a signal (single side)

%   L : # sample of discrete signal
%   Fs : sampling time

%% version 1
function [f, mag] = getFFT(X,L,Fs)

    Y = fft(X,L);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
   
    P1(2:end-1) = 2 * P1(2:end-1);

    mag = P1;
    f = Fs * (0:(L/2))/L; 

end

%% version 2

% function freq = getFFT(X,L)
% 
%    Y = fft(X,L);
%    P2 = abs(Y/L);
%    P1 = P2(1:L/2+1);
%    
%    P1(2:end-1) = 2 * P1(2:end-1);
% 
%    freq = P1;
% 
% end