close all; clear;
rolloff = 0.25; % Filter rolloff
span = 40;       % Filter span
sps = 250;        % Samples per symbol
M = 4;          % Size of the signal constellation
Nsyms = 500;
SymbolDelay = 100 * sps;
Fs = 44.1e3;
f0 = 2400;
Ctrain = M*2;
Ltrain = 8*Ctrain;

%% Interpolate
rrcFilter = rcosdesign(rolloff, span, sps);
trainCyc = randi([0 M-1], 1, Ctrain);
trainData = repmat(trainCyc, 1, Ltrain/Ctrain);
%trainData = [2*ones(1, Ltrain/4), zeros(1, Ltrain/4), 3*ones(1, Ltrain/4), ones(1, Ltrain/4)];
a=mseq([5 4 2 1],[1 0 1 0 1], 40);
%trainData = randi([0 M-1], 1, Ltrain);
trainData = bi2de(reshape(a(1:Ltrain*log2(M)), log2(M), Ltrain)', 'left-msb')';
trainCyc = trainData(1:Ctrain);
trainData = repmat(trainCyc, 1, Ltrain/Ctrain);

msgData = randi([0 M-1], 1, Nsyms);
% dataFile = load('bindata.mat');
% data = dataFile.data;
data = [trainData msgData];
modTrain = qammod(trainData, M);
modData = qammod(data, M);
trainFilt = upfirdn(trainData,rrcFilter,sps);
txFilt = upfirdn(modData, rrcFilter, sps);

%% Upconvert
txSig = txFilt.*exp(2i*pi*f0*(0:length(txFilt)-1)/Fs);

%% Channel
%EbNo = 20;
snr = 40;%EbNo + 10*log10(k) - 10*log10(sps);

% rxSig = txSig;

% txSig = [zeros(1, SymbolDelay) txSig];
% chan = [.986; .845; .237; .123+.31i]; % Channel coefficients
% filtmsg = filter(chan,1,txSig); % Introduce channel distortion.
% rxSig = awgn(filtmsg, snr, 'measured');


rec = audiorecorder(Fs, 24, 1);
record(rec);
ply = audioplayer(real(txSig), Fs);
pause(1);
playblocking(ply);
stop(ply);
pause(1);
stop(rec);
clear s ply;
rxSig = rec.getaudiodata('double')';

% a = load('qam16rx.mat');
% data = [qamdemod(a.modTrain, M) a.msgData];
% modTrain = a.modTrain;
% txFilt = a.txFilt;
% rxSig = a.rxSig;
% rxFilt = a.rxFilt;

%% Downconvert
rxSig = rxSig.*exp(-2i*pi*f0*(0:length(rxSig)-1)/Fs);
figure;pwelch(real(rxSig),[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;

%% Frame Synchronization
rxSig = SynchronizeMF(rxSig, trainFilt);

%% Decimate
rxFilt = upfirdn(rxSig, rrcFilter, 1, sps);
rxFilt = rxFilt(span+1:end-(end - span - numel(modData)));
%rxData = qamdemod(rxFilt, M);

u = 0.01;
nw = 5;
constn = qammod((0:M-1)', M).';
alg = lms(0.01);

ck = zeros(1, nw);
ek = zeros(1, numel(rxFilt));
yk = zeros(1, numel(rxFilt));
rk = zeros(1, nw);
for i = 1:numel(rxFilt)
    % Slide signal
    rk = [rxFilt(i) rk(1:end-1)];
    
    % Calculate y
    yk(i) = ck * rk.';
    
    % Calculate new coefficients
    if (i <= numel(modTrain))
        ek(i) = modTrain(i) - yk(i);
    else
        ek(i) = constn(qamdemod(yk(i), M)+1) - yk(i);
    end
    ck = ck + u * ek(i) * conj(rk);
end
scatterplot(yk);
figure;plot(real(yk));

% DFE/LMS
nw=5;
bw=3;
fk = zeros(1, nw);
bk = zeros(1, bw);
ek = zeros(1, numel(rxFilt));
yk = zeros(1, numel(rxFilt));
yy = zeros(1, bw);
zk = zeros(1, numel(rxFilt));
rk = zeros(1, nw);
ak = zeros(1, nw);
e = zeros(1, nw);
b = 1;
for i = 1:numel(rxFilt)
    rk = [rxFilt(i) rk(1:end-1)];
    zk(i) = (fk*rk.'-bk*yy.')/b;
    yk(i) = constn(qamdemod(zk(i), M)+1);
    
    if (i <= numel(modTrain))
        ek(i) = modTrain(i) - zk(i);
        e = [ek(i) e(1:end-1)];
        ak = [modTrain(i) ak(1:end-1)];
    elseif (i > numel(modTrain))
        ek(i) = yk(i) - zk(i);
        e = [ek(i) e(1:end-1)];
        ak = [yk(i) ak(1:end-1)];
    end
    
    %b = mean(ak.*e)/mean(abs(constn).^2)+1;
    
    
    fk = fk + u * ek(i) * conj(rk); % Eq.(6.2.17a)
    bk = bk - u * ek(i) * conj(yy); % Eq.(6.2.17b)
    yy = [yk(i) yy(1:end-1)];
end
scatterplot(zk);
figure;plot(real(zk));


% Equalize the received signal.
lin = lineareq(7, alg, constn); % Create an equalizer object.
[symbolest, yd] = equalize(lin, rxFilt.', modTrain.'); % Equalize.
scatterplot(symbolest);
figure;plot(real(symbolest));

% Plot signals.
h = scatterplot(rxFilt.',1,Ltrain,'bx'); hold on;
scatterplot(symbolest,1,Ltrain,'g.',h);
scatterplot(lin.SigConst,1,0,'k*',h);
legend('Filtered signal','Equalized signal',...
   'Ideal signal constellation');
hold off;

% Compute error rates with and without equalization.
demodmsg_noeq = qamdemod(rxFilt.', M); % Demodulate unequalized signal.
demodmsg = qamdemod(yd, M); % Demodulate detected signal from equalizer.
hErrorCalc = comm.ErrorRate; % ErrorRate calculator
ser_noEq = step(hErrorCalc, data(Ltrain+1:end)', demodmsg_noeq(Ltrain+1:end));
reset(hErrorCalc)
ser_Eq = step(hErrorCalc, data(Ltrain+1:end)',demodmsg(Ltrain+1:end));
disp('Symbol error rates with and without equalizer:')
disp([ser_Eq(1) ser_noEq(1)])

% Equalize the received signal.
clear alg;
alg = lms(0.01);
data = data.';
rxFilt = rxFilt.';
modTrain = modTrain.';
dfe = dfe(9,5,alg,constn);
[symbolest, yd] = equalize(dfe, rxFilt, modTrain); % Equalize.
scatterplot(symbolest);
figure;plot(real(symbolest));

% Plot signals.
h = scatterplot(rxFilt,1,Ltrain,'bx'); hold on;
scatterplot(symbolest,1,Ltrain,'g.',h);
scatterplot(dfe.SigConst,1,0,'k*',h);
legend('Filtered signal','Equalized signal',...
   'Ideal signal constellation');
hold off;

% Compute error rates with and without equalization.
demodmsg_noeq = qamdemod(rxFilt, M); % Demodulate unequalized signal.
demodmsg = qamdemod(yd, M); % Demodulate detected signal from equalizer.
hErrorCalc = comm.ErrorRate; % ErrorRate calculator
ser_noEq = step(hErrorCalc, data(Ltrain+1:end), demodmsg_noeq(Ltrain+1:end));
reset(hErrorCalc)
ser_Eq = step(hErrorCalc, data(Ltrain+1:end),demodmsg(Ltrain+1:end));
disp('Symbol error rates with and without equalizer:')
disp([ser_Eq(1) ser_noEq(1)])

function r_trained = SynchronizeMF(s, training)
    mf = fliplr(conj(training));
    y = conv(s, mf);
    [~, i] = max(abs(y));
    r_trained = s(i+1-length(training):end);
    figure;
    subplot(3,1,1); plot(real(s)); title('Received Signal');
    subplot(3,1,2); plot(real(r_trained)); title('Received Signal, Aligned');
    subplot(3,1,3); plot(real(training)); title('Training Sequence'); xlabel('Samples');
end