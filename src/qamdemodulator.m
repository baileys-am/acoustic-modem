%QAMDEMODULATOR
    %   Description: Class to model QAM demodulator.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Version: 1
    %       (2/25/2017) Initial commit.
    %   Version: 2
    %       (2/25/2017) Implemented Demodulate method.

classdef qamdemodulator < qam & demodulator
%% Public Methods
    methods
        % Demodulates bitstream into mapped symbol alphabet
        function bitstream = Demodulate(obj, symbols)
            [m, n] = size(symbols);
            if (m == 1 || n == 1)
                if (m == 1)
                    % Make it a row vector
                    symbols = symbols.';
                end
            else
                error('Symbols must be a row or column vector');
            end
            
            constellationMat = repmat(obj.Constellation, [numel(symbols), 1]);
            mappingsMat = min(symbols - constellationMat, 1);
            [mappings, ~] = find(mappingsMat' == 0);
            symbolDecisions = obj.SymbolMapping(mappings);
            bitstream = reshape(de2bi(symbolDecisions, 'left-msb')', [1, numel(symbolDecisions) * log2(obj.M)]);
        end
    end
%% Public Methods
end