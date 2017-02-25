%QAMDEMODULATOR
    %   Description: Class to model QAM demodulator.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Version: 1
    %       (2/25/2017) Initial commit.

classdef qamdemodulator < qam & demodulator
%% Public Methods
    methods
        % Demodulates bitstream into mapped symbol alphabet
        function bitsteam = Demodulate(obj, symbols)
            error('qamdemodulator.Demodulate not implemented');
        end
    end
%% Public Methods
end