function [rxFilt] = receiveRecording(chSig, f0, Fs, psFilter, trainFilt, Lsyms)
    % Downconvert
    rxSig = comms.rf.downconvert(chSig, f0, Fs);

    % Synchronize
    rxSync = comms.sync.mfsync(rxSig, trainFilt, true);

    % Decimate
    rxFilt = psFilter.Decimate(rxSync);
    rxFilt = rxFilt(1:Lsyms);
end