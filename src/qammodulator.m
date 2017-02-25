%QAMMODULATOR
    %   Description: Class to model QAM modulator.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Version: 1
    %       (2/25/2017) Initial commit.

classdef qammodulator < qam & modulator
%% Public Methods
    methods
        % Modulates a bit stream into mapped symbols
        function symbols = Modulate(obj, bitstream)
            error('qammodulator.Modulate not implemented');
        end
    end
%% Public Methods
end