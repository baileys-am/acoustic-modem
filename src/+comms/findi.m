%FINDI
    %   Description: Gets the indicies of the elements in a match vector
    %   found in a random vector containing the match elements.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 3/12/2017
    %   Changelog:
    %     (3/12/2017) Initial commit

function y = findi(match, x)
    y = mod(find((match == x)')', numel(match));
    y(y == 0) = numel(match);
end
