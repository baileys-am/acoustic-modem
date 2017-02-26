%QAMTEST
    %   Description: Test class for QAM base class.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Changelog:
    %     (2/25/2017) Initial commit.

classdef qamTest < matlab.unittest.TestCase
%% Test Methods
    methods (Test)
        function SetMTest(testCase)
            M = 4;
            A = comms.digital.qam;
            
            % Set and verify M
            expSolution = M;
            A.M = M;
            actSolution = A.M;
            testCase.verifyEqual(actSolution, expSolution);
            
            % Verify length of constellation
            expSolution = M;
            actSolution = length(A.Constellation);            
            testCase.verifyEqual(actSolution, expSolution);
        end
        
        function SetSymbolOrderTest(testCase)
            symbolOrder = 'Binary';
            symbolMapping = 0:3;
            A = comms.digital.qam;
            
            % Set and verify SymbolOrder
            expSolution = symbolOrder;
            A.SymbolOrder = symbolOrder;
            actSolution = A.SymbolOrder;
            testCase.verifyEqual(actSolution, expSolution);
            
            % Verify symbol mapping
            expSolution = symbolMapping;
            actSolution = A.SymbolMapping;            
            testCase.verifyEqual(actSolution, expSolution);
        end
        
        function GetRandomSymbolsTest(testCase)
            L = 500;
            A = comms.digital.qam;
            
            % Verify vector length
            expSolution = L;
            actSolution = length(A.GetRandomSymbols(L));
            testCase.verifyEqual(actSolution, expSolution);
            
            % Verify symbols exist in constellation
            expSolution = true;
            actSolution = all(ismember(A.GetRandomSymbols(L), A.Constellation));            
            testCase.verifyEqual(actSolution, expSolution);
        end
    end
%% Test Methods
end