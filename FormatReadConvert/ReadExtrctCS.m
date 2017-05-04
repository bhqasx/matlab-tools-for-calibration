function [River]=ReadExtrctCS(ncs_out,cs_names,cs_dist)
%从原始断面文件中提取需要的断面，生成RSS模型所需的断面地形文件


%-------------------------读取原始断面成果文件--------------------
file_id=fopen('CS_RAW.txt');
ncs=0;

tline=fgetl(file_id);
while~feof(file_id)
   while strcmp(strtrim(tline),'')
       tline=fgetl(file_id);
   end
   ncs=ncs+1;
   tline=fgetl(file_id);
   
   tline=fgetl(file_id);
   a=textscan(tline,'%s%d%f%f%f%f');
   CS.name=a{1}(1);
   x=[];
   zb=[];
   while ~isempty(a{2})
       x=[x;a{3}];
       zb=[zb;a{6}];
       if feof(file_id)
           break;
       end
       tline=fgetl(file_id);
       a=textscan(tline,'%s%d%f%f%f%f');
   end
   
   CS.x=x;
   CS.zb=zb;
   CS.npt=size(x,1);
   
   CS_array(ncs)=CS;
   tline=fgetl(file_id);
end

fclose(file_id);


%-------------------------提取出需要的断面-----------------------
River.ncs=ncs_out;
b=cell(1,River.ncs);
River.CS=struct('npt',b,'x',b,'zb',b,'name',b);

for i=1:1:River.ncs
   for j=1:1:ncs
      if strcmp(CS_array(j).name,cs_names{i})
         River.CS(i)=CS_array(j); 
      end
   end
end

%---------------------------输出文本文件--------------------------
filename=['1-断面地形INI-河道.DAT'];
file_id=fopen(filename, 'w');

for i=1:1:River.ncs
    fprintf(file_id,'%d\t%d\t%f\t%s\n',i,River.CS(i).npt,cs_dist(i),char(River.CS(i).name));
    for j=1:1:River.CS(i).npt
        fprintf(file_id,'%d\t%f\t%f\t%d\n',j,River.CS(i).x(j),River.CS(i).zb(j),0);
    end
end

fclose(file_id);