% LMS Linear Equalizer Algorithm
function [y, zk, ck, ek] = lmsle(input, u, nw, modem, trainSyms)
    Ltrain = numel(trainSyms);
    Lsyms = numel(input);
    
    ck = zeros(Lsyms+1, nw); % Forward coefficients
    ek = zeros(1, Lsyms); % Error signal
    zk = zeros(1, Lsyms); % Estimated output
    rk = zeros(1, nw); % Recieve taps
    y = zeros(1, Lsyms); % Output
    
    for i = 1:Lsyms
        rk = [input(i) rk(1:end-1)];
        zk(i) = ck(i,:) * rk.';
        d = modem.Modulate(modem.Demodulate(zk(i)));
        y(i) = d;
        
        if (i<=Ltrain)
            ek(i) = zk(i) - trainSyms(i);
        else
            ek(i) = zk(i) - d;
        end
        
        ck(i+1,:) = ck(i,:) - u * ek(i) * conj(rk);
    end
    
    y = y(1+Ltrain:end);
end