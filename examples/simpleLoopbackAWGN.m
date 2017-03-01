%SIMPLELOOPBACKAWGN
    %   Description: Models a single modem that listens to its own
    %   transmission in an AWGN channel. Displays BER and plots bitstreams
    %   and baseband signals.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/26/2017
    %   Changelog:
    %     (2/26/2017) Initial commit.
    %     (2/28/2017) Updates for qammodem merge.
    %     (2/28/2017) Integrated AWGN channel. Changed symbol plots to
    %     scatter plots; removed bitstream plots.

clear; close all;
    
%% Modem
% Creates QAM modem with modulator/demodulator.
%     Modulation order, M = 64
%     Symbol order, SymbolOrder = 'Binary'
M = 64;
SymbolOrder = 'Binary';
m = comms.modem.qammodem;
m.M = M;
m.SymbolOrder = SymbolOrder;

%% Input
% Creates bitstream input for system.
%     Number of bits, Nbits = 100000 * bitsPerSymbol
Nbits = 100000 * log2(m.M);
txBitstream = randi([0 1], 1, Nbits);

%% Modulate
% Creates modulated complex baseband signal.
txSignal = m.Modulate(txBitstream);

%% Channel
% Applies AWGN to transmitted signal.
%     Bit energy to noise PSD, EbN0 = 10
EbN0 = 20;
ch = comms.channel.awgn;
ch.SNR = EbN0 + 10*log10(log2(m.M));
rxSignal = ch.Propagate(txSignal);

%% Demodulate
% Demodulates received complex baseband signal.
rxBitstream = m.Demodulate(rxSignal);

%% Results
% Calculates BER and generates plots.
BER = sum(txBitstream ~= rxBitstream)/numel(txBitstream);
pBitstream = 0.0001;
pSignal = 0.001;

% Display BER
disp(['BER = ' num2str(BER)]);

% Plot Tx Signal Constellation
scatterplot(txSignal);
title('Tx Signal Constellation');

% Plot Rx Signal Constellation
scatterplot(rxSignal);
title('Rx Signal Constellation');