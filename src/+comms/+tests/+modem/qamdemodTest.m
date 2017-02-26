%QAMDEMODTEST
    %   Description: Test class for QAM demodulator.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Changelog:
    %     (2/25/2017) Initial commit.
    %     (2/25/2017) Implemented and tested Modulate test method.
    
classdef qamdemodTest < matlab.unittest.TestCase
%% Test Methods
    methods (Test)
        function DeodulateTest(testCase)
            demodulator = comms.modem.qamdemod;
            demodulator.M = 4;
            demodulator.SymbolOrder = 'Binary';
            symbols = demodulator.Constellation([2 1 3 4 2 3 1]);
            actSolution = demodulator.Demodulate(symbols);
            expSolution = [0 1 0 0 1 0 1 1 0 1 1 0 0 0];
            testCase.verifyEqual(actSolution, expSolution);
        end
    end
%% Test Methods
end