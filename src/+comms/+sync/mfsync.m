function y = mfsync(s, x, plotsOn)
    mf = fliplr(conj(x));
    y = conv(s, mf);
    [~, i] = max(abs(y));
    y = s(i+1-length(x):end);
    
    if plotsOn
        figure;
        subplot(3,1,1); plot(real(s)); title('Received Signal');
        subplot(3,1,2); plot(real(y)); title('Received Signal, Aligned');
        subplot(3,1,3); plot(real(x)); title('Training Sequence'); xlabel('Samples');
    end
end