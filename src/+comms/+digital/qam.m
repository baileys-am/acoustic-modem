%QAM
    %   Description: Class for modeling QAM modulation.
    
%VERSIONING
    %   Author: Steven Cantrell
    %   Date Created: 2/25/2017
    %   Changelog:
    %     (2/25/2017) Initial commit.
    %     (2/25/2017) Corrected property attributes. Added symbol mapping.
    %       Moved GetConstellation to property. Removed class abstract
    %       attribute.
    %     (2/26/2017) Added GetRandomSymbols method. Fixed constellation
    %       for different M sizes.
    %     (2/28/2017) Subclasses 'handle' class.
    
classdef qam < handle
%% Properties
    properties(Constant, Access=private)
        dM = 4                       % Default alphabet size
        dSymbolOrder = 'Binary'      % Default symbol order
    end
    
    properties(SetAccess=private)
        Constellation = []           % Symbol alphabet
        SymbolMapping = []           % Symbol to bit mapping
    end
    
    properties
        M                            % Symbol alphabet size
        SymbolOrder                  % Order to determine symbol mapping
    end
%% Properties
    
%% Public Methods
    methods
        % Constructor
        function obj = qam()
            obj.M = obj.dM;
            obj.SymbolOrder = obj.dSymbolOrder;
        end
        
        % M Get Accessor
        function M = get.M(obj)
            M = obj.M;
        end
        
        % M Set Accessor
        function obj = set.M(obj, val)
            if mod(log2(val), 2) ~= 0
                error('log2(M) must be even')
            end
            obj.M = val;
        end
        
        % SymbolOrder Get Accessor
        function SymbolOrder = get.SymbolOrder(obj)
            SymbolOrder = obj.SymbolOrder;
        end
        
        % SymbolOrder Set Accessor
        function obj = set.SymbolOrder(obj, val)
            switch lower(val)
                case {'binary'}
                    obj.SymbolOrder = val;
                otherwise
                    error('Incorrect SymbolOrder. Choose from: Binary');
            end
        end
        
        % Constellation Get Accessor
        function constellation = get.Constellation(obj)
            pamConstellation = [-sqrt(obj.M)+1:2:-1, 1:2:sqrt(obj.M)-1];
            constellationMat = repmat(pamConstellation, length(pamConstellation), 1) + 1i*repmat(flip(pamConstellation)', 1, length(pamConstellation));
            constellation = reshape(constellationMat, [1, numel(constellationMat)]);
        end
        
        % SymbolMapping Get Accessor
        function mapping = get.SymbolMapping(obj)
            switch lower(obj.SymbolOrder)
                case {'binary'}
                    mapping = 0:obj.M-1;
                otherwise
                    error('Incorrect SymbolOrder. Set SymbolOrder to: Binary');
            end
        end
        
        % Create random vector of symbols with length of L
        function symbols = GetRandomSymbols(obj, L)
            symbols = obj.Constellation(ceil(obj.M * rand(1, L)));
        end
    end
%% Public Methods
end