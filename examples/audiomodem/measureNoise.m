function [pwr] = measureNoise(sps)
    % Symbol generation
    L = 2000;
    Fs = 44.1e3;
    sps = sps;
    txSig = zeros(1, L*sps);
    
    % Play and record
    chSig = playrecord(txSig, Fs);

    % Measure noise
    pwr = 10*log10(mean(abs(chSig).^2));
end