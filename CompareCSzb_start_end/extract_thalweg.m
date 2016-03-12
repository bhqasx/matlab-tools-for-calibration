function [dist,zbed]=extract_thalweg(handles)
%画纵剖面
button=questdlg('请地形文件','Guide','Yes');
if ~strcmp(button,'Yes')
    return;
end
[filename,path,FilterIndex]=uigetfile('MultiSelect','on');

if iscellstr(filename)
    [dist,zbed]=MultiFiles(filename,path);  
else
    [dist,zbed]=OneFile(filename);
end


%------------------处理一个完整的地形文件---------------
function [dist,zbed]=OneFile(filename)

file_id=fopen(filename);
if file_id>=3
    tline=fgetl(file_id);
    tline=fgetl(file_id);
    a=textscan(tline,'%f');
    ncs=a{1}(1);          %get the number of cross-sections
    zbmin=zeros(ncs,1);
    b=cell(1,ncs);
    CS_array=struct('npt',b,'x',b,'zb',b);       %creat a struct array
    for i=1:1:ncs
        tline=fgetl(file_id);
        tline=fgetl(file_id);
        tline=fgetl(file_id);
        a=textscan(tline,'%f');
        tmp=a{1}(1);            %read number of points at a cross-section
        CS_array(i).npt=tmp;  
        CS_array(i).x=zeros(tmp,1);
        CS_array(i).zb=zeros(tmp,1);
        tline=fgetl(file_id);
        for j=1:1:CS_array(i).npt
            tline=fgetl(file_id);
            a=textscan(tline,'%f');  
            CS_array(i).x(j)=a{1}(2);
            CS_array(i).zb(j)=a{1}(3);
        end
        zbmin(i)=min(CS_array(i).zb); 
        CS_array(i).zbmin=zbmin(i);  %lowest level of a cross-section
    end
    
    tline=fgetl(file_id);
    tline=fgetl(file_id);
    for i=1:1:ncs
        tline=fgetl(file_id);
        a=textscan(tline,'%f');         %distance of each cross-section
        CS_array(i).dist=a{1}(1);
    end
    
    dist=arrayfun(@(x)x.dist,CS_array);
    zbed=arrayfun(@(x)x.zbmin,CS_array);         %operation to structure array
    fclose(file_id);
end


%---------------处理多个断面文件并合成一个地形文件--------------
function [dist,zbed]=MultiFiles(filename,path)

ncs=size(filename,2);       %get the number of cross-sections
b=cell(1,ncs);
CS_array=struct('npt',b,'x',b,'zb',b);       %creat a struct array

for i=1:1:ncs
    cs_filepath=[path,filename{i}];
    file_id=fopen(cs_filepath);
    if file_id>=3
        tline=fgetl(file_id);
        tline=fgetl(file_id);
        tline=fgetl(file_id);
        tline=fgetl(file_id);
        tline=fgetl(file_id);
        a=textscan(tline,'%f');
        tmp=a{1}(1);            %read number of points at a cross-section
        CS_array(i).npt=tmp;  
        CS_array(i).x=zeros(tmp,1);
        CS_array(i).zb=zeros(tmp,1);       
        
        for j=1:1:CS_array(i).npt
            tline=fgetl(file_id);
            a=textscan(tline,'%f');  
            CS_array(i).x(j)=a{1}(1);
            CS_array(i).zb(j)=a{1}(2);
        end
        CS_array(i).zbmin=min(CS_array(i).zb);  %lowest level of a cross-section        
        
        fclose(file_id);
    end
end

dist=' ';              %暂时不管
zbed=arrayfun(@(x)x.zbmin,CS_array);         %operation to structure array
    
    