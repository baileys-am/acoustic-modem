function [recording] = playrecord(signal, Fs)
    rec = audiorecorder(Fs, 24, 1);
    record(rec);
    ply = audioplayer(real(signal), Fs);
    pause(0.25);
    playblocking(ply);
    stop(ply);
    pause(0.25);
    stop(rec);
    recording = rec.getaudiodata('double').';
end

