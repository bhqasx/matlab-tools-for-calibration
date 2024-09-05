% 主程序
clear;
clc;

NumTBY = input('Input the number of tributary: ');
tby = Tributary.empty(NumTBY, 0);

row_npt = input("Input the line number of points at a cross section: ");
ncol=input("Input the number of columns: ");

Fullnam = 'TBCSPf.dat';
fid = fopen(Fullnam, 'r');
fgetl(fid);  % Skip the first line

for K = 1:NumTBY
    fgetl(fid); fgetl(fid);
    data = textscan(fgetl(fid), '%d %d %d %f');
    K1 = data{1}; tby(K).numcs = data{2}; tby(K).Nocs = data{3}; tby(K).Dtodam = data{4};
    fgetl(fid);
    
    tby(K).tbycs = TributaryCS.empty(tby(K).numcs, 0);
    tby(K).CsDist = zeros(1, tby(K).numcs);
    tby(K).csdx = zeros(1, tby(K).numcs-1);
    
    for I = 1:tby(K).numcs
        numnd = 0;
        for row = 1:4
            if row == row_npt
                numnd = textscan(fgetl(fid), '%d');
                numnd = numnd{1};
            else
                fgetl(fid);
            end
        end
        
        tby(K).tbycs(I) = TributaryCS();
        tby(K).tbycs(I).numnd = numnd;
        tby(K).tbycs(I).XXIJ = zeros(1, numnd);
        tby(K).tbycs(I).ZBIJ = zeros(1, numnd);
        tby(K).tbycs(I).KNIJ = zeros(1, numnd);
        tby(K).tbycs(I).dbij = zeros(1, numnd-1);
        
        for J = 1:numnd
            if ncol==3
                data = textscan(fgetl(fid), '%f %f %f');

                tby(K).tbycs(I).XXIJ(J) = data{1};
                tby(K).tbycs(I).ZBIJ(J) = data{2};
                tby(K).tbycs(I).KNIJ(J) = data{3};
            elseif ncol==4
                data = textscan(fgetl(fid), '%d %f %f %f');

                tby(K).tbycs(I).XXIJ(J) = data{2};
                tby(K).tbycs(I).ZBIJ(J) = data{3};
                tby(K).tbycs(I).KNIJ(J) = data{4};
            else
                disp("invalid ncol");
                pause;                
            end
        end
    end
    
    fgetl(fid);  % Skip 'Specification' line
    for I = 1:tby(K).numcs
            line=fgetl(fid);
            data = textscan(line, '%d %f %s');
            IX = data{1}; tby(K).CsDist(I) = data{2};
            tby(K).tbycs(I).dist = tby(K).CsDist(I);
    end
end

fclose(fid);

for K = 1:NumTBY
    for I = 1:tby(K).numcs-1
        tby(K).csdx(I) = (tby(K).CsDist(I+1) - tby(K).CsDist(I)) * 1000.0;
    end
    
    for I = 1:tby(K).numcs
        for J = 1:tby(K).tbycs(I).numnd-1
            tby(K).tbycs(I).dbij(J) = tby(K).tbycs(I).XXIJ(J+1) - tby(K).tbycs(I).XXIJ(J);
            if tby(K).tbycs(I).dbij(J) <= 0.0
                tby(K).tbycs(I).XXIJ(J+1) = tby(K).tbycs(I).XXIJ(J+1) + 0.1;
            end
        end
    end
    
    for I = 1:tby(K).numcs
        tby(K).tbycs(I) = tby(K).tbycs(I).GetCsMinZb();
    end
    tby(K) = tby(K).GetTbyMinZb();
    tby(K) = tby(K).GetThalwegZb();
end

numzv = 23;
zw_max = input('Input the highest water level: ');

for K = 1:NumTBY
    tby(K) = tby(K).SetZw(numzv, zw_max);
end

user_c = input('Need to modify the range of water level for a particular tributary? (y/n): ', 's');
if strcmp(user_c, 'y')
    K = input('Input the index of the tributary: ');
    user_r = input(sprintf('Input the highest water level of tributary %d: ', K));
    tby(K) = tby(K).SetZw(numzv, user_r);
end

for N = 1:NumTBY
    for K = 1:numzv
        Aatz = 0.0;
        VatZ = 0.0;
        for I = 1:tby(N).numcs-1
            [Vol2cs, Asf2cs] = Comp2CsVol(tby(N).tbycs(I), tby(N).tbycs(I+1), tby(N).zw(K));
            VatZ = VatZ + Vol2cs;
            Aatz = Aatz + Asf2cs;
        end
        
        if tby(N).tbycs(1).minzb > tby(N).zw(K)
            VatZ = 0.0;
        end
        
        tby(N).storage(K) = VatZ;
        tby(N).AreaSf(K) = Aatz;
    end
end

% 保存数据到Excel文件中，其中每个sheet对应一个支流
filename = 'LevelStorage.xlsx';
if exist(filename, 'file')
    delete(filename);
end

for K = 1:NumTBY
    sheetname = sprintf('Tributary%d', K);
    T = table(tby(K).zw', tby(K).storage', tby(K).AreaSf', 'VariableNames', {'WaterLevel', 'Storage', 'SurfaceArea'});
    extraInfo = table([tby(K).numcs], [tby(K).Nocs], [tby(K).minzb], 'VariableNames', {'numcs', 'Nocs', 'zb_entrance'}); 

    % Write extraInfo at the top of each sheet
    writetable(extraInfo, filename, 'Sheet', sheetname, 'Range', 'A1');
    % Write T below extraInfo
    writetable(T, filename, 'Sheet', sheetname, 'Range', 'A5');
end
