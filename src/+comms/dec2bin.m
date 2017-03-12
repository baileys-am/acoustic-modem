%DEC2BIN
    %   Description: Converts decimal to binary.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 3/12/2017
    %   Changelog:
    %     (3/12/2017) Initial commit
    
function bin = dec2bin(dec, N)
    Nmin = ceil(log2(max(dec)));
    if (N < Nmin)
        N = Nmin;
    end
    
    bin = zeros(N, numel(dec));
    for i = 1:N
        bin(i,:) = dec / 2^(N-i) >= 1;
        dec = dec - bin(i,:) * 2^(N-i);
    end
    bin = reshape(bin, [1, numel(bin)]);
end