%MEASURE
    %   Description: Static class for common measurement functions.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/27/2017
    %   Changelog:
    %     (2/27/2017) Initial commit.

classdef measure
%% Static Methods
    methods (Static)
        % Calculates power in a signal
        function power = signalpower(signal, powerType)
            % Calculate power
            power = mean(abs(signal).^2);
            
            % Convert to powerType specified
            switch lower(powerType)
                case 'linear'
                    % power is already linear
                case 'db'
                    power = 10*log10(power);
            end
        end
    end
%% Static Methods
end

