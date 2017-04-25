function [y, zk, ck, ek] = lmsle(input, u, nw, modem, trainSyms)
    Ltrain = numel(trainSyms);
    Lsyms = numel(input);
    
    ck = zeros(Lsyms+1, nw);
    ek = zeros(1, Lsyms);
    zk = zeros(1, Lsyms);
    rk = zeros(1, nw);
    y = zeros(1, Lsyms);
    
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