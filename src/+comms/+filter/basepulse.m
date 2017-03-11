%BASEPULSE
    %   Description: Base class for pulse shaping filter.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 3/1/2017
    %   Changelog:
    %     (3/1/2017) Initial commit
    %     (3/11/2017) Added mode for upsample/downsample

classdef (Abstract) basepulse < comms.filter.basefilter
%% Properties
    properties (Abstract)
        SamplesPerSymbol
        Span
        Mode
    end
%% Properties  

%% Public Methods
    methods
        % Filters signal
        function y = Filter(obj, signal, window)
            if nargin <= 2
                window = 1;
            end
            
            switch obj.Mode
                case 'Passthrough'
                    y = Filter@comms.filter.basefilter(obj, signal, window);
                case 'Interpolate'
                    y = Filter@comms.filter.basefilter(obj, upsample(signal, obj.SamplesPerSymbol), window);
                case 'Decimate'
                    y = downsample(Filter@comms.filter.basefilter(obj, signal, window), obj.SamplesPerSymbol);
            end
        end
    end
%% Public Methods
end
