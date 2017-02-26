%TESTQAMMODULATOR
    %   Description: Test class for QAM modulator.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Version: 1
    %       (2/25/2017) Initial commit.
    %   Version: 2
    %       (2/25/2017) Implemented and tested Modulate test method.

classdef qammodulatorTest < matlab.unittest.TestCase
%% Test Methods
    methods (Test)
        function ModulateTest(testCase)
            modulator = qammodulator();
            modulator.M = 4;
            modulator.SymbolOrder = 'Binary';
            bitstream = [0 1 0 0 1 0 1 1]';
            actSolution = modulator.Modulate(bitstream);
            expSolution = modulator.Constellation([2 1 3 4]);
            testCase.verifyEqual(actSolution, expSolution);
        end
    end
%% Test Methods
end