%QAMMOD
    %   Description: Class to model QAM modulator.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Changelog:
    %     (2/25/2017) Initial commit.
    %     (2/25/2017) Implemented Modulate method.
    %     (2/25/2017) Removed bistream transpose.
    %     (2/26/2017) Updated base class references.

classdef qammod < comms.digital.qam & comms.modem.basemodulator
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
            
            mappings = bi2de(reshape(bitstream, [log2(obj.M), numel(bitstream) / log2(obj.M)])', 'left-msb');
            symbols = obj.Constellation(obj.SymbolMapping(mappings + 1) + 1); % Mappings incremented to index at start of 1
        end
    end
%% Public Methods
end