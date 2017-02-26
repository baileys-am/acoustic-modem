%MODEMTEST
    %   Description: Test class for modem.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/26/2017
    %   Version: 1
    %       (2/26/2017) Initial commit.
    
classdef modemTest < matlab.unittest.TestCase
%% Test Methods
    methods (Test)
        function SetModulatorTest(testCase)
            M = 16;
            modulator = qammodulator();
            modulator.M = M;
            m = modem();
            
            % Set and verify modulator
            expSolution = modulator;
            m.Modulator = modulator;
            actSolution = m.Modulator;
            testCase.verifyEqual(actSolution, expSolution);
        end
        
        function SetDemodulatorTest(testCase)
            M = 16;
            demodulator = qamdemodulator();
            demodulator.M = M;
            m = modem();
            
            % Set and verify modulator
            expSolution = demodulator;
            m.Demodulator = demodulator;
            actSolution = m.Demodulator;
            testCase.verifyEqual(actSolution, expSolution);
        end
    end
%% Test Methods
end

