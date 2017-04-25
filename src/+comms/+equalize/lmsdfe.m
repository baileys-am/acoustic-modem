function [y, zk, fk, bk, ek] = lmsdfe(input, u, nw, bw, modem, trainSyms)
    Ltrain = numel(trainSyms);
    Lsyms = numel(input);
    
    fk = zeros(Lsyms+1, nw);
    bk = zeros(Lsyms+1, bw);
    rk = zeros(1, nw);
    dk = zeros(1, bw);
    ek = zeros(1, Lsyms);
    zk = zeros(1, Lsyms);
    y = zeros(1, Lsyms);

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