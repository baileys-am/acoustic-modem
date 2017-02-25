%TESTQAMDEMODULATOR
    %   Description: Test class for QAM demodulator.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Version: 1
    %       (2/25/2017) Initial commit.

classdef qamdemodulatorTest < matlab.unittest.TestCase
%% Test Methods
    methods (Test)
        function DeodulateTest(testCase)
            demodulator = qamdemodulator();
            symbols = [1+1i -1+1i -1-1i 1-1i];
            actSolution = demodulator.Demodulate(symbols);
            expSolution = [0 1 0 0 1 0 1 1];
            testCase.verifyEqual(actSolution, expSolution);
        end
    end
%% Test Methods
end