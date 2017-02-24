% Author: Steven Cantrell
% Date Created: 2/22/2017
% Description: Class to model modulation/demodulation of a modem
classdef modem
    properties
        M = 64;                 % QAM alphabet size
        Alphabet = [];          % QAM alphabet
    end
    
    methods
        %% Property Accessors
        % Setter method for M
        function obj = set.M(obj, M)
            if mod(log2(M), 2) ~= 0
                error('log2(M) must be even')
            end
            obj.M = M;
        end
        
        % Getter method for Alphabet
        function A = get.Alphabet(obj)
            A = modem.qam(obj.M);
        end
    end
    
    methods(Static)
        % Creates QAM alphabet
        function qamA = qam(M)
            if mod(log2(M), 2) ~= 0
                error('log2(M) must be even')
            end
            pamA = [-1*log2(M)-1:2:-1, 1:2:1*log2(M)+1];
            qamA = repmat(pamA, length(pamA), 1) + 1i*repmat(flip(pamA)', 1, length(pamA));
        end
    end
end