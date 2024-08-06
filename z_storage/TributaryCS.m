classdef TributaryCS
    properties
        numnd
        minzb
        dist
        XXIJ
        ZBIJ
        dbij
        KNIJ
    end
    
    methods
        function obj = TributaryCS()
            obj.XXIJ = [];
            obj.ZBIJ = [];
            obj.dbij = [];
            obj.KNIJ = [];
        end
        
        function obj = GetCsMinZb(obj)
            obj.minzb = min(obj.ZBIJ);
        end
    end
end
