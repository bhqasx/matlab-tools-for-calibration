function CSnew=InpCsThalweg(dist_inp)
%把各断面起点距0点全部对齐在深泓线上后对断面插值
%地形文件格式应与一维Fortran程序中要求的相同
%dist_inp: 列向量，插入断面的沿程距离，单位km

total_nodes=0;
dist_inp=dist_inp*1000;        %转换为m
%--------------------------------输入旧地形资料----------------------------
button=questdlg('请打开旧的地形文件','Guide','Yes');
if ~strcmp(button,'Yes')
    return;
end
[filename,path]=uigetfile('*.*');
file_id=fopen([path,filename]);
tline=fgetl(file_id);
tline=fgetl(file_id);
rt=textscan(tline,'%f');
ncs=rt{1}(1);            %获得断面数量
cs_dist=zeros(ncs,1);

a=cell(1,ncs);
CSold=struct('nodes',a,'x',a,'zb',a,'min_x',a,'min_z',a,'dist',a);

for ii=1:1:ncs
    tline=fgetl(file_id);
    tline=fgetl(file_id);
    tline=fgetl(file_id);
    rt=textscan(tline,'%f');
    CSold(ii).nodes=rt{1}(1);
    total_nodes=total_nodes+rt{1}(1);         %计算总的数据点个数
    CSold(ii).x=zeros(CSold(ii).nodes,1);
    CSold(ii).zb=zeros(CSold(ii).nodes,1);
    tline=fgetl(file_id);    
    
    for jj=1:1:CSold(ii).nodes
        tline=fgetl(file_id);
        rt=textscan(tline,'%f');
        CSold(ii).x(jj)=rt{1}(2);
        CSold(ii).zb(jj)=rt{1}(3);
    end
    [minval,min_i]=min(CSold(ii).zb);          %找到深泓点
    CSold(ii).min_x=CSold(ii).x(min_i);
    CSold(ii).min_z=CSold(ii).zb(min_i); 
    
%-----------------对齐深泓点----------------
    CSold(ii).x=CSold(ii).x-CSold(ii).min_x;
end
%----------------读入断面距离---------------
tline=fgetl(file_id);
tline=fgetl(file_id);
for ii=1:1:ncs
    tline=fgetl(file_id);
    rt=textscan(tline,'%f');
    cs_dist(ii)=rt{1}(2)*1000;                %单位转换
    CSold(ii).dist=cs_dist(ii);
end

%---------------------------------所有点输入二维数组--------------------------
data_xy=zeros(total_nodes,2);
data_val=zeros(total_nodes,1);
count=0;
for ii=1:1:ncs
    data_xy(count+1:count+CSold(ii).nodes,1)=cs_dist(ii);
    data_xy(count+1:count+CSold(ii).nodes,2)=CSold(ii).x;
    data_val(count+1:count+CSold(ii).nodes)=CSold(ii).zb;
    count=count+CSold(ii).nodes;
end

%----------------------------------------------------------------------------------
%每个新断面用距离其最近的相邻两个已知断面插值
%-----------------------------------------------------------------------------------
ncs_inp=size(dist_inp,1);         %插入断面个数
a=cell(1,ncs+ncs_inp);
CSnew=struct('nodes',a,'x',a,'zb',a,'min_x',a,'min_z',a,'dist',a);
total_nodes=0;
[dist_new,idx_cs]=sort([cs_dist; dist_inp]);       %重新排列沿程距离
for ii=1:1:ncs+ncs_inp
    if idx_cs(ii)<=ncs
        CSnew(ii)=CSold(idx_cs(ii));
    else
        for jj=1:1:ncs
            if (cs_dist(jj)<dist_new(ii))&&(cs_dist(jj+1)>dist_new(ii))
                np_inp=round((CSold(jj).nodes+CSold(jj+1).nodes)/2);            %插值断面的节点数
                Xp=zeros(np_inp,2);
                Xp(:,1)=dist_new(ii);
                y1=interp1(cs_dist(jj:jj+1),[CSold(jj).x(1);CSold(jj+1).x(1)],dist_new(ii));
                y2=interp1(cs_dist(jj:jj+1),[CSold(jj).x(end);CSold(jj+1).x(end)],dist_new(ii));
                Xp(:,2)=linspace(y1, y2,np_inp);    
                
                Zp=griddatan(data_xy,data_val,Xp);             %插值点上的高程   
                %插值结果输入到新地形集合中
                CSnew(ii).nodes=np_inp;
                CSnew(ii).dist=dist_new(ii);
                CSnew(ii).x=Xp(:,2);
                CSnew(ii).zb=Zp;
            end
        end
    end
    
    total_nodes=total_nodes+CSnew(ii).nodes;   
end

%--------------------------------绘制插值结果-------------------------------------
data_xy=zeros(total_nodes,2);
data_val=zeros(total_nodes,1);
count=0;
for ii=1:1:ncs+ncs_inp
    data_xy(count+1:count+CSnew(ii).nodes,1)=CSnew(ii).dist;
    data_xy(count+1:count+CSnew(ii).nodes,2)=CSnew(ii).x;
    data_val(count+1:count+CSnew(ii).nodes)=CSnew(ii).zb;
    count=count+CSnew(ii).nodes;
end

tri=delaunay(data_xy(:,1),data_xy(:,2));        %生成三角网格
trisurf(tri,data_xy(:,1),data_xy(:,2),data_val);

fclose(file_id);
%-------------------------------------输出结果---------------------------------------
file_id=fopen('CS_interplated.dat', 'w');
fprintf(file_id,'%s\n','断面地形输入');
fprintf(file_id,'%d\n',2*ncs-1);
for ii=1:1:ncs+ncs_inp
    fprintf(file_id,'%s\n',['CS',num2str(ii)]);
    fprintf(file_id,'%s\t%s\n', '100', '100');
    fprintf(file_id,'%d\t%d\n', CSnew(ii).nodes, 100);
    fprintf(file_id,'%s\t%s\n', '100', '100');
    
    for jj=1:1:CSnew(ii).nodes
        if jj==1
            rgh=1;              %糙率
        elseif jj==CSnew(ii).nodes
            rgh=1;
        else
            rgh=0;
        end
        fprintf(file_id,'%3d\t%7.2f\t%7.2f\t   %1d\n', jj, CSnew(ii).x(jj), CSnew(ii).zb(jj), rgh);
    end
end

fprintf(file_id, '%s\n', '各断面沿程距离');
fprintf(file_id, '%s\n', 'i      DistLg(i)');
for ii=1:1:ncs+ncs_inp
    fprintf(file_id, '%3d\t%6.3f\n', ii, CSnew(ii).dist/1000);                         %沿程距离
end

fclose(file_id);


