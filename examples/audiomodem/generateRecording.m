function [] = generateRecording(filename, M, sps)
    % Symbol generation
    NtrainCyc = 8;
    NtrainSeq = M*2;
    Ltrain = NtrainCyc*NtrainSeq;
    Lmsg = 10000;
    Fs = 44.1e3;
    f0 = 2400;
    mSeqPoly = [5 4 2 1];
    mSeqState = [1 0 1 0 1];
    mSeqCyc = 50;
    span = 40;
    sps = sps;

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
    save(filename);
end