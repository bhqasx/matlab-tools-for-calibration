classdef Tributary
    properties
        numcs
        Nocs      %距离该支流口门最近的干流断面号
        Dtodam
        minzb
        CsDist
        csdx
        cszbmn
        zw
        storage
        AreaSf
        tbycs
    end
    
    methods
        function obj = Tributary()
            obj.CsDist = [];
            obj.csdx = [];
            obj.cszbmn = [];
            obj.zw = [];
            obj.storage = [];
            obj.AreaSf = [];
            obj.tbycs = TributaryCS.empty;
        end
        
        function obj = GetTbyMinZb(obj)
            mz = obj.tbycs(1).minzb;
            for i = 1:obj.numcs
                if obj.tbycs(i).minzb < mz
                    mz = obj.tbycs(i).minzb;
                end
            end
            obj.minzb = mz;
        end
        
        function obj = GetThalwegZb(obj)
            obj.cszbmn = zeros(1, obj.numcs);
            for i = 1:obj.numcs
                obj.cszbmn(i) = obj.tbycs(i).minzb;
            end
        end
        
        function obj = SetZw(obj, num, zmax)
            dz = (zmax - obj.minzb) / (num - 1);
            if dz < 0.0
                error('zmax < zmin');
            end
            
            obj.zw = obj.minzb:dz:zmax;
            obj.storage = zeros(1, num);
            obj.AreaSf = zeros(1, num);
        end
    end
end
