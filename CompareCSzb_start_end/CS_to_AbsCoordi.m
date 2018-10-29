function CSold=CS_to_AbsCoordi(CSold)
%得到断面测点的绝对坐标


if nargin==1
    ncs=numel(CSold);
end

if nargin==0
    %--------------------------------输入旧地形资料----------------------------
    button=questdlg('请打开旧的地形文件','Guide','Yes');
    if ~strcmp(button,'Yes')
        return;
    end
    [filename,path]=uigetfile('*.*');
    
    prompt={'iline_npt','iline_xy1', 'iline_xy2'};
    user_in=inputdlg(prompt);
    [ncs,CSold]=readCS_txt([path,filename], str2num(user_in{1}), str2num(user_in{2}), str2num(user_in{3}));
end   

for ii=1:1:ncs
    CSold(ii).xy=zeros(CSold(ii).npt,2);
    lx=CSold(ii).EdPt1_xy(2);
    ly=CSold(ii).EdPt1_xy(1);
    rx=CSold(ii).EdPt2_xy(2);
    ry=CSold(ii).EdPt2_xy(1);
    cs_dir=[rx-lx,ry-ly]/norm([ry-ly,rx-lx]);
    
    for jj=1:1:CSold(ii).npt
        CSold(ii).xy(jj,:)=[lx,ly]+CSold(ii).x(jj)*cs_dir;
    end
    [minval,CSold(ii).min_idx]=min(CSold(ii).zb);   
end


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
     for jj=1:1:CSold(ii).npt
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
 
    