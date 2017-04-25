function [symbolest, yd] = mAdaptiveLMSDFE(nF, nB, u, rx, train, const)
    % Equalize the received signal.
    alg = lms(u);
    eq = dfe(nF, nB, alg, const); % Create an equalizer object.
    [symbolest, yd] = equalize(eq, rx, train); % Equalize.
    clear alg;
    
    % Plot signals.
    h = scatterplot(rx, 1, length(train), 'bx');
    hold on;
    scatterplot(symbolest, 1, length(train), 'g.', h);
    scatterplot(eq.SigConst, 1, 0, 'k*', h);
    legend('Filtered signal', 'Equalized signal', 'Ideal signal constellation');
    hold off;
end