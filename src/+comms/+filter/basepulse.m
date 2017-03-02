%BASEPULSE
    %   Description: Base class for pulse shaping filter.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 3/1/2017
    %   Changelog:
    %     (3/1/2017) Initial commit

classdef (Abstract) basepulse < comms.filter.basefilter
%% Properties
    properties
        SamplesPerSymbol
    end
%% Properties  

%% Public Methods
    methods
        % Filters signal
        function y = Filter(obj, signal, window)
            y = Filter@basefilter(obj, upsample(signal, obj.SamplesPerSymbols), window);
        end
    end
%% Public Methods
end
