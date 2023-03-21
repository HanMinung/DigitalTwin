% function to get the effect of Hilbert transformation

% Return value :
% 
% (1st) ifft result : real part + imaginary part  
% (2nd) absolute value of 1st return value

function [z, inst_amplitude] = analyticSignal(x) 

    x = x(:); 
    N = length(x);

    [f, X] = getFFT(x,N, fs);

    P = X;        

    z = ifft(P, N);       

    inst_amplitude = abs(z); 

end