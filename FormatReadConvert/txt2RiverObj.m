function River=txt2RiverObj(ncs,n_headline,nline_csMeta,idx_npt,idx_dist)
%ͨ�ö�����ȡ���򣬴�txt�ļ��еõ�River�ṹ��
%n_headline: �������ݿ�֮ǰ���ı�����
%nline_csMeta: �������ݿ���Ԫ���ݵ�����
%idx_npt: 1*2���飬��ʾ����������Ϣ�ڶ������ݿ�Ԫ�������ڵ�λ��
%idx_dist: 1*2���飬��ʾ���������Ϣ�ڶ������ݿ�Ԫ�������ڵ�λ��

[filename,path]=uigetfile('*.*');
file_id=fopen([path,filename]);

River.ncs=ncs;
b=cell(1,River.ncs);
River.CS=struct('npt',b,'x',b,'zb',b,'dist',b);

for i=1:1:n_headline
   tline=fgetl(file_id); 
end

for i=1:1:ncs
   %��ȡ����Ԫ����
   for j=1:1:nline_csMeta
      tline=fgetl(file_id); 
      if j==idx_npt(1,1)
         a=textscan(tline,'%s');
         River.CS(i).npt=str2num(a{1}{idx_npt(1,2)});
      end
      
      if ~isempty(idx_dist)
         if j==idx_dist(1,1)
             a=textscan(tline,'%s');
             River.CS(i).dist=str2num(a{1}{idx_dist(1,2)});
         end
      end
   end
   
   River.CS(i).x=zeros(River.CS(i).npt,1);
   River.CS(i).zb=zeros(River.CS(i).npt,1);
   
   %��ȡÿ�������
   for j=1:1:River.CS(i).npt
      tline=fgetl(file_id);
      a=textscan(tline,'%s');
      River.CS(i).x(j)=str2num(a{1}{2});
      River.CS(i).zb(j)=str2num(a{1}{3});
   end
end

fclose(file_id);