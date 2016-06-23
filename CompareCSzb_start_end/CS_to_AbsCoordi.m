%得到断面测点的绝对坐标

clear;
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
CSold=struct('nodes',a,'xy',a,'zb',a,'min_xy',a,'min_idx',a);

total_nodes=0;
for ii=1:1:ncs
    tline=fgetl(file_id);
    tline=fgetl(file_id);
    rt=textscan(tline,'%f');
    CSold(ii).nodes=rt{1}(1);       %断面上的测点数    
    CSold(ii).xy=zeros(CSold(ii).nodes,2);          %断面上测点的坐标
    CSold(ii).zb=zeros(CSold(ii).nodes,1);   
    total_nodes=total_nodes+CSold(ii).nodes;       %总数据点数
    
    tline=fgetl(file_id);
    rt=textscan(tline,'%f');
    lx=rt{1}(2);            %左岸坐标，注意这里将x轴的方向变为了向东，y变为向北
    ly=rt{1}(1);
    tline=fgetl(file_id);
    rt=textscan(tline,'%f');
    rx=rt{1}(2);            %右岸坐标
    ry=rt{1}(1);
    
    cs_dir=[rx-lx,ry-ly]/norm([ry-ly,rx-lx]);       %断面方向向量
    
    %读取起点距并转为坐标
    for jj=1:1:CSold(ii).nodes
        tline=fgetl(file_id);
        rt=textscan(tline,'%f');
        CSold(ii).xy(jj,:)=[lx,ly]+rt{1}(2)*cs_dir;
        CSold(ii).zb(jj)=rt{1}(3);
    end

    [minval,CSold(ii).min_idx]=min(CSold(ii).zb);          %找到深泓点
end
fclose(file_id);
thalweg=zeros(ncs,3);
for ii=1:1:ncs
    %得到深泓线
    thalweg(ii,:)=[CSold(ii).xy(CSold(ii).min_idx,:),CSold(ii).zb(CSold(ii).min_idx)];
end

%-------用一组三维曲线画出来-------
figure;
file_id=fopen('CS_xyz.txt', 'w');
 for ii=1:1:ncs
     plot3(CSold(ii).xy(:,1),CSold(ii).xy(:,2),CSold(ii).zb,'b-d');
     hold on;
     %输出坐标文件
     for jj=1:1:CSold(ii).nodes
         fprintf(file_id,'%10.1f\t%10.1f\t%10.1f\n', CSold(ii).xy(jj,1), CSold(ii).xy(jj,2), CSold(ii).zb(jj));
         %fprintf(file_id,'%10.1f%c%10.1f%c%10.1f\n', CSold(ii).xy(jj,1),',', CSold(ii).xy(jj,2),',', CSold(ii).zb(jj));   %seperate coordinates with comma
     end
 end
 hold off;   
 line(thalweg(:,1),thalweg(:,2),thalweg(:,3));        %画出深泓线
 fclose(file_id); 
 
 %-----------------用曲面画出来----------------
 uorder=input('need to see surf plot? y/n\n', 's');
 if strcmp(uorder,'y')
     data_xy=zeros(total_nodes,2);
     data_val=zeros(total_nodes,1);

     file_id=fopen('CS_xyz.txt', 'r');
     for ii=1:1:total_nodes
         tline=fgetl(file_id);
         rt=textscan(tline,'%f');
         data_xy(ii,1)=rt{1}(1);
         data_xy(ii,2)=rt{1}(2);
         data_val(ii)=rt{1}(3);
     end 
     fclose(file_id);
     
     tri=delaunay(data_xy(:,1),data_xy(:,2));        %生成三角网格
     trisurf(tri,data_xy(:,1),data_xy(:,2),data_val);
 end
 
    