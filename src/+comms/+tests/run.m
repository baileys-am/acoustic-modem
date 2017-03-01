%RUN
    %   Description: Script to exercise tests.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Changelog:
    %     (2/25/2017) Initial commit.
    %     (2/25/2017) Added QAM base class test. Fixed qamdemodulator
    %       test call.
    %     (2/26/2017) Added modem tests.
    %     (2/28/2017) Updated tests to reflect modem merge.
    %     (2/28/2017) Added clear/close statement.

clear; close all;
    
%% Execute qam Tests
qamTests = matlab.unittest.TestSuite.fromClass(?comms.tests.digital.qamTest);
qamResult = run(qamTests);

%% Execute qammodem Tests
qammodemTests = matlab.unittest.TestSuite.fromClass(?comms.tests.modem.qammodemTest);
qammodemResult = run(qammodemTests);