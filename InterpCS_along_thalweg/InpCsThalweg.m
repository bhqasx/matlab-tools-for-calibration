%把各断面起点距0点全部对齐在深泓线上后对断面插值
%地形文件格式应与一维Fortran程序中要求的相同
clear all;
global CSold CSnew;

total_nodes=0;
%--------------------------------输入旧地形资料----------------------------
button=questdlg('请打开旧的地形文件','Guide','Yes');
if ~strcmp(button,'Yes')
    return;
end
filename=uigetfile;
file_id=fopen(filename);
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
%每次在相邻两个断面间插值处一个新断面
%-----------------------------------------------------------------------------------
a=cell(1,2*ncs-1);
CSnew=struct('nodes',a,'x',a,'zb',a,'min_x',a,'min_z',a,'dist',a);
total_nodes=0;
for ii=1:1:ncs-1
    CSnew(2*ii-1)=CSold(ii);
    total_nodes=total_nodes+CSold(ii).nodes;
    
    dist_inp=(cs_dist(ii)+cs_dist(ii+1))/2;         %插值处的距离
    np_inp=round((CSold(ii).nodes+CSold(ii+1).nodes)/2);            %插值断面的节点数
    Xp=zeros(np_inp,2);
    Xp(:,1)=dist_inp;
    Xp(:,2)=linspace((CSold(ii).x(1)+CSold(ii+1).x(1))/2, (CSold(ii).x(end)+CSold(ii+1).x(end))/2,np_inp);
    
    Zp=griddatan(data_xy,data_val,Xp);             %插值点上的高程
    %插值结果输入到新地形集合中
    CSnew(2*ii).nodes=np_inp;
    CSnew(2*ii).dist=dist_inp;
    CSnew(2*ii).x=Xp(:,2);
    CSnew(2*ii).zb=Zp;
    total_nodes=total_nodes+np_inp;
end
CSnew(2*ncs-1)=CSold(ncs);
total_nodes=total_nodes+CSold(ncs).nodes;

%--------------------------------绘制插值结果-------------------------------------
data_xy=zeros(total_nodes,2);
data_val=zeros(total_nodes,1);
count=0;
for ii=1:1:2*ncs-1
    data_xy(count+1:count+CSnew(ii).nodes,1)=CSnew(ii).dist;
    data_xy(count+1:count+CSnew(ii).nodes,2)=CSnew(ii).x;
    data_val(count+1:count+CSnew(ii).nodes)=CSnew(ii).zb;
    count=count+CSnew(ii).nodes;
end

tri=delaunay(data_xy(:,1),data_xy(:,2));
trisurf(tri,data_xy(:,1),data_xy(:,2),data_val);




