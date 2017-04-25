close all;
clear;

Fs = 44.1e3;
f0 = 2600;
M = 4;
SymbolOrder = 'Grey';
Ltrain = 100 * log2(M);
Nbits = 300 * log2(M);
PSspan = 50;
PSsps = 200;
SymbolDelay = 0 * PSsps;

m = comms.modem.qammodem;
m.M = M;
m.SymbolOrder = SymbolOrder;

% Modulate
trainBits = [ones(1, Ltrain/4) zeros(1, Ltrain/4) ones(1, Ltrain/4), zeros(1, Ltrain/4)];%randi([0,1], 1, Ltrain);%
dataBits = randi([0 1], 1, Nbits);
msgBits = [trainBits dataBits];
trainSyms = m.Modulate(trainBits);
msgSyms = m.Modulate(msgBits);

% Interpolate
txPS = comms.filter.rcospulse;
txPS.Span = PSspan;
txPS.SamplesPerSymbol = PSsps;
txPS.Mode = 'Interpolate';
t = txPS.Filter(trainSyms);
s = txPS.Filter(msgSyms);
figure;pwelch(s,[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;

% Upconvert
% t = t.*exp(2i*pi*f0*(0:length(t)-1)/Fs);
% s = s.*exp(2i*pi*f0*(0:length(s)-1)/Fs);
% figure;pwelch(s,[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;

% Delayed 
s_d = [zeros(1, SymbolDelay) s];
% rec = audiorecorder(Fs, 16, 1);
% record(rec);
% ply = audioplayer(real(s), Fs);
% pause(1);
% playblocking(ply);
% pause(1);
% stop(ply);
% stop(rec);
% clear s ply;
% s_d = rec.getaudiodata('double')';

% Bandpass filter
% figure;subplot(3,1,1);plot(s_d);
% subplot(3,1,2); pwelch(s_d,[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;
% F = [2000 2200 2800 3000];  % band limits
% A = [0 1 0];                % band type: 0='stop', 1='pass'
% dev = [0.0001 10^(0.1/20)-1 0.0001]; % ripple/attenuation spec
% [Mw,Wn,beta,typ] = kaiserord(F,A,dev,Fs);  % window parameters
% b = fir1(Mw,Wn,typ,kaiser(Mw+1,beta),'noscale'); % filter design
% s_dm = mean(s_d);
% s_d = conv(b, s_d - s_dm) + s_dm;
% subplot(3,1,3); pwelch(s_d,[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;

% Training
s_d = Synchronize(s_d, t);

% Downconvert
% s_d = s_d.*exp(-2i*pi*f0*(0:length(s_d)-1)/Fs);
% figure;pwelch(real(s_d),[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;

% Low pass filter
% fc = 200;
% Wn = fc/(Fs/2);
% b = fir1(200,Wn,'low');
% N   = 200;        % FIR filter order
% Fp  = 150;       % 20 kHz passband-edge frequency
% Rp  = 0.00057565; % Corresponds to 0.01 dB peak-to-peak ripple
% Rst = 1e-5;       % Corresponds to 80 dB stopband attenuation
% b = firceqrip(N,Fp/(Fs/2),[Rp Rst],'passedge'); % eqnum = vec of coeffs
% s_dm = mean(s_d);
% s_d = conv(b, s_d);
% figure; pwelch(s_d,[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;

% Decimate
rxPs = comms.filter.rcospulse;
rxPs.Span = PSspan;
rxPs.SamplesPerSymbol = PSsps;
rxPs.Mode = 'Decimate';
r = rxPs.Filter(s_d);
scatterplot(r)

% Equalize the received signal.
% eq1 = lineareq(1, lms(0.01)); % Create an equalizer object.
% eq1.nSampPerSym = PSsps;
% eq1.SigConst = m.Constellation; % Set signal constellation.
% [r_eq,yd] = equalize(eq1, r(1:length(msgSyms))); % Equalize.
% scatterplot(r_eq);
% BEReq = sum(msgBits ~= m.Demodulate(r_eq))/numel(msgBits) * 100

% Demodulate
recBits = m.Demodulate(r);%(1:length(msgSyms)));

% BER
BER = sum(msgBits ~= recBits(1:numel(msgBits)))/numel(msgBits) * 100;

disp(['BER = ' num2str(BER) '%']);

function r_trained = Synchronize(s, training)
    [acor,lag] = xcorr(training, s);
    [~,I] = max(abs(acor));
    lagDiff = lag(I);
    indx = -lagDiff+1;
    %timeDiff = lagDiff/Fs
    %figure; plot(lag,acor); a3 = gca; a3.XTick = sort([-3000:1000:3000 lagDiff]);
    s1al = s(indx:end);
    r_trained = s1al;%(length(training)+1:end);
    figure;
    subplot(3,1,1); plot(real(s)); title('Received Signal');
    subplot(3,1,2); plot(real(r_trained)); title('Received Signal, Aligned');
    subplot(3,1,3); plot(real(training)); title('Training Sequency'); xlabel('Samples');
end