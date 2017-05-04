function [ws_year]=RSS_BD_InputFileGnr
%����С���ϣ����飩ģ�Ͳ����ĳ����ˮɳ�����ļ�ת��ΪRSSģ�͵�ˮɳ�����ļ�


%�򿪹�С���ϣ����飩ģ�ͳ����ˮɳ�����ļ�
[filename,path]=uigetfile('*.*');
f1_id=fopen([path,filename]);   %ѡ��1GXOUT.TXT�ļ�

tline=fgetl(f1_id);
tline=fgetl(f1_id);

%�½�RSSģ�͵�ˮɳ�����ļ�
filename=['3-ˮɳ����-�ӵ�1.DAT'];
f2_id=fopen(filename, 'w');

%�½���й���������ļ�
filename=['��������.DAT'];
f3_id=fopen(filename,'w');

fprintf(f2_id,'%s\n','****');
fprintf(f2_id,'%s\n','���ڱ߽�����	���ڱ߽�����	��Ӧˮλ������ϵ');
fprintf(f2_id,'%s\n','0	1	0');
fprintf(f2_id,'%s\n','ʱ��	ʱ��	��������	����ˮλ	ˮλ����	��ɳ��	����1	����2	����3	����4	����5	����6	����7');
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
    
    %ÿ������
    for i=1:1:131
        tline=fgetl(f1_id);
        a=textscan(tline,'%f');
        qIn=a{1}(2);
        qOut=a{1}(3);
        qsIn=a{1}(4);
        zDown=a{1}(9);
        
        if i<=123
            ndt=ndt+1;
            %Ѵ��
            sIn=qsIn*1000/qIn;
            fprintf(f2_id,fmtstr,ndt,24,qIn,zDown,0,sIn,s_gradation);
            fprintf(f3_id,'%d\t%.2f\n',ndt,qOut);
            
            ww=ww+qIn*24*3600;
            ss=ss+qIn*sIn*24*3600;
        else
            %��Ѵ��
            month=i-123;
            switch month
                case 1     %11��   
                    d_in_m=30;
                case 2     %12��
                    d_in_m=31;
                case 3     %1��
                    d_in_m=31;
                case 4     %2��
                    d_in_m=DaysFeburary(year);
                case 5     %3��
                    d_in_m=31;
                case 6     %4��
                    d_in_m=30;
                case 7     %5��
                    d_in_m=31;
                case 8     %6��
                    d_in_m=30;
            end
            sIn=qsIn*1000*10^8/d_in_m/24/3600/qIn;   %��Ѵ��qsIn�ĵ�λ���ڶ�/��
            for i=1:1:d_in_m
                ndt=ndt+1;
                fprintf(f2_id,fmtstr,ndt,24,qIn,zDown,0,sIn,s_gradation);
                fprintf(f3_id,'%d\t%.2f\n',ndt,qOut);
            end
            ww=ww+qIn*d_in_m*24*3600;
            ss=ss+qIn*sIn*d_in_m*24*3600;           
        end
    end
    ws_year=[ws_year;[year,ww/10^8,ss/1000/10^8]];      %��λ����m3, �ڶ�
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