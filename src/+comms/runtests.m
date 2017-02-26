%RUNTESTS
    %   Description: Script to exercise tests.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Changelog:
    %     (2/25/2017) Initial commit.
    %     (2/25/2017) Added QAM base class test. Fixed qamdemodulator
    %       test call.
    %     (2/26/2017) Added modem tests.

%% Execute qam Tests
qamTests = matlab.unittest.TestSuite.fromClass(?comms.tests.digital.qamTest);
qamResult = run(qamTests);

%% Execute qammodulator Tests
qammodulatorTests = matlab.unittest.TestSuite.fromClass(?comms.tests.modem.qammodTest);
qammodulatorResult = run(qammodulatorTests);

%% Execute qamdemodulator Tests
qamdemodulatorTests = matlab.unittest.TestSuite.fromClass(?comms.tests.modem.qamdemodTest);
qamdemodulatorResult = run(qamdemodulatorTests);

%% Execute modem Tests
modemTests = matlab.unittest.TestSuite.fromClass(?comms.tests.modemTest);
modemResult = run(modemTests);