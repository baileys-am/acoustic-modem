%RUNTESTS
    %   Description: Script to exercise tests.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Version: 1
    %       (2/25/2017) Initial commit.
    %   Version: 2
    %       (2/25/2017) Added QAM base class test. Fixed qamdemodulator
    %       test call.

%% Execute qam Tests
qamTests = matlab.unittest.TestSuite.fromClass(?qamTest);
qamResult = run(qamTests);

%% Execute qammodulator Tests
qammodulatorTests = matlab.unittest.TestSuite.fromClass(?qammodulatorTest);
qammodulatorResult = run(qammodulatorTests);

%% Execute qamdemodulator Tests
qamdemodulatorTests = matlab.unittest.TestSuite.fromClass(?qamdemodulatorTest);
qamdemodulatorResult = run(qamdemodulatorTests);