%AWGNQAMBER
    %   Description: Script that models QAM in an AWGN channel to calculate
    %   simulated BER and theoretical BER. 
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/26/2017
    %   Changelog:
    %     (2/27/2017) Initial commit.
    %     (2/28/2017) Updates for qammodem merge.

%% Settings
% Define simulation settings.
%     QAM Order, M = 64
%     Bit energy to noise power range, EbN0s = 0:2:16
%     Simulation Trials, Ntrials = 1000
%     Number of bits, Nbits = 100000 * bitsPerSymbol
M = 64;
EbN0s = 0:2:16;
Ntrials = 1;
Nbits = 1000000 * log2(M);

%% Modulator
% Define QAM modem
%     Modulation order, M = 64
%     Symbol order, SymbolOrder = 'Binary'
m = comms.modem.qammodem;
m.M = M;

%% Channel
% Define AWGN channel
ch = comms.channel.awgn;

%% Monte Carlo Simulation
BERs = zeros(size(EbN0s));
for nebn0 = 1:numel(EbN0s)
    %% Perform trials
    nbers = zeros(1, Ntrials);
    for ntrial = 1:Ntrials
        %% Input
        % Create input bitstream.
        txBitstream = randi([0 1], 1, Nbits);

        %% Modulate
        % Creates modulated complex baseband signal.
        txSignal = m.Modulate(txBitstream);

        %% Channel
        % Apply AWGN to transmitted signal.
        ch.SNR = EbN0s(nebn0) + 10*log10(log2(M));
        rxSignal = ch.Propagate(txSignal);

        %% Demodulate
        % Demodulate received complex baseband signal.
        rxBitstream = m.Demodulate(rxSignal);

        %% BER
        % Calculate and store BER.
        nbers(ntrial) = sum(txBitstream ~= rxBitstream) / numel(txBitstream);
    end
    
    %% SNR vs BER
    % Store BER for SNR trial.
    BERs(nebn0) = mean(nbers);
end

%% Plot Results
% Plot Simulation
figure;
semilogy(EbN0s, BERs);
hold on;

% Plot Theoretical
k = log2(M);
linEbN0s=10.^(EbN0s/10);
Pb=(4/k)*(1-1/sqrt(M))*(1/2)*erfc(sqrt(3/2*k*linEbN0s/(M-1)));
semilogy(EbN0s, Pb)