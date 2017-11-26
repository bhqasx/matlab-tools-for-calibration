function [ncs,CS_array]=readCS_cell(A,iline_npt,iline_xy1,iline_xy2)
%��Ԫ���������������ݣ�Ԫ���������ͨ��xls�ļ�����õ���

nSectionHead=4;      %number of lines in the head of each CS data block
if nargin==1
    iline_npt=3;
    iline_xy1=0;
    iline_xy2=0;
elseif nargin==2
    iline_xy1=0;
    iline_xy2=0;    
end

ncs=size(A,2)/4;            %ÿ�����������ռ4��
b=cell(1,ncs);
if iline_xy1~=0&&iline_xy2~=0
    CS_array=struct('npt',b,'x',b,'zb',b,'name',b,'EdPt1_xy',b,'EdPt2_xy',b);
else
    CS_array=struct('npt',b,'x',b,'zb',b,'name',b);       %creat a struct array
end

for i=1:1:ncs
    col_start=1+(i-1)*4;
    CS_array(i).name=A{1,col_start};
    
    npt=A{2,col_start};
    CS_array(i).npt=npt;
    CS_array(i).x=zeros(npt,1);
    CS_array(i).zb=zeros(npt,1);
    
    if iline_xy1~=0&&iline_xy2~=0
        CS_array(i).EdPt1_xy=cell2mat(A(iline_xy1,:));
        CS_array(i).EdPt2_xy=cell2mat(A(iline_xy1,:));
    end
    
    try 
        CS_array(i).x=cell2mat(A(5:4+npt,col_start+1));
    catch ME
        disp(['error at i=', num2str(i), '     CS name is ',CS_array(i).name]);
        rethrow(ME);
    end
    CS_array(i).zb=cell2mat(A(5:4+npt,col_start+2));
    CS_array(i).kchfp=cell2mat(A(5:4+npt,col_start+3));
    CS_array(i).zbmin=min(CS_array(i).zb); 
    
    %����������ݺϷ���
    if numel(unique(CS_array(i).x))~=numel(CS_array(i).x)
        disp(['repeated x value in CS', num2str(i)]);
    end
end

