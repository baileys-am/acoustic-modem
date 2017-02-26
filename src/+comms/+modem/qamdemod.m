%QAMDEMOD
    %   Description: Class to model QAM demodulator.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Changelog:
    %     (2/25/2017) Initial commit.
    %     (2/25/2017) Implemented Demodulate method.
    %     (2/26/2017) Updated base class references.

classdef qamdemod < comms.digital.qam & comms.modem.demodulator
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
            
            symbolsMat = repmat(symbols, [1, numel(obj.Constellation)]);
            [~, mappings] = min(abs(symbolsMat - obj.Constellation).');
            symbolDecisions = obj.SymbolMapping(mappings);
            bitstream = reshape(de2bi(symbolDecisions, 'left-msb')', [1, numel(symbolDecisions) * log2(obj.M)]);
        end
    end
%% Public Methods
end