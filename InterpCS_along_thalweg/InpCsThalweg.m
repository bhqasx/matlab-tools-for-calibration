function CSnew=InpCsThalweg(dist_inp)
%�Ѹ���������0��ȫ���������������Ϻ�Զ����ֵ
%�����ļ���ʽӦ��һάFortran������Ҫ�����ͬ
%dist_inp: �����������������س̾��룬��λkm

total_nodes=0;
dist_inp=dist_inp*1000;        %ת��Ϊm
%--------------------------------����ɵ�������----------------------------
button=questdlg('��򿪾ɵĵ����ļ�','Guide','Yes');
if ~strcmp(button,'Yes')
    return;
end
[filename,path]=uigetfile('*.*');
file_id=fopen([path,filename]);
tline=fgetl(file_id);
tline=fgetl(file_id);
rt=textscan(tline,'%f');
ncs=rt{1}(1);            %��ö�������
cs_dist=zeros(ncs,1);

a=cell(1,ncs);
CSold=struct('nodes',a,'x',a,'zb',a,'min_x',a,'min_z',a,'dist',a);

for ii=1:1:ncs
    tline=fgetl(file_id);
    tline=fgetl(file_id);
    tline=fgetl(file_id);
    rt=textscan(tline,'%f');
    CSold(ii).nodes=rt{1}(1);
    total_nodes=total_nodes+rt{1}(1);         %�����ܵ����ݵ����
    CSold(ii).x=zeros(CSold(ii).nodes,1);
    CSold(ii).zb=zeros(CSold(ii).nodes,1);
    tline=fgetl(file_id);    
    
    for jj=1:1:CSold(ii).nodes
        tline=fgetl(file_id);
        rt=textscan(tline,'%f');
        CSold(ii).x(jj)=rt{1}(2);
        CSold(ii).zb(jj)=rt{1}(3);
    end
    [minval,min_i]=min(CSold(ii).zb);          %�ҵ�������
    CSold(ii).min_x=CSold(ii).x(min_i);
    CSold(ii).min_z=CSold(ii).zb(min_i); 
    
%-----------------����������----------------
    CSold(ii).x=CSold(ii).x-CSold(ii).min_x;
end
%----------------����������---------------
tline=fgetl(file_id);
tline=fgetl(file_id);
for ii=1:1:ncs
    tline=fgetl(file_id);
    rt=textscan(tline,'%f');
    cs_dist(ii)=rt{1}(2)*1000;                %��λת��
    CSold(ii).dist=cs_dist(ii);
end

%---------------------------------���е������ά����--------------------------
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
%ÿ���¶����þ��������������������֪�����ֵ
%-----------------------------------------------------------------------------------
ncs_inp=size(dist_inp,1);         %����������
a=cell(1,ncs+ncs_inp);
CSnew=struct('nodes',a,'x',a,'zb',a,'min_x',a,'min_z',a,'dist',a);
total_nodes=0;
[dist_new,idx_cs]=sort([cs_dist; dist_inp]);       %���������س̾���
for ii=1:1:ncs+ncs_inp
    if idx_cs(ii)<=ncs
        CSnew(ii)=CSold(idx_cs(ii));
    else
        for jj=1:1:ncs
            if (cs_dist(jj)<dist_new(ii))&&(cs_dist(jj+1)>dist_new(ii))
                np_inp=round((CSold(jj).nodes+CSold(jj+1).nodes)/2);            %��ֵ����Ľڵ���
                Xp=zeros(np_inp,2);
                Xp(:,1)=dist_new(ii);
                y1=interp1(cs_dist(jj:jj+1),[CSold(jj).x(1);CSold(jj+1).x(1)],dist_new(ii));
                y2=interp1(cs_dist(jj:jj+1),[CSold(jj).x(end);CSold(jj+1).x(end)],dist_new(ii));
                Xp(:,2)=linspace(y1, y2,np_inp);    
                
                Zp=griddatan(data_xy,data_val,Xp);             %��ֵ���ϵĸ߳�   
                %��ֵ������뵽�µ��μ�����
                CSnew(ii).nodes=np_inp;
                CSnew(ii).dist=dist_new(ii);
                CSnew(ii).x=Xp(:,2);
                CSnew(ii).zb=Zp;
            end
        end
    end
    
    total_nodes=total_nodes+CSnew(ii).nodes;   
end

%--------------------------------���Ʋ�ֵ���-------------------------------------
data_xy=zeros(total_nodes,2);
data_val=zeros(total_nodes,1);
count=0;
for ii=1:1:ncs+ncs_inp
    data_xy(count+1:count+CSnew(ii).nodes,1)=CSnew(ii).dist;
    data_xy(count+1:count+CSnew(ii).nodes,2)=CSnew(ii).x;
    data_val(count+1:count+CSnew(ii).nodes)=CSnew(ii).zb;
    count=count+CSnew(ii).nodes;
end

tri=delaunay(data_xy(:,1),data_xy(:,2));        %������������
trisurf(tri,data_xy(:,1),data_xy(:,2),data_val);

fclose(file_id);
%-------------------------------------������---------------------------------------
file_id=fopen('CS_interplated.dat', 'w');
fprintf(file_id,'%s\n','�����������');
fprintf(file_id,'%d\n',2*ncs-1);
for ii=1:1:ncs+ncs_inp
    fprintf(file_id,'%s\n',['CS',num2str(ii)]);
    fprintf(file_id,'%s\t%s\n', '100', '100');
    fprintf(file_id,'%d\t%d\n', CSnew(ii).nodes, 100);
    fprintf(file_id,'%s\t%s\n', '100', '100');
    
    for jj=1:1:CSnew(ii).nodes
        if jj==1
            rgh=1;              %����
        elseif jj==CSnew(ii).nodes
            rgh=1;
        else
            rgh=0;
        end
        fprintf(file_id,'%3d\t%7.2f\t%7.2f\t   %1d\n', jj, CSnew(ii).x(jj), CSnew(ii).zb(jj), rgh);
    end
end

fprintf(file_id, '%s\n', '�������س̾���');
fprintf(file_id, '%s\n', 'i      DistLg(i)');
for ii=1:1:ncs+ncs_inp
    fprintf(file_id, '%3d\t%6.3f\n', ii, CSnew(ii).dist/1000);                         %�س̾���
end

fclose(file_id);


