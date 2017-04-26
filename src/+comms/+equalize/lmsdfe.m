% LMS Decision-Feedback Equalizer Algorithm
function [y, zk, fk, bk, ek] = lmsdfe(input, u, nw, bw, modem, trainSyms)
    Ltrain = numel(trainSyms);
    Lsyms = numel(input);
    
    fk = zeros(Lsyms+1, nw); % Forward coefficients
    bk = zeros(Lsyms+1, bw); % Feedback coefficients
    rk = zeros(1, nw); % Receive vector
    dk = zeros(1, bw); % Decision feedback vector
    ek = zeros(1, Lsyms); % Error signal
    zk = zeros(1, Lsyms); % Estimated output
    y = zeros(1, Lsyms); % Output

    for i = 1:Lsyms
        rk = [input(i) rk(1:end-1)];
        zk(i) = fk(i,:)*rk.' - bk(i,:)*dk.';
        d = modem.Modulate(modem.Demodulate(zk(i)));
        y(i) = d;
        
        if (i<=Ltrain)
            ek(i) = zk(i) - trainSyms(i);
        elseif (i > Ltrain)
            ek(i) = zk(i) - d;
        end
 
        fk(i+1,:) = fk(i,:) - u * ek(i) * conj(rk);
        bk(i+1,:) = bk(i,:) + u * ek(i) * conj(dk);
        dk = [d dk(1:end-1)];
    end
    
    y = y(1+Ltrain:end);
end