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
%% Properties
    properties(Abstract)
        Alphabet
    end
    properties
        DataType = 'integer'           % Input stream type (bit or integer)
    end
%% Properties

%% Abstract Methods
    methods(Abstract)
        % Modulates a bit stream into mapped symbols
        symbols = Modulate(obj, bitstream)
        
        % Deodulates mapped symbols into a bitstream
        bistream = Demodulate(obj, symbols)
    end
%% Abstract Methods

%% Public Methods
    methods
        % M Get Accessor
        function DataType = get.DataType(obj)
            DataType = obj.DataType;
        end

        % M Set Accessor
        function obj = set.DataType(obj, val)
            if (~strcmpi(val,'bit') && ~strcmpi(val,'integer'))
                error('DatType must be "bit" or "integer".');
            end
            obj.DataType = lower(val);
        end
    end
%% Public Methods
end