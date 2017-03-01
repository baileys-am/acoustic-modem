%BASEMODEM
    %   Description: Class to model a modem that wraps a modulation scheme
    %   with modulator and demodulator functionality.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/22/2017
    %   Changelog:
    %     (2/22/2017) Initial commit
    %     (2/25/2017) Updated description/header.  Modulator/demodulator
    %       properties and functions have been abstracted to new classes.
    %     (2/28/2017) Renamed.  Merged mod/demod base classes into this
    %       singlular, now base class, for modems.

classdef (Abstract) basemodem < handle
%% Abstract Methods
    methods(Abstract)
        % Modulates a bit stream into mapped symbols
        symbols = Modulate(obj, bitstream)
        
        % Deodulates mapped symbols into a bitstream
        bistream = Demodulate(obj, symbols)
    end
%% Abstract Methods
end