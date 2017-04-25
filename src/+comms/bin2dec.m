%BIN2DEC
    %   Description: Converts binary to decimal.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 3/12/2017
    %   Changelog:
    %     (3/12/2017) Initial commit

function dec = bin2dec(bin, N)
    bin = reshape(bin, [N, numel(bin)/N]);
    dec = sum(2.^(N-1:-1:0)' .* bin);
end
