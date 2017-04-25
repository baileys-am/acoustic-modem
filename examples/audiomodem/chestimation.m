%% Generate M-Sequence
% Symbol generation
close all; clear;
M = 4;
Ncyc = 8;
Nseq = M*2;
Lseq = Ncyc*Nseq;
Fs = 44.1e3;
f0 = 2400;
mSeqPoly = [5 4 2 1];
mSeqState = [1 0 1 0 1];
mSeqCyc = 50;
span = 40;
sps = 20;

modem = comms.modem.qammodem;
modem.Alphabet.M = M;
[data, syms] = generateMSeq(modem, mSeqPoly, mSeqState, mSeqCyc, Lseq);

%% Interpolation
psFilter = comms.filter.rcospulse;
psFilter.Span = span;
psFilter.SamplesPerSymbol = sps;
txFilt = psFilter.Interpolate(syms);

%% Upconvert
txSig = comms.rf.upconvert(txFilt, f0, Fs);

%% Play and record
 chSig = playrecord(txSig, Fs);
% figure;pwelch(real(chSig),[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;
% figure;plot(real(chSig));
SymbolDelay = 100 * sps;
snr = 20;
%h = [.986 .845 .237 .123+.31i];
%chSig = awgn(conv(h, [zeros(1, SymbolDelay) txSig]), snr, 'measured');

%% Downconvert
rxSig = comms.rf.downconvert(chSig, f0, Fs);
figure;pwelch(real(rxSig),[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;

%% Synchronize
rxSync = comms.sync.mfsync(rxSig, txFilt, true);
figure;pwelch(real(rxSync),[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;

%% Decimate
rxFilt = psFilter.Decimate(rxSync);
rxFilt = rxFilt(1:Ltrain+Lmsg);
scatterplot(rxFilt);

%% Channel Estimation
X = fft([trainSyms msgSyms]);
Y = fft(rxFilt);
X = X + 0.00000000001;
i = min(find(real(X)==0), find(imag(X)==0));
if ~isempty(i)
    X = X(1:i-1);
    Y = Y(1:i-1); 
end

%X(real(X)==0) = X(real(X)==0) + 0.00000001;
%X(imag(X)==0) = X(imag(X)==0) + 0.00000001;
%X(33) = X(49);% + 0.00001;
%X(49) = X(49) + 0.00001;
H = Y ./ X;
h = ifft(H);
figure;freqz(h);
y = conv(h, [trainSyms msgSyms]);
y = y(1:numel(rxFilt));
scatterplot(y);

% hh = [zeros(1, 5)];
% X = toeplitz(syms, hh);
% %h_est = inv(X.’*X) * X.’ * y;
% estCH = (inv(X.'*X) * X.' * rxSync.').'; 
% 
% %estCH = conv(conv(txFilt,h), fliplr(conj(txFilt)));
% %estCH = (flipud(hankel(fliplr(txFilt)))' * rxSync(1:numel(txFilt)).').'/numel(txFilt);
% %figure;pwelch(real(estCH),[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;
% %figure; plot(real(estCH));
% 
% estChSig = conv(syms, estCH);
% estRxSig = estChSig;%comms.rf.downconvert(estChSig, f0, Fs);
% estRxSync = comms.sync.mfsync(estRxSig, syms, true);
% %estRxFilt = psFilter.Decimate(estRxSync);
% %estRxFilt = estRxFilt(1:Lseq);
% scatterplot(estRxSync);
