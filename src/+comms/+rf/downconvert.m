function [y] = downconvert(signal, f0, Fs)
    y = signal.*exp(-2i*pi*f0*(0:length(signal)-1)/Fs);
end