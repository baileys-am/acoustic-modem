%SINCPULSE
    %   Description: Models sinc pulse shaping filter.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 3/1/2017
    %   Changelog:
    %     (3/1/2017) Initial commit

classdef sincpulse < comms.filter.basepulse
%% Properties
    properties
        ImpulseResponse
        Delay
        CutoffFrequency
    end
%% Properties
    
%% Public Methods
    methods
        % Constructor
        function obj = sincpulse()
        end
        
        % M Get Accessor
        function ir = get.ImpulseResponse(obj)
            ir = sinc(2*pi*obj.CutoffFrequency*(-obj.Delay:obj.Delay)/obj.SamplesPerSymbol);
        end
    end
%% Public Methods
end
