function [ncs,CS_array]=readCS(fpath)

file_id=fopen(fpath);
if file_id>=3
    tline=fgetl(file_id);
    tline=fgetl(file_id);
    a=textscan(tline,'%f');
    ncs=a{1}(1);          %get the number of cross-sections

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
            CS_array(i).kchfp(j)=a{1}(4);
        end
        CS_array(i).zbmin=min(CS_array(i).zb);  %lowest level of a cross-section
    end
    fclose(file_id);
end
