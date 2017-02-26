%QAMTEST
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
            m = qam();
            
            % Set and verify M
            expSolution = M;
            m.M = M;
            actSolution = m.M;
            testCase.verifyEqual(actSolution, expSolution);
            
            % Verify length of constellation
            expSolution = M;
            actSolution = length(m.Constellation);            
            testCase.verifyEqual(actSolution, expSolution);
        end
        
        function SetSymbolOrderTest(testCase)
            symbolOrder = 'Binary';
            symbolMapping = 0:3;
            m = qam();
            
            % Set and verify SymbolOrder
            expSolution = symbolOrder;
            m.SymbolOrder = symbolOrder;
            actSolution = m.SymbolOrder;
            testCase.verifyEqual(actSolution, expSolution);
            
            % Verify symbol mapping
            expSolution = symbolMapping;
            actSolution = m.SymbolMapping;            
            testCase.verifyEqual(actSolution, expSolution);
        end
        
        function GetRandomSymbolsTest(testCase)
            L = 500;
            m = qam();
            
            % Verify vector length
            expSolution = L;
            actSolution = length(m.GetRandomSymbols(L));
            testCase.verifyEqual(actSolution, expSolution);
            
            % Verify symbols exist in constellation
            expSolution = true;
            actSolution = all(ismember(m.GetRandomSymbols(L), m.Constellation));            
            testCase.verifyEqual(actSolution, expSolution);
        end
    end
%% Test Methods
end