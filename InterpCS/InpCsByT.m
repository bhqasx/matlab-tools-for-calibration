%提供一个时间参数在同一段面新旧两个状态间插值
%地形文件格式应与一维Fortran程序中要求的相同
clear all;
alphaT=0.95;              %时间参数，可调
ncs=13;                      %需要进行插值的断面数量，可调
global CSold CSnew CS_intp;

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
ncs_old=rt{1}(1);            %获得断面数量

a=cell(1,ncs);
CSold=struct('nodes',a,'x',a,'zb',a);

for ii=1:1:ncs
    tline=fgetl(file_id);
    tline=fgetl(file_id);
    tline=fgetl(file_id);
    rt=textscan(tline,'%f');
    CSold(ii).nodes=rt{1}(1);
    CSold(ii).x=zeros(CSold(ii).nodes,1);
    CSold(ii).zb=zeros(CSold(ii).nodes,1);
    tline=fgetl(file_id);    
    
    for jj=1:1:CSold(ii).nodes
        tline=fgetl(file_id);
        rt=textscan(tline,'%f');
        CSold(ii).x(jj)=rt{1}(2);
        CSold(ii).zb(jj)=rt{1}(3);
    end
end

%--------------------------------输入新地形资料----------------------------
button=questdlg('请打开新的地形文件','Guide','Yes');
if ~strcmp(button,'Yes')
    return;
end
filename=uigetfile;
file_id=fopen(filename);
tline=fgetl(file_id);
tline=fgetl(file_id);
rt=textscan(tline,'%f');
ncs_new=rt{1}(1);            %获得断面数量

a=cell(1,ncs);
CSnew=struct('nodes',a,'x',a,'zb',a);

for ii=1:1:ncs
    tline=fgetl(file_id);
    tline=fgetl(file_id);
    tline=fgetl(file_id);
    rt=textscan(tline,'%f');
    CSnew(ii).nodes=rt{1}(1);
    CSnew(ii).x=zeros(CSnew(ii).nodes,1);
    CSnew(ii).zb=zeros(CSnew(ii).nodes,1);
    tline=fgetl(file_id);    
    
    for jj=1:1:CSnew(ii).nodes
        tline=fgetl(file_id);
        rt=textscan(tline,'%f');
        CSnew(ii).x(jj)=rt{1}(2);
        CSnew(ii).zb(jj)=rt{1}(3);
    end
end

%------------------------------------------插值------------------------------------
a=cell(1,ncs);
CS_intp=struct('nodes',a,'x',a,'zb',a);

for ii=1:1:ncs
    nd_flag=1;
    CS_intp(ii).nodes=CSnew(ii).nodes;
    CS_intp(ii).x=zeros(CS_intp(ii).nodes,1);
    CS_intp(ii).zb=zeros(CS_intp(ii).nodes,1);
    for jj=1:1:CSnew(ii).nodes
        for kk=nd_flag:1:CSold(ii).nodes
            if (CSnew(ii).x(jj)<CSold(ii).x(1))||(CSnew(ii).x(jj)>CSold(ii).x(end))
                CS_intp(ii).x(jj)=CSnew(ii).x(jj);
                CS_intp(ii).zb(jj)=CSnew(ii).zb(jj);
                break;
            end
            
            if (CSnew(ii).x(jj)>=CSold(ii).x(kk))&&(CSnew(ii).x(jj)<=CSold(ii).x(kk+1))
                nd_flag=kk;           %赋值新的比较端点
                zb_old=CSold(ii).zb(kk)+(CSold(ii).zb(kk+1)-CSold(ii).zb(kk))/(CSold(ii).x(kk+1)-CSold(ii).x(kk))*(CSnew(ii).x(jj)-CSold(ii).x(kk));
                zb_new=CSnew(ii).zb(jj);
                
                CS_intp(ii).x(jj)=CSnew(ii).x(jj);
                CS_intp(ii).zb(jj)=zb_old+(zb_new-zb_old)*alphaT;
                break;
            end
        end
    end
end

ii=1;
out=draw_cs(ii);
% c_char='w';
% 
% while  (c_char~='q')&&(ii<=ncs)
%        c_char=get(gcf,'CurrentCharacter');
%        if c_char=='n'
%            c_char='w';
%            ii=ii+1;
%            out=draw(ii);
%        end
% end

