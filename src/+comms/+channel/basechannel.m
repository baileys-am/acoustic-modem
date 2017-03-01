%BASECHANNEL
    %   Description: Base class for channel models.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/27/2017
    %   Changelog:
    %     (2/27/2017) Initial commit.

classdef basechannel < handle
%% Abstract Methods
    methods(Abstract, Access=protected)
        % Applies channel effects to signal
        [] = AnalyzeInputSignal(obj, signal)
    end
    
    methods(Abstract)
        % Applies channel effects to signal
        signal = Propagate(obj, signal)
    end
%% Abstract Methods
end

