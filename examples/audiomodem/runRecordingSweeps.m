%% Initialize
clear; close all;
mkdir(date);
cd(date);

Msweep = [4 16];
spsSweep = 20:20:200;

%% Generate recordings
for M = Msweep
    for sps = spsSweep
        generateRecording([date '_M_' num2str(M) '_sps_' num2str(sps)], M, sps);
    end
end

%% Load recording
clear;
M = 4;
sps = 120;
filename = ['23-Apr-2017' '_M_' num2str(M) '_sps_' num2str(sps)];
load(filename);

%% Receive recording
rxFilt = receiveRecording(chSig, f0, Fs, psFilter, trainFilt, Ltrain+Lmsg);

%% Mock receive recording
SymbolDelay = 100;
snr = 20;
%h = [.986; .845; .237; .123+.31i];

%chSig = awgn(conv(h, [zeros(1, SymbolDelay*sps) txSig]), snr, 'measured');
chSig = conv(h, [zeros(1, SymbolDelay*sps) txSig]);
rxFilt = receiveRecording(chSig, f0, Fs, psFilter, trainFilt, Ltrain+Lmsg);

%% Analyze Recording (LMS LE)
u = 0.01;
nw = 7;

[y, zk, ck, ek] = comms.equalize.lmsle(rxFilt, u, nw, modem, trainSyms);
scatterplot(zk(1+Ltrain:end));
figure;stem(ek);
figure;plot(real(ck))
figure;plot(imag(ck))

% clear lin;
% lin = lineareq(nw,lms(u),modem.Alphabet.Constellation);
% [symbolest, yd] = equalize(lin, rxFilt, trainSyms); % Equalize.
% scatterplot(symbolest(1+Ltrain:Ltrain+Lmsg));
% figure;plot(real(symbolest(1+Ltrain:Ltrain+Lmsg)));

%% Plot Results (LMS LE)
hndl = figure; row = numel(Msweep); col = numel(spsSweep); i = 1;
for M = [4]
    for sps = [80 100 120 140]
        filename = ['23-Apr-2017' '_M_' num2str(M) '_sps_' num2str(sps)];
        load(filename);
        rxFilt = receiveRecording(chSig, f0, Fs, psFilter, trainFilt, Ltrain+Lmsg);
        u = 0.01;
        nw = 7;
        [y, zk, ck, ek] = comms.equalize.lmsle(rxFilt, u, nw, modem, trainSyms);
        figure(hndl);
        subplot(1, 4, i); plot(real(zk),imag(zk),'b.');
        i = i + 1;
    end
end

%% Analyze Recording (LMS DFE)
u = 0.01;
nw=4;
bw=3;

[y, zk, fk, bk, ek] = comms.equalize.lmsdfe(rxFilt, u, nw, bw, modem, trainSyms);
scatterplot(zk(1+Ltrain:end));
figure;stem(ek);
figure;plot(real(ck))
figure;plot(imag(ck))
figure;plot(real(bk))
figure;plot(imag(bk))

% clear dfe;
% dfe = dfe(nw,bw,lms(u),modem.Alphabet.Constellation);
% [symbolest, yd] = equalize(dfe, rxFilt, trainSyms); % Equalize.
% scatterplot(symbolest(1+Ltrain:Ltrain+Lmsg));
% figure;plot(real(symbolest(1+Ltrain:Ltrain+Lmsg)));