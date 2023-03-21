function [P, F, X, T] = envelopExtract(X, Fs)

    [P, F, X, T] = envspectrum(X, Fs);

end