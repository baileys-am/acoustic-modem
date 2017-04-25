%SYNCHRONIZATION
    %   Description: Tests synchronization using COMMS package
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 3/18/2017
    %   Changelog:
    %     (3/18/2017) Initial commit.

close all;
clear;

% Variables
M = 4;
SymbolOrder = 'Grey';
Ltrain = 100;
Nbits = 1000 * log2(M);
SymbolDelay = 500;

% Modem
m = comms.modem.qammodem;
m.M = M;
m.SymbolOrder = SymbolOrder;

% Data
training = randi([0 1], 1, Ltrain);
data = randi([0 1], 1, Nbits);

% Baseband complex envelope
t = m.Modulate(training);
s = m.Modulate(data);

% Delayed 
s = [zeros(1, SymbolDelay) t s];

% Training
s1 = s;
s2 = t;
[acor,lag] = xcorr(s2, s1);
[~,I] = max(abs(acor));
lagDiff = lag(I);
%timeDiff = lagDiff/Fs
figure; plot(lag,acor); a3 = gca; a3.XTick = sort([-3000:1000:3000 lagDiff]);
s1al = s1(-lagDiff+1:end);
r = s1al(1:length(s2));
figure;
subplot(2,1,1); plot(real(r)); title('Received Signal, Aligned');
subplot(2,1,2); plot(real(s2)); title('Training Sequency'); xlabel('Samples');
