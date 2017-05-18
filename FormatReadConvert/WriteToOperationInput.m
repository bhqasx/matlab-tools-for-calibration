function WriteToOperationInput(nyear)
%��FlowSedimentDesign������Ƶ������չ����޸Ĺ�С���ϵ��Ⱦ���ģ�͵������ļ�
%���nyear<60��Ҫ�ڱ��������ɵ��ļ�ĩβ����ʣ�����ݲ����ڹ�С���ϵ��Ⱦ���ģ��������

[filename,path]=uigetfile('*.*','ѡ����Ƶ�С�˵���������');
f1_id=fopen([path,filename]); 
[filename,path]=uigetfile('*.*','ѡ����Ƶ�С�˵���ɳ�ʹ���');
f4_id=fopen([path,filename]); 

[filename,path]=uigetfile('*.*','ѡ���С���ϵ���ģ���е������ļ�');
f2_id=fopen([path,filename]);    %ѡ��LHHZ60.DAT
tline=fgetl(f2_id);
tline=fgetl(f2_id);

f3_id=fopen('LHHZ60.DAT','w');
fprintf(f3_id,'%s\n','������״��վ��ˮɳ����');
fprintf(f3_id,'%s\n','data	ql	qa	qe	qz	qsl	qsa	qse	qsz');

for i=1:1:nyear
    q_1y=[];
    qs_1y=[];
    
    %����7��8��9��10������
    for j=1:1:4
        if j==3
            nd=30;
        else
            nd=31;
        end
        
        tline=fgetl(f1_id);
        a=textscan(tline,'%f');
        q_1y=[q_1y;a{1}(3:2+nd)];
        tline=fgetl(f4_id);
        a=textscan(tline,'%f');
        qs_1y=[qs_1y;a{1}(3:2+nd)];
    end
    
    %����11-6������
    for j=1:1:8
        tline=fgetl(f1_id);
        a=textscan(tline,'%f');
        
        switch j
            case 1     %11��
                nd=30;
            case 2     %12��
                nd=31;
            case 3     %1��
                nd=31;
            case 4     %2��
                nd=DaysFeburary(a{1}(1)+1);
            case 5     %3��
                nd=31;
            case 6     %4��
                nd=30;
            case 7     %5��
                nd=31;
            case 8     %6��
                nd=30;
        end
        
        q_1y=[q_1y;sum(a{1}(3:2+nd))/nd];   %��ƽ������
        
        tline=fgetl(f4_id);
        a=textscan(tline,'%f');
        
        qs_1y=[qs_1y;sum(a{1}(3:2+nd)*24*3600/1E8)];   %��Ѵ����ɳ�ʵĵ�λ���ڶ�/��
    end
    
    tline=fgetl(f2_id);
    fprintf(f3_id,'%s\n',tline);
    for j=1:1:131
        tline=fgetl(f2_id);
        a=textscan(tline,'%f');
        
        a{1}(2)=q_1y(j);
        a{1}(6)=qs_1y(j);
        fmtstr=[];
        for k=1:1:9
            fmtstr=[fmtstr,'\t%f'];
        end
        fprintf(f3_id,[fmtstr,'\n'],a{1}(1:9));
    end
end

fclose(f1_id);
fclose(f2_id);
fclose(f3_id);
fclose(f4_id);


%--------------------------------------------------------------------------
function d=DaysFeburary(year)

if (mod(year,4)==0&&mod(year,100)~=0)||(mod(year,400)==0)
    d=29;
else
    d=28;
end