%TESTQAMMODULATOR
    %   Description: Test class for QAM modulator.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Version: 1
    %       (2/25/2017) Initial commit.

classdef qammodulatorTest < matlab.unittest.TestCase
%% Test Methods
    methods (Test)
        function ModulateTest(testCase)
            modulator = qammodulator();
            bitstream = [0 1 0 0 1 0 1 1];
            actSolution = modulator.Modulate(bitstream);
            expSolution = [1+1i -1+1i -1-1i 1-1i];
            testCase.verifyEqual(actSolution, expSolution);
        end
    end
%% Test Methods
end