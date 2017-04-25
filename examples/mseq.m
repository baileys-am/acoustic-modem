function y = mseq(poly, state, Ncyc)
    L = length(state);
    Nbits = lcm(L, 2^L-1) * Ncyc;
    y = zeros(1, Nbits);
    poly = sort(poly);

    for i = 1:Nbits
        zk = state(poly);
        z = zk(end);
        for k = numel(zk)-1:-1:1
            z = xor(z, zk(k));
        end

        y(i) = state(end);
        state = [z state(1:end-1)];
    end
end