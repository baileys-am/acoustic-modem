%% Generate audio file
% Symbol generation
close all; clear;
M = 4;
NtrainCyc = 8;
NtrainSeq = M*2;
Ltrain = NtrainCyc*NtrainSeq;
Lmsg = 500;
Fs = 44.1e3;
f0 = 2400;
mSeqPoly = [5 4 2 1];
mSeqState = [1 0 1 0 1];
mSeqCyc = 50;
span = 40;
sps = 20;

modem = comms.modem.qammodem;
modem.Alphabet.M = M;
[trainData, trainSyms] = generateMSeq(modem, mSeqPoly, mSeqState, mSeqCyc, Ltrain);
msgData = randi([0 M-1], 1, Lmsg);
msgSyms = modem.Modulate(msgData);

% Interpolation
psFilter = comms.filter.rcospulse;
psFilter.Span = span;
psFilter.SamplesPerSymbol = sps;
trainFilt = psFilter.Interpolate(trainSyms);
txFilt = psFilter.Interpolate([trainSyms msgSyms]);

% Upconvert
txSig = comms.rf.upconvert(txFilt, f0, Fs);
figure;pwelch(real(txSig),[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;

% Play and record
chSig = playrecord(txSig, Fs);

% Save to file
save 'audiomodemRun.mat';

%% Load audio file
load 'audiomodemRun.mat';

%% Mock channel
SymbolDelay = 100 * sps;
snr = 20;
h = [.986; .845; .237; .123+.31i];

%chSig = txSig;
chSig = awgn(conv(h, [zeros(1, SymbolDelay) txSig]), snr, 'measured');

%% Receive audio
% Downconvert
rxSig = comms.rf.downconvert(chSig, f0, Fs);

% Synchronize
rxSync = comms.sync.mfsync(rxSig, trainFilt, true);

% Decimate
rxFilt = psFilter.Decimate(rxSync);
scatterplot(rxFilt);

%% Equalize (LMS LE)
u = 0.01;
nw = 5;
constn = modem.Alphabet.Constellation;

ck = zeros(1, nw);
ek = zeros(1, numel(rxFilt));
yk = zeros(1, numel(rxFilt));
rk = zeros(1, nw);
for i = 1:numel(rxFilt)
    rk = [rxFilt(i) rk(1:end-1)];
    
    % Calculate y
    yk(i) = ck * rk.';
    
    % Calculate new coefficients
    if (i <= Ltrain)
        ek(i) = trainSyms(i) - yk(i);
    else
        q = modem.Demodulate(yk(i));
        ek(i) = modem.Modulate(q) - yk(i);
    end
    ck = ck + u * ek(i) * conj(rk);
end
scatterplot(yk(1+Ltrain:Ltrain+Lmsg));
figure;plot(real(yk(1+Ltrain:Ltrain+Lmsg)));

%% Equalize (LMS DFE)
nw=4;
bw=3;
u = 0.01;
fk = zeros(1, nw);
bk = zeros(1, bw);
ek = zeros(1, numel(rxFilt));
yk = zeros(1, numel(rxFilt));
yy = zeros(1, bw);
zk = zeros(1, numel(rxFilt));
rk = zeros(1, nw);
dk = zeros(1, bw);
e = zeros(1, nw);
b = 1;
for i = 1:numel(rxFilt)
    rk = [rxFilt(i) rk(1:end-1)];
    zk(i) = fk*rk.'-bk*dk.';

    if (i <= Ltrain)
        ek(i) = trainSyms(i) - zk(i);
        q = modem.Demodulate(trainSyms(i));
    elseif (i > Ltrain)
        q = modem.Demodulate(zk(i));
        ek(i) = modem.Modulate(q) - zk(i);
    end

    fk = fk + u * ek(i) * conj(rk);
    bk = bk - u * ek(i) * conj(dk);
    dk = [modem.Modulate(q) dk(1:end-1)];
end
scatterplot(zk(1+Ltrain:Ltrain+Lmsg));
figure;plot(real(zk(1+Ltrain:Ltrain+Lmsg)));

%% MATLAB LMS DFE
clear dfe;
dfe = dfe(nw,bw,lms(0.01),modem.Alphabet.Constellation);
[symbolest, yd] = equalize(dfe, rxFilt, trainSyms); % Equalize.
scatterplot(symbolest(1+Ltrain:Ltrain+Lmsg));
figure;plot(real(symbolest(1+Ltrain:Ltrain+Lmsg)));