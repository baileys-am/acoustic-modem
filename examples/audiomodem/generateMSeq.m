function [data, syms] = generateMSeq(modem, mSeqPoly, mSeqState, mSeqCyc, L)
    mSeq = comms.coding.mseq(mSeqPoly, mSeqState, mSeqCyc);
    data = comms.bin2dec(mSeq(1:L*log2(modem.Alphabet.M)), log2(modem.Alphabet.M));
    syms = modem.Modulate(data);
end

