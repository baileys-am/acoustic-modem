%AUDIOMODEM
    %   Description: Generates audio using QAM modem to record and
    %   demodulate.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 3/12/2017
    %   Changelog:
    %     (3/12/2017) Initial commit.

close all;
clear;

Fs = 44.1e3;
f0 = 3000;
M = 4;
SymbolOrder = 'Grey';
Ltrain = 100 * log2(M);
Nbits = 500 * log2(M);

m = comms.modem.qammodem;
m.M = M;
m.SymbolOrder = SymbolOrder;

train = [ones(1, Ltrain/4) zeros(1, Ltrain/4) ones(1, Ltrain/4) zeros(1, Ltrain/4)];
data = randi([0 1], 1, Nbits);
msg = [train data];
[s, syms] = ModulateData(Fs, f0, m, msg);

% rec = audiorecorder(Fs, 16, 1);
% record(rec);
% ply = audioplayer(s, Fs);
% pause(1);
% playblocking(ply);
% pause(1);
% stop(ply);
% stop(rec);
% clear s ply;
% recSignal = rec.getaudiodata('double')';
recSignal = [zeros(1, 500*log2(M)) s zeros(1, 1000*log2(M))];

recMsg = DemodulateSignal(Fs, f0, m, recSignal, syms, syms(1:1001));
clear rec recSignal;

BER = sum(msg ~= recMsg) / numel(msg);
disp(['Bit error rate: ' num2str(BER)]);

function [s, syms] = ModulateData(Fs, f0, modem, msg)
    %% Modulate
    % Creates modulated complex baseband signal.
    syms = modem.Modulate(msg);
    scatterplot(syms);

    %% Interpolate
    % Interpolates using sinc pulse
    txPS = comms.filter.rcospulse;
    txPS.Span = 50;
    txPS.SamplesPerSymbol = 30;
    stilde = txPS.Filter(syms);
    
    %% Upconvert
    % Upconverts baseband to passband signal
    %s = real(stilde.*exp(2i*pi*f0*(0:length(stilde)-1)/Fs));
    %figure;pwelch(s,[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;
    s = stilde;
end

function bindata = DemodulateSignal(Fs, f0, modem, r, syms, train)
    %% Bandpass Filter
%     figure;subplot(3,1,1);plot(r);
%     subplot(3,1,2); pwelch(r,[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;
%     fp = f0 - 110;
%     fs = f0 + 110;
%     Wn = [fp fs]/(Fs/2);
%     b = fir1(200,Wn);
%     r = filter(b, 1, real(r)) - 1i*filter(b, 1, imag(r));
%     subplot(3,1,3); pwelch(r,[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;
    
    %% Downconvert
    % Downconverts passband to baseband signal
%     rtilde = r.*cos(2*pi*f0*(0:length(r)-1)/Fs) - 1i * r.*sin(2*pi*f0*(0:length(r)-1)/Fs);
%     figure;pwelch(real(rtilde),[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;
    
%     %% Low pass filter
%     fc = 200;
%     Wn = fc/(Fs/2);
%     b = fir1(200,Wn,'low');
%     rtilde = filter(b, 1, real(rtilde)) + 1i*filter(b, 1, imag(rtilde));
    
%     Fcut = 500;
%     order = 10;
%     Fdig = Fcut / (Fs/2);   % "Digital frequency" normalized by sampling rate
%     [bb,aa] = butter(order, Fdig);
%     mI = filter(bb, aa, real(rtilde));   % Apply the filter
%     mI = mI - mean(mI);
%     mQ = -filter(bb, aa, imag(rtilde));   % Apply the filter
%     mQ = mQ - mean(mQ);
%     rtilde = mI + 1i*mQ;

%     Fp = 1000 / (Fs/2);
%     Fst = (2000) / (Fs/2);
%     Ap = 0.5;
%     Ast = 60;
%     Order = 10;
%     d = fdesign.lowpass('Fp,Fst,Ap,Ast', Fp, Fst, Ap, Ast, Order);
%     Hd = design(d);
%     rtilde = filter(Hd,rtilde);

%     N   = 100;        % FIR filter order
%     Fp  = 500;       % 20 kHz passband-edge frequency
%     Fs  = 1000;       % 96 kHz sampling frequency
%     Rp  = 0.00057565; % Corresponds to 0.01 dB peak-to-peak ripple
%     Rst = 1e-4;       % Corresponds to 80 dB stopband attenuation
%     eqnum = firceqrip(N,Fp/(Fs/2),[Rp Rst],'passedge'); % eqnum = vec of coeffs
%     rtilde = conv(rtilde, eqnum);
    rtilde = r;
    figure;pwelch(real(rtilde),[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;
    
    %% Training
    s1 = rtilde;
    s2 = train;
    [acor,lag] = xcorr(s2, s1);
    [~,I] = max(abs(acor));
    lagDiff = lag(I);
    timeDiff = lagDiff/Fs
    %figure; plot(lag,acor); a3 = gca; a3.XTick = sort([-3000:1000:3000 lagDiff]);
    s1al = s1(-lagDiff+1:end);
    r = s1al;%(1:length(syms));
    figure;
    subplot(2,1,1); plot(real(r)); title('Received Signal, Aligned');
    subplot(2,1,2); plot(real(s2)); title('Training Sequenc'); xlabel('Samples'); 
    
    %% Decimate
    rxPS = comms.filter.rcospulse;
    rxPS.Span = 50;
    rxPS.SamplesPerSymbol = 30;
    rxPS.Mode = 'Decimate';
    rxSignal = rxPS.Filter(r);
    scatterplot(rxSignal);
    
    
    % Equalize the received signal.
% trainlen = length(train);
% eq1 = lineareq(30, lms(0.01)); % Create an equalizer object.
% eq1.nSampPerSym = 1;
% eq1.SigConst = modem.Constellation; % Set signal constellation.
% [symbolest,yd] = equalize(eq1,rxSignal,train); % Equalize.

% Plot signals.
% h = scatterplot(rxSignal,1,trainlen,'bx'); hold on;
% scatterplot(symbolest,1,trainlen,'g.',h);
% scatterplot(eq1.SigConst,1,0,'k*',h);
% legend('Filtered signal','Equalized signal',...
%    'Ideal signal constellation');
% hold off;
    
      
    
    %% Demodulate
    % Demodulates baseband signal
    bindata = modem.Demodulate(rxSignal(1:length(syms)));
end