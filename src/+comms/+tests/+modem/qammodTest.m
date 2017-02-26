%QAMMODTEST
    %   Description: Test class for QAM modulator.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Changelog:
    %     (2/25/2017) Initial commit.
    %     (2/25/2017) Implemented and tested Modulate test method.

classdef qammodTest < matlab.unittest.TestCase
%% Test Methods
    methods (Test)
        function ModulateTest(testCase)
            modulator = comms.modem.qammod;
            modulator.M = 4;
            modulator.SymbolOrder = 'Binary';
            bitstream = [0 1 0 0 1 0 1 1 0 0 1 0]';
            actSolution = modulator.Modulate(bitstream);
            expSolution = modulator.Constellation([2 1 3 4 1 3]);
            testCase.verifyEqual(actSolution, expSolution);
        end
    end
%% Test Methods
end