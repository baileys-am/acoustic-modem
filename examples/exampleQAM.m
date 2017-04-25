%clear;
% Set up parameters and signals.
M = 16; % Alphabet size for modulation
%msg = randi([0 M-1],1000,1); % Random message
msg = data;
%modmsg = qammod(msg, M); % Modulate using QAM.
modmsg = modData.';
trainlen = Ltrain; % Length of training sequence
%chan = [.986; .845; .237; .123+.31i]; % Channel coefficients
%filtmsg = filter(chan,1,modmsg); % Introduce channel distortion.
filtmsg = rxFilt;
alg = lms(0.01);

% Equalize the received signal.
eq1 = lineareq(7, alg); % Create an equalizer object.
eq1.SigConst = qammod((0:M-1)', M)'; % Set signal constellation.
[symbolest,yd] = equalize(eq1,filtmsg,modmsg(1:trainlen)); % Equalize.

% Plot signals.
h = scatterplot(filtmsg,1,trainlen,'bx'); hold on;
scatterplot(symbolest,1,trainlen,'g.',h);
scatterplot(eq1.SigConst,1,0,'k*',h);
legend('Filtered signal','Equalized signal',...
   'Ideal signal constellation');
hold off;

% Compute error rates with and without equalization.
demodmsg_noeq = qamdemod(filtmsg, M); % Demodulate unequalized signal.
demodmsg = qamdemod(yd, M); % Demodulate detected signal from equalizer.
hErrorCalc = comm.ErrorRate; % ErrorRate calculator
ser_noEq = step(hErrorCalc, ...
    msg(trainlen+1:end), demodmsg_noeq(trainlen+1:end));
reset(hErrorCalc)
ser_Eq = step(hErrorCalc, msg(trainlen+1:end),demodmsg(trainlen+1:end));
disp('Symbol error rates with and without equalizer:')
disp([ser_Eq(1) ser_noEq(1)])

% Equalize the received signal.
[symbolest, yd] = mAdaptiveLMSDFE(18, 7, 0.01, filtmsg, modmsg(1:trainlen), qammod((0:M-1)', M)');

% Compute error rates with and without equalization.
demodmsg_noeq = qamdemod(filtmsg, M); % Demodulate unequalized signal.
demodmsg = qamdemod(yd, M); % Demodulate detected signal from equalizer.
hErrorCalc = comm.ErrorRate; % ErrorRate calculator
ser_noEq = step(hErrorCalc, ...
    msg(trainlen+1:end), demodmsg_noeq(trainlen+1:end));
reset(hErrorCalc)
ser_Eq = step(hErrorCalc, msg(trainlen+1:end),demodmsg(trainlen+1:end));
disp('Symbol error rates with and without equalizer:')
disp([ser_Eq(1) ser_noEq(1)])