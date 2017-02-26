%SIMPLELOOPBACKAWGN
    %   Description: Models a single modem that listens to its own
    %   transmission in an AWGN channel. Displays BER and plots bitstreams
    %   and baseband signals.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/26/2017
    %   Version: 1
    %       (2/26/2017) Initial commit.

%% Modem
% Creates QAM modem with modulator/demodulator.
%     Modulation order, M = 64
%     Symbol order, SymbolOrder = 'Binary'
M = 64;
SymbolOrder = 'Binary';
m = modem();
m.Modulator.M = M;
m.Modulator.SymbolOrder = SymbolOrder;
m.Demodulator.M = M;
m.Demodulator.SymbolOrder = SymbolOrder;

%% Input
% Creates bitstream input for system.
%     Number of bits, Nbits = 100000 * bitsPerSymbol
Nbits = 100000 * log2(m.Modulator.M);
txBitstream = randi([0 1], 1, Nbits);

%% Modulate
% Creates modulated complex baseband signal.
txSignal = m.Modulator.Modulate(txBitstream);

%% Channel
% Applies AWGN to transmitted signal.
%     Bit to noise energy, EbN0 = 10
EbN0 = 10;
Eb = mean(abs(m.Modulator.Constellation).^2) / log2(m.Modulator.M);
N0 = Eb/10^(EbN0/10);
n = sqrt(N0/2) * (randn(size(txSignal)) + 1i*randn(size(txSignal)));
rxSignal = txSignal + n;

%% Demodulate
% Demodulates received complex baseband signal.
rxBitstream = m.Demodulator.Demodulate(rxSignal);

%% Results
% Calculates BER and generates plots.
BER = sum(txBitstream ~= rxBitstream)/numel(txBitstream);
pBitstream = 0.0001;
pSignal = 0.001;

% Display BER
disp(['BER = ' num2str(BER)]);

% Plot TX Bitstream
figure;
stem(txBitstream(1:ceil(end*pBitstream)));
title('Tx Bitstream'); 

% Plot TX IQ Signal
figure;
subplot(2,1,1); plot(real(txSignal(1:ceil(end*pSignal))));
title('Tx I Signal');
subplot(2,1,2); plot(imag(txSignal(1:ceil(end*pSignal))));
title('Tx Q Signal');

% Plot RX IQ Signal
figure;
subplot(2,1,1); plot(real(rxSignal(1:ceil(end*pSignal))));
title('Rx I Signal'); 
subplot(2,1,2); plot(imag(rxSignal(1:ceil(end*pSignal))));
title('Rx Q Signal'); 

% Plot RX Bitstream
figure;
stem(rxBitstream(1:ceil(end*pBitstream)));
title('Rx Bitstream'); 