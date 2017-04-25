signal = ones(1,20);
w = ones(1, 5);
trainSeq = ones(1,20);

paddedSignal = [signal zeros(1, numel(w))];
yk = zeros(1, numel(signal) + numel(w));
for i = 1:numel(yk)
    % Slide signal
    rk = SlideSignal(signal, i, numel(w));
    
    % Calculate y
    y = rk .* ck;
    yk(i) = sum(y);
    
    % Calculate new coefficients
    if (i <= numel(trainSeq))
        
    else
        
    end
end

function y = SlideSignal(signal, indx, L)
    % Return vector containing L-1 samples prior to indx and sample at indx
    
    % L >= indx
    if (L >= indx)
        y = [zeros(1, L-indx) signal(1:indx)];
        return;
    end
    
    % L < indx <= numel(signal)
    if (L < indx && indx <= numel(signal))
        y = signal(indx-L+1:indx);
        return;
    end
    
    % L < indx > numel(signal)
    if (L < indx && indx > numel(signal))
        y = [signal(end-L+(indx-end)+1:end) zeros(1, indx-numel(signal))];
        return;
    end
end