%QAMTEST
    %   Description: Test class for QAM base class.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Changelog:
    %     (2/25/2017) Initial commit.
    %     (2/28/2017) SetMTest validates multiple M.

classdef qamTest < matlab.unittest.TestCase
%% Test Methods
    methods (Test)
        function SetMTest(testCase)
            Mrange = 2.^(2:2:8);
            A = comms.digital.qam;
            
            for i = 1:numel(Mrange)
                M = Mrange(i);
                A.M = M;
                
                % Verify modulation order
                expSolution = M;
                actSolution = A.M;
                testCase.verifyEqual(actSolution, expSolution);
                
                % Verify symbol mapping size
                expSolution = M;
                actSolution = numel(A.SymbolMapping);
                testCase.verifyEqual(actSolution, expSolution);

                % Verify constellation size
                expSolution = M;
                actSolution = numel(A.Constellation);
                testCase.verifyEqual(actSolution, expSolution);
            end
        end
        
        function SetSymbolOrderTest(testCase)
            M = 4;
            symbolOrder = 'Binary';
            symbolMapping = 0:M-1;
            A = comms.digital.qam;
            
            % Set and verify SymbolOrder
            expSolution = symbolOrder;
            A.SymbolOrder = symbolOrder;
            actSolution = A.SymbolOrder;
            testCase.verifyEqual(actSolution, expSolution);
            
            % Verify symbol mapping
            A.M = M;
            expSolution = symbolMapping;
            actSolution = A.SymbolMapping;            
            testCase.verifyEqual(actSolution, expSolution);
        end
        
        function GetRandomSymbolsTest(testCase)
            Nsym = 500;
            A = comms.digital.qam;
            
            % Verify vector length
            expSolution = Nsym;
            actSolution = length(A.GetRandomSymbols(Nsym));
            testCase.verifyEqual(actSolution, expSolution);
            
            % Verify symbols exist in constellation
            expSolution = true;
            actSolution = all(ismember(A.GetRandomSymbols(Nsym), A.Constellation));            
            testCase.verifyEqual(actSolution, expSolution);
        end
    end
%% Test Methods
end