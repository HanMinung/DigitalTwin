%   Usage : function to get power spectrum density

%   type : normal | log
%   x : signal
%   L : data of size of discrete signal
%   Fs : sampling frequency

function [f, psdx] = getPSD(x,L,Fs, type)

    Y = fft(x,L);
    P2 = abs(Y);
    f = Fs * (0:(L/2))/L; 

    psdx = (1/(Fs*L)) * P2(1:L/2+1).^2;
    ret = 2 * psdx(2:end-1);

    if type == "normal"
        
        psdx = ret;
    end

    if type == "log"

        psdx = 10 * log10(ret);
    end

end