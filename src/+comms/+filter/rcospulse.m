%SINCPULSE
    %   Description: Models RRC pulse shaping filter.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 3/1/2017
    %   Changelog:
    %     (3/1/2017) Initial commit
    %     (3/11/2017) Changed to root-raised cosine pulse

classdef rcospulse < comms.filter.basepulse
%% Properties
    properties
        Beta = 0.25
        SamplesPerSymbol = 4
        Span = 6
        Mode = 'Interpolate'
    end
    
    properties(Dependent)
        ImpulseResponse
    end
%% Properties
    
%% Public Methods
    methods
        % M Get Accessor
        function h = get.ImpulseResponse(obj)
            % Determine length of impulse response
            len = obj.Span * obj.SamplesPerSymbol;
            if (mod(len, 2) == 0)
                len = len + 1;
            end
            
            % Define rcos variables
            b = obj.Beta;
            Ts = obj.SamplesPerSymbol;
            
            % Set all impulse values (center and zero-crossings to be
            % overwritten)
            t = [floor(len/2):-1:1 0 1:floor(len/2)];
            h = 1/sqrt(Ts) * (sin(pi*t/Ts*(1-b)) + (4*b*t/Ts).*cos(pi*t/Ts*(1+b))) ./ (pi*t/Ts .* (1 - (4*b*t/Ts).^2));
            
            % Set center of response
            h(t == 0) = (1/sqrt(Ts)) * (1 - b + 4*b/pi);
            
            % Set first zero-crossing values
            h(t == round(Ts/(4*b))) = b/sqrt(2*Ts) * ((1+2/pi)*sin(pi/(4*b)) + (1-2/pi)*cos(pi/(4*b)));
            
            % Normalize filter energy
            h = h / sqrt(sum(h.^2));
        end
    end
%% Public Methods
end
