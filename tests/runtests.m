%RUNTESTS
    %   Description: Script to exercise tests.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Version: 1
    %       (2/25/2017) Initial commit.

%% Execute qammodulator Tests
qammodulatorTests = matlab.unittest.TestSuite.fromClass(?qammodulatorTest);
qammodulatorResult = run(qammodulatorTests);

%% Execute qamdemodulator Tests
qamdemodulatorTests = matlab.unittest.TestSuite.fromClass(?qammodulatorTest);
qamdemodulatorResult = run(qamdemodulatorTests);