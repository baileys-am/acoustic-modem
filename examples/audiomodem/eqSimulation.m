clear; close all;
%% Init
M = 4;
NtrainCyc = 20;
NtrainSeq = M*2;
Ltrain = NtrainCyc*NtrainSeq;
Lmsg = 1e4;
Lsyms = Ltrain + Lmsg;
mSeqPoly = [5 4 2 1];
mSeqState = [1 0 1 0 1];
mSeqCyc = 50;
span = 40;
sps = 20;
h = [.986 .845 .237 .123+.31i];

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

%% Channel
chAWGN = comms.channel.awgn;
ebn0Sweep = [16];
berLE = zeros(1, numel(ebn0Sweep));
berDFE = zeros(1, numel(ebn0Sweep));
i = 1;

%% Mock Channel
snr = 16;
chAWGN.SNR = snr;
ch = chAWGN.Propagate(conv(h, syms));

%% LMS LE
u = 0.01;
leNW = 7;


[y, zk, ck, ek] = comms.equalize.lmsle(ch, u, leNW, modem, trainSyms);

%% LMS DFE
u = 0.01;
dfeNW = 4;
dfeBW = 3;

[y, zk, fk, bk, ek] = comms.equalize.lmsdfe(ch, u, dfeNW, dfeBW, modem, trainSyms);