clear; close all;
%% Init
M = 4;
NtrainCyc = 20;
NtrainSeq = M*2;
Ltrain = NtrainCyc*NtrainSeq;
Lmsg = 1e6;
Lsyms = Ltrain + Lmsg;
mSeqPoly = [5 4 2 1];
mSeqState = [1 0 1 0 1];
mSeqCyc = 50;
span = 40;
sps = 20;

modem = comms.modem.qammodem;
modem.Alphabet.M = M;
psFilter = comms.filter.rcospulse;
psFilter.Span = span;
psFilter.SamplesPerSymbol = sps;

%% Generate symbols
[trainData, trainSyms] = generateMSeq(modem, mSeqPoly, mSeqState, mSeqCyc, Ltrain);
msgData = randi([0 M-1], 1, Lmsg);
msgSyms = modem.Modulate(msgData);
syms = [trainSyms msgSyms];

%% Interpolate
tx = psFilter.Interpolate(syms);

symbolDelay = 138;
h = [0.93 0.78 0.237+0.1i 0.11 0.5+0.33i];
%h = [.986 .845 .237 .123+.31i];
chAWGN = comms.channel.awgn;
ebn0Sweep = 0:2:12;
berLE = zeros(1, numel(ebn0Sweep));
berDFE = zeros(1, numel(ebn0Sweep));
i = 1;
for ebn0 = ebn0Sweep
%% Mock Channel
snr = ebn0 + 10*log10(log2(M));
chAWGN.SNR = snr;
%ch = chAWGN.Propagate(conv(h, tx));
ch = chAWGN.Propagate(conv(h, tx));

%% Decimate
rx = psFilter.Decimate(ch);

%% LMS LE
u = 0.01;
leNW = 7;
dfeNW = 4;
dfeBW = 3;

[y, zk, ck, ek] = comms.equalize.lmsle(rx, u, leNW, modem, trainSyms);
scatterplot(zk(1+Ltrain:end));
berLE(i) = sum(msgSyms ~= y)/Lmsg;

[y, zk, fk, bk, ek] = comms.equalize.lmsdfe(rx, u, dfeNW, dfeBW, modem, trainSyms);
scatterplot(zk(1+Ltrain:end));
berDFE(i) = sum(msgSyms ~= y)/Lmsg;
i = i + 1;
%scatterplot(zk(1+Ltrain:end));
% figure;stem(ek);
% figure;plot(real(ck))
% figure;plot(imag(ck))
% 
% clear lin;
% lin = lineareq(nw,lms(u),modem.Alphabet.Constellation);
% [symbolest, yd] = equalize(lin, rx, trainSyms); % Equalize.
% scatterplot(symbolest(1+Ltrain:end));
end

%% LMS DFE