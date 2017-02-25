%QAM
    %   Description: Base class for QAM modulator and demodulator.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Version: 1
    %       (2/25/2017) Initial commit.
    
classdef (Abstract) qam
%% Properties
    properties(Constant, Access=private)
        dM = 4                       % Default alphabet size
    end
    
    properties(Access=private)
        pM                           % Symbol alphabet size
    end
    
    properties(SetAccess=private)
        Constellation = []           % Symbol alphabet
    end
    
    properties(Dependent)
        M                            % Symbol alphabet size
    end
%% Properties
    
%% Public Methods
    methods
        % Constructor
        function obj = qam()
            obj.M = obj.dM;
        end
        
        % M Get Accessor
        function M = get.M(obj)
            M = obj.pM;
        end
        
        % M Set Accessor
        function obj = set.M(obj, val)
            if mod(log2(val), 2) ~= 0
                error('log2(M) must be even')
            end
            obj.pM = val;
            obj.Constellation = obj.GetConstellation(obj.pM);
        end
    end
%% Public Methods

%% Static Methods
    methods(Static)
        % Creates QAM alphabet
        function constellation = GetConstellation(M)
            if mod(log2(M), 2) ~= 0
                error('log2(M) must be even')
            end
            pamConstellation = [-1*log2(M)-1:2:-1, 1:2:1*log2(M)+1];
            constellation = repmat(pamConstellation, length(pamConstellation), 1) + 1i*repmat(flip(pamConstellation)', 1, length(pamConstellation));
        end
    end
%% Static Methods
end