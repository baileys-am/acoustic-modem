%MODEM
    %   Description: Class to model a modem with independent modulator and
    %   demodulator.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/22/2017
    %   Changelog:
    %     (2/22/2017) Initial commit
    %     (2/25/2017) Updated description/header.  Modulator/demodulator
    %       properties and functions have been abstracted to new classes.

classdef modem
    properties
        Modulator                 % Modulator class
        Demodulator               % Demodulator class
    end
    
    methods
        %% Constructors
        function obj = modem()
            obj.Modulator = comms.modem.qammod;
            obj.Demodulator = comms.modem.qamdemod;
        end
    end
end