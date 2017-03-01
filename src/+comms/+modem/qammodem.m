%QAMMODEM
    %   Description: Class to model QAM modem.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Changelog:
    %     (2/25/2017) Initial commit.
    %     (2/25/2017) Implemented Modulate/Demodulate method.
    %     (2/25/2017) Removed bistream transpose.
    %     (2/26/2017) Updated base class references.
    %     (2/28/2017) Merged qammodulator and qamdemodulator.

classdef qammodem < comms.digital.qam & comms.modem.basemodem
%% Public Methods
    methods
        % Modulates a bit stream into mapped symbols
        function symbols = Modulate(obj, bitstream)          
            [m, n] = size(bitstream);
            if ~(m == 1 || n == 1)
                error('Bitstream must be a row or column vector');
            end
            if (mod(length(bitstream), log2(obj.M)) ~= 0)
                error('Bitstream length must be divisible by log2(M)');
            end
            
            % Mappings incremented to index at start of 1
            mappings = bi2de(reshape(bitstream, [log2(obj.M), numel(bitstream) / log2(obj.M)])', 'left-msb');
            symbols = obj.Constellation(obj.SymbolMapping(mappings + 1) + 1);
        end
        
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