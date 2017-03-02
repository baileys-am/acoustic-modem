%BASEFILTER
    %   Description: Base class for filters.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 3/1/2017
    %   Changelog:
    %     (3/1/2017) Initial commit

classdef (Abstract) basefilter < handle
%% Properties
    properties (Abstract)
        ImpulseResponse
        Delay
    end
%% Properties  

%% Public Methods
    methods
        % Filters signal
        function y = Filter(obj, input, window)
            h = obj.ImpulseResponse;
            if (size(window) == size(input))
                h = obj.ImpulseResponse .* window;
            end
            
            y = conv(input, h);
        end
    end
%% Public Methods
end
