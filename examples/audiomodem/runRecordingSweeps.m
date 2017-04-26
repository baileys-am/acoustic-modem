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
sps = 180;
filename = [date '_M_' num2str(M) '_sps_' num2str(sps)];
load(filename);

%% Receive recording
rxFilt = receiveRecording(chSig, f0, Fs, psFilter, trainFilt, Ltrain+Lmsg);

%% Mock receive recording
SymbolDelay = 100;
snr = 20;
h = [.986 .845 .237 .123+.31i];
chAWGN = comms.channel.awgn;
chAWGN.SNR = snr;
chSig = chAWGN.Propagate(conv(h, [zeros(1, SymbolDelay*sps) txSig]));

rxFilt = receiveRecording(chSig, f0, Fs, psFilter, trainFilt, Ltrain+Lmsg);

%% Analyze Recording (LMS LE)
u = 0.01;
nw = 7;

[y, zk, ck, ek] = comms.equalize.lmsle(rxFilt, u, nw, modem, trainSyms);

scatterplot(zk(1+Ltrain:end));
figure;stem(ek);
figure;plot(real(ck))
figure;plot(imag(ck))
figure;plot(real(bk))
figure;plot(imag(bk))

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