function [ncs,CS_array]=readCS_txt(fpath,iline_npt,iline_xy1,iline_xy2)
%从txt文件中读入断面数据
%iline_npt: number of the line where the number of points at a
%cross-section is located

nSectionHead=4;      %number of lines in the head of each CS data block
if nargin==1
    iline_npt=3;
    iline_xy1=0;
    iline_xy2=0;
elseif nargin==2
    iline_xy1=0;
    iline_xy2=0;    
end

file_id=fopen(fpath);
if file_id>=3
    tline=fgetl(file_id);
    tline=fgetl(file_id);
    a=textscan(tline,'%f');
    ncs=a{1}(1);          %get the number of cross-sections

    b=cell(1,ncs);
    if iline_xy1~=0&&iline_xy2~=0
        CS_array=struct('npt',b,'x',b,'zb',b,'name',b,'EdPt1_xy',b,'EdPt2_xy',b);
    else
        CS_array=struct('npt',b,'x',b,'zb',b,'name',b);       %creat a struct array
    end
    
    for i=1:1:ncs
        for nl=1:1:nSectionHead
            tline=fgetl(file_id);
            if nl==1
                a=textscan(tline,'%s');
                CS_array(i).name=a{1};
            elseif nl==iline_npt
                a=textscan(tline,'%f');
                tmp=a{1}(1);            %read number of points at a cross-section
                CS_array(i).npt=tmp;
                CS_array(i).x=zeros(tmp,1);
                CS_array(i).zb=zeros(tmp,1);
            elseif nl==iline_xy1
                a=textscan(tline,'%f');
                CS_array(i).EdPt1_xy=[a{1}(1),a{1}(2)];
            elseif nl==iline_xy2
                a=textscan(tline,'%f');
                CS_array(i).EdPt2_xy=[a{1}(1),a{1}(2)];
            end
        end
        
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
