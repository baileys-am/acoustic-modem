%MODULATOR
    %   Description: Base class for a modulator.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Changelog:
    %     (2/25/2017) Initial commit.
    
classdef (Abstract) modulator
%% Abstract Methods
    methods(Abstract)
        % Modulates a bit stream into mapped symbols
        symbols = Modulate(obj, bitstream)
    end
%% Abstract Methods
end