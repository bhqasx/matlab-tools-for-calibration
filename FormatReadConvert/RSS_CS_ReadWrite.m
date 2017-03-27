function [Rivers]=RSS_CS_ReadWrite
%���ϵ�RSSģ�Ͷ������ļ������Ϊ�°汾RSSģ�͵ĵ����ļ�


%----------------------��ȡ�ϵ�RSSģ�͵����ļ�-------------------------------
[filename,path,FilterIndex]=uigetfile('*.*');
file_id=fopen([path,filename]);

tline=fgetl(file_id);
a=textscan(tline,'%f');
nriv=a{1}(1);          %get the number of rivers

b=cell(1,nriv);
Rivers=struct('ncs',b,'numbr',b,'CS',b);       

for i=1:1:nriv
    tline=fgetl(file_id);
    a=textscan(tline,'%f');
    Rivers(i).ncs=a{1}(1);    %get the number of cross-sections
    Rivers(i).numbr=a{1}(2);  %��i���������ӵ��ĸ���������
    
    b=cell(1,Rivers(i).ncs);
    Rivers(i).CS=struct('npt',b,'dx',b,'x',b,'x_label',b,'zb',b,'nzone1',b,'name',b);
    Rivers(i).CS(1).dist=0.0;
    
    for j=1:1:Rivers(i).ncs
        tline=fgetl(file_id);
        a=textscan(tline,'%f%f%f%s');
        Rivers(i).CS(j).npt=a{2};
        Rivers(i).CS(j).x_label=a{3};
        Rivers(i).CS(j).name=a{4};
        x=zeros(Rivers(i).CS(j).npt,1);
        zb=zeros(Rivers(i).CS(j).npt,1);
        nzone1=zeros(Rivers(i).CS(j).npt,1);
        if j>1
            %�������
            %Rivers(i).CS(j).dist=Rivers(i).CS(j-1).dist+Rivers(i).CS(j).dx/1000;
            Rivers(i).CS(j).dist=Rivers(i).CS(j-1).dist+abs(Rivers(i).CS(j).x_label-Rivers(i).CS(j-1).x_label);
        end
        
        for k=1:1:Rivers(i).CS(j).npt
            tline=fgetl(file_id);
            a=textscan(tline,'%f');
            x(k)=a{1}(2);
            zb(k)=a{1}(3);
            nzone1(k)=a{1}(4);
        end
        
        Rivers(i).CS(j).x=x;
        Rivers(i).CS(j).zb=zb;
        Rivers(i).CS(j).nzone1=nzone1;
    end
end

fclose(file_id);

%----------------------���Ϊ�°汾RSSģ�͵����ļ�---------------------------
Rivers(1).numbr=[0,0,0];
for i=2:1:nriv
   Rivers(i).numbr=[1,Rivers(i).numbr,1]; 
end
Rivers(1).name='��������';
Rivers(2).name='μ��';
Rivers(3).name='�����';

for i=1:1:nriv
   filename=['1-�������INI-�ӵ�',num2str(i),'.DAT'];
   file_id=fopen(filename, 'w');
   
   fprintf(file_id,'%d\t%s\n',i,Rivers(i).name);
   fprintf(file_id,'%d\t%d\t%d\t%d\n',Rivers(i).ncs,Rivers(i).numbr(1),Rivers(i).numbr(2),Rivers(i).numbr(3));
   
   for j=1:1:Rivers(i).ncs
       fprintf(file_id,'%d\t%d\t%f\t%s\n',j,Rivers(i).CS(j).npt,Rivers(i).CS(j).dist,Rivers(i).CS(j).name{1});
       for k=1:1:Rivers(i).CS(j).npt
           fprintf(file_id,'%d\t%f\t%f\t%d\n',k,Rivers(i).CS(j).x(k),Rivers(i).CS(j).zb(k),Rivers(i).CS(j).nzone1(k));
       end
   end
   fclose(file_id);
end