function WriteToOperationInput(nyear)
%用FlowSedimentDesign程序设计的龙门日过程修改古小联合调度经验模型的输入文件
%如果nyear<60，要在本程序生成的文件末尾补充剩余的年份才能在古小联合调度经验模型中运行

[filename,path]=uigetfile('*.*','选择设计的小浪底流量过程');
f1_id=fopen([path,filename]); 
[filename,path]=uigetfile('*.*','选择设计的小浪底输沙率过程');
f4_id=fopen([path,filename]); 

[filename,path]=uigetfile('*.*','选择古小联合调度模型中的输入文件');
f2_id=fopen([path,filename]);    %选择LHHZ60.DAT
tline=fgetl(f2_id);
tline=fgetl(f2_id);

f3_id=fopen('LHHZ60.DAT','w');
fprintf(f3_id,'%s\n','龙华河状四站日水沙资料');
fprintf(f3_id,'%s\n','data	ql	qa	qe	qz	qsl	qsa	qse	qsz');

for i=1:1:nyear
    q_1y=[];
    qs_1y=[];
    
    %读入7、8、9、10月数据
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
    
    %读入11-6月数据
    for j=1:1:8
        tline=fgetl(f1_id);
        a=textscan(tline,'%f');
        
        switch j
            case 1     %11月
                nd=30;
            case 2     %12月
                nd=31;
            case 3     %1月
                nd=31;
            case 4     %2月
                nd=DaysFeburary(a{1}(1)+1);
            case 5     %3月
                nd=31;
            case 6     %4月
                nd=30;
            case 7     %5月
                nd=31;
            case 8     %6月
                nd=30;
        end
        
        q_1y=[q_1y;sum(a{1}(3:2+nd))/nd];   %月平均流量
        
        tline=fgetl(f4_id);
        a=textscan(tline,'%f');
        
        qs_1y=[qs_1y;sum(a{1}(3:2+nd)*24*3600/1E8)];   %非汛期输沙率的单位是亿吨/月
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