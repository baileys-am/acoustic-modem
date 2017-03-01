%AWGN
    %   Description: Class for modeling AWGN channel.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/27/2017
    %   Changelog:
    %     (2/27/2017) Initial commit.
    
classdef awgn < comms.channel.basechannel
%% Properties
    properties
        PowerType = 'dB'          % Specifies units for SNR and noise power: 'dB' or 'linear'
        MeasureMode = 'measured'  % Specifies how SNR and noise power are calculated: 'measured' or 'unmeasured'
        SNR = 10                  % Signal noise ratio when MeasureMode='measured'
        NoisePower = 10           % Power of noise signal when MeasureMode='unmeasured'
    end
    
    properties (Dependent, Access=private)
        linNoisePower
    end
%% Properties

%% Property Accessors
    methods
        % pNoisePower Get Accessor
        function power = get.linNoisePower(obj)
            switch lower(obj.PowerType)
                case 'linear'
                    power = obj.NoisePower;
                case 'db'
                    power = 10^(obj.NoisePower / 10);
            end
        end
    end
%% Property Accessors

%% Protected Methods
    methods (Access=protected)
        % Applies channel effects to signal
        function [] = AnalyzeInputSignal(obj, signal)
            % Determine signal power
            signalPower = comms.measure.signalpower(signal, obj.PowerType);
            
            % Determine noise or SNR levels
            switch lower(obj.MeasureMode)
                case 'measured'
                    switch lower(obj.PowerType)
                        case 'linear'
                            obj.NoisePower = signalPower / obj.SNR;
                        case 'db'
                            obj.NoisePower = signalPower - obj.SNR;
                    end
                case 'unmeasured'
                    switch lower(obj.PowerType)
                        case 'linear'
                            obj.SNR = signalPower / obj.NoisePower;
                        case 'db'
                            obj.SNR = signalPower - obj.NoisePower;
                    end
            end
        end
    end
%% Protected Methods

%% Public Methods
    methods
        % Applies channel effects to signal
        function y = Propagate(obj, signal)
            % Update noise and SNR power properties
            obj.AnalyzeInputSignal(signal);
            
            % Create noise signal
            if(isreal(signal))
                n = sqrt(obj.linNoisePower) * randn(size(signal));
            else
                n = sqrt(obj.linNoisePower/2) * (randn(size(signal)) + 1i*randn(size(signal)));
            end
            
            % Add noise to signal
            y = signal + n;
        end
    end
%% Public Methods
end

