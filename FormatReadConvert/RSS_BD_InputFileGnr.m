function [ws_year]=RSS_BD_InputFileGnr
%将古小联合（经验）模型产生的出入库水沙条件文件转换为RSS模型的水沙条件文件


%打开古小联合（经验）模型出入库水沙条件文件
[filename,path]=uigetfile('*.*');
f1_id=fopen([path,filename]);   %选择1GXOUT.TXT文件

tline=fgetl(f1_id);
tline=fgetl(f1_id);

%新建RSS模型的水沙条件文件
filename=['3-水沙条件-河道1.DAT'];
f2_id=fopen(filename, 'w');

%新建下泄流量过程文件
filename=['出库流量.DAT'];
f3_id=fopen(filename,'w');

fprintf(f2_id,'%s\n','****');
fprintf(f2_id,'%s\n','进口边界类型	出口边界类型	对应水位流量关系');
fprintf(f2_id,'%s\n','0	1	0');
fprintf(f2_id,'%s\n','时段	时间	进口流量	出口水位	水位控制	含沙量	级配1	级配2	级配3	级配4	级配5	级配6	级配7');
s_gradation=[65.2, 86.1, 98.6, 99.9, 100, 100, 100];

ndt=0;
ws_year=[];
fmtstr=['%d\t%d\t%f\t%.2f\t%d\t%.3f\t'];
for i=1:1:size(s_gradation,2)
   fmtstr=[fmtstr,'%.1f\t']; 
end
fmtstr=[fmtstr,'\n'];

while ~feof(f1_id)
    tline=fgetl(f1_id);
    a=textscan(tline,'%f');
    year=a{1}(1);
    ww=0.0;
    ss=0.0;
    
    %每日数据
    for i=1:1:131
        tline=fgetl(f1_id);
        a=textscan(tline,'%f');
        qIn=a{1}(2);
        qOut=a{1}(3);
        qsIn=a{1}(4);
        zDown=a{1}(9);
        
        if i<=123
            ndt=ndt+1;
            %汛期
            sIn=qsIn*1000/qIn;
            fprintf(f2_id,fmtstr,ndt,24,qIn,zDown,0,sIn,s_gradation);
            fprintf(f3_id,'%d\t%.2f\n',ndt,qOut);
            
            ww=ww+qIn*24*3600;
            ss=ss+qIn*sIn*24*3600;
        else
            %非汛期
            month=i-123;
            switch month
                case 1     %11月   
                    d_in_m=30;
                case 2     %12月
                    d_in_m=31;
                case 3     %1月
                    d_in_m=31;
                case 4     %2月
                    d_in_m=DaysFeburary(year);
                case 5     %3月
                    d_in_m=31;
                case 6     %4月
                    d_in_m=30;
                case 7     %5月
                    d_in_m=31;
                case 8     %6月
                    d_in_m=30;
            end
            sIn=qsIn*1000*10^8/d_in_m/24/3600/qIn;   %非汛期qsIn的单位是亿吨/月
            for i=1:1:d_in_m
                ndt=ndt+1;
                fprintf(f2_id,fmtstr,ndt,24,qIn,zDown,0,sIn,s_gradation);
                fprintf(f3_id,'%d\t%.2f\n',ndt,qOut);
            end
            ww=ww+qIn*d_in_m*24*3600;
            ss=ss+qIn*sIn*d_in_m*24*3600;           
        end
    end
    ws_year=[ws_year;[year,ww/10^8,ss/1000/10^8]];      %单位：亿m3, 亿吨
end

fclose(f1_id);
fclose(f2_id);
fclose(f3_id);


%--------------------------------------------------------------------------
function d=DaysFeburary(year)

if (mod(year,4)==0&&mod(year,100)~=0)||(mod(year,400)==0)
    d=29;
else
    d=28;
end