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
    end
%% Properties 

%% Public Methods
    methods
        function y = Interpolate(obj, input, window)
            if nargin <= 2
                window = 1;
            end
            
            y = Filter(obj, upsample(input, obj.SamplesPerSymbol), window);
        end
        
        function y = Decimate(obj, input, window)
            if nargin <= 2
                window = 1;
            end
            
            y = downsample(Filter(obj, input, window), obj.SamplesPerSymbol);
            y = y(obj.Span+1:end-obj.Span-1);
        end
    end
%% Public Methods
end
