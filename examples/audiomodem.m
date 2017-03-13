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
f0 = 1200;
M = 4;
SymbolOrder = 'Grey';
Nbits = 1000 * log2(M);

m = comms.modem.qammodem;
m.M = M;
m.SymbolOrder = SymbolOrder;

bindata = randi([0 1], 1, Nbits);

rec = audiorecorder(Fs, 16, 1);
record(rec);
[s, syms, training] = ModulateData(Fs, f0, m, bindata);
ply = audioplayer(s, Fs);
pause(1);
playblocking(ply);
pause(1);
stop(ply);
stop(rec);
clear s ply;
recSignal = rec.getaudiodata('double');

recData = DemodulateSignal(Fs,f0, m, recSignal', syms, training);
clear rec recSignal training;

BER = sum(bindata ~= recData) / numel(bindata);
disp(['Bit error rate: ' num2str(BER)]);

function [s, syms, training] = ModulateData(Fs, f0, modem, bindata)
    %% Modulate
    % Creates modulated complex baseband signal.
    syms = modem.Modulate(bindata);
    scatterplot(syms);

    %% Interpolate
    % Interpolates using sinc pulse
    txPS = comms.filter.rcospulse;
    txPS.Span = 30;
    txPS.SamplesPerSymbol = 200;
    stilde = txPS.Filter(syms);
    training = stilde;
    
    %% Upconvert
    % Upconverts baseband to passband signal
    s = real(stilde.*exp(2i*pi*f0*(0:length(stilde)-1)/Fs));
    figure;pwelch(s,[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;
end

function bindata = DemodulateSignal(Fs, f0, modem, r, syms, training)
    %% Bandpass Filter
    figure;subplot(3,1,1);plot(r);
    subplot(3,1,2); pwelch(r,[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;
    fp = f0 - 110;
    fs = f0 + 110;
    Wn = [fp fs]/(Fs/2);
    b = fir1(200,Wn);
    r = filter(b, 1, real(r)) - 1i*filter(b, 1, imag(r));
    subplot(3,1,3); pwelch(r,[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;
    
    %% Downconvert
    % Downconverts passband to baseband signal
    rtilde = r.*cos(2*pi*f0*(0:length(r)-1)/Fs) + 1i * r.*sin(2*pi*f0*(0:length(r)-1)/Fs);
    figure;pwelch(real(rtilde),[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;
    
    %% Low pass filter
    fc = 200;
    Wn = fc/(Fs/2);
    b = fir1(200,Wn,'low');
    rtilde = filter(b, 1, real(rtilde)) - 1i*filter(b, 1, imag(rtilde));
    
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
    
    figure;pwelch(real(rtilde),[],[],[],Fs); ax=axis; ax(1:2) = [0,2*f0/1e3]; axis(ax); drawnow;
    
    %% Training
    s1 = rtilde;
    s2 = training;
    [acor,lag] = xcorr(s2, s1);
    [~,I] = max(abs(acor));
    lagDiff = lag(I);
    timeDiff = lagDiff/Fs
    figure; plot(lag,acor); a3 = gca; a3.XTick = sort([-3000:1000:3000 lagDiff]);
    s1al = s1(-lagDiff+1:end);
    subplot(2,1,1); plot(real(s1al)); title('Received Signal, Aligned');
    subplot(2,1,2); plot(real(s2)); title('Training Sequency'); xlabel('Samples');
    rtilde = s1al(1:length(s2));
    
    %% Decimate
    rxPS = comms.filter.rcospulse;
    rxPS.Span = 30;
    rxPS.SamplesPerSymbol = 200;
    rxPS.Mode = 'Decimate';
    rxSignal = rxPS.Filter(rtilde);
    scatterplot(rxSignal);
    
    %% Demodulate
    % Demodulates baseband signal
    bindata = modem.Demodulate(rxSignal);
end