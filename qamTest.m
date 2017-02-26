%TESTQAMMODULATOR
    %   Description: Test class for QAM base class.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Version: 1
    %       (2/25/2017) Initial commit.

classdef qamTest < matlab.unittest.TestCase
%% Test Methods
    methods (Test)
        function SetMTest(testCase)
            M = 4;
            modulator = qammodulator();
            
            % Set and verify M
            expSolution = M;
            modulator.M = M;
            actSolution = modulator.M;
            testCase.verifyEqual(actSolution, expSolution);
            
            % Verify length of constellation
            expSolution = M;
            actSolution = length(modulator.Constellation);            
            testCase.verifyEqual(actSolution, expSolution);
        end
        
        function SetSymbolOrderTest(testCase)
            symbolOrder = 'Binary';
            symbolMapping = 0:3;
            modulator = qammodulator();
            
            % Set and verify SymbolOrder
            expSolution = symbolOrder;
            modulator.SymbolOrder = symbolOrder;
            actSolution = modulator.SymbolOrder;
            testCase.verifyEqual(actSolution, expSolution);
            
            % Verify symbol mapping
            expSolution = symbolMapping;
            actSolution = modulator.SymbolMapping;            
            testCase.verifyEqual(actSolution, expSolution);
        end
    end
%% Test Methods
end