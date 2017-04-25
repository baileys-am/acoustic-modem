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

classdef qammodem < comms.modem.basemodem
%% Properties
    properties
        Alphabet = comms.digital.qam       % QAM Alphabet class
    end
%% Properties

%% Public Methods
    methods
        % M Get Accessor
        function Alphabet = get.Alphabet(obj)
            Alphabet = obj.Alphabet;
        end

        % M Set Accessor
        function obj = set.Alphabet(obj, val)
            if (~isa(val, 'comms.digital.qam'))
                error('Alphabet must be of type "comms.digital.qam".');
            end
            obj.Alphabet = val;
        end
        
        % Modulates a bit/integer stream into symbol stream
        function symbols = Modulate(obj, input)          
            [m, n] = size(input);
            if ~(m == 1 || n == 1)
                error('Bitstream must be a row or column vector');
            end
                        
            if (strcmpi(obj.DataType, 'bit'))
                if (mod(length(input), log2(obj.Alphabet.M)) ~= 0)
                    error('Bitstream length must be divisible by log2(M)');
                end
                symbolIndx = comms.bin2dec(input, log2(obj.Alphabet.M));
            elseif (strcmpi(obj.DataType, 'integer'))
                symbolIndx = input;
            else
                error(['Unsupported DataType: ' obj.DataType]);
            end
            
            mapping = comms.findi(obj.Alphabet.SymbolMapping, symbolIndx);
            symbols = obj.Alphabet.Constellation(mapping);
        end
        
        % Demodulates symbol stream into bit/integer stream
        function output = Demodulate(obj, symbols)
            [m, n] = size(symbols);
            if (m == 1 || n == 1)
                if (m == 1)
                    % Make it a row vector
                    symbols = symbols.';
                end
            else
                error('Symbols must be a row or column vector');
            end
            
            symbolsMat = repmat(symbols, [1, numel(obj.Alphabet.Constellation)]);
            [~, mapping] = min(abs(symbolsMat - obj.Alphabet.Constellation).');
            
            if (strcmpi(obj.DataType, 'bit'))
                output = comms.dec2bin(obj.Alphabet.SymbolMapping(mapping), log2(obj.Alphabet.M));
            elseif (strcmpi(obj.DataType, 'integer'))
                output = obj.Alphabet.SymbolMapping(mapping);
            else
                error(['Unsupported DataType: ' obj.DataType]);
            end
        end
    end
%% Public Methods
end