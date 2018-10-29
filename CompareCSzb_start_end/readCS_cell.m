function [ncs,CS_array]=readCS_cell(A,nhd,iline_npt,varargin)
%��Ԫ���������������ݣ�Ԫ���������ͨ��xls�ļ�����õ���
%ǰ����������������     

defaultIxy1=0;     %����˵��������ڵ���
defaultIxy2=0;
defaultNcol=4;    %ÿһ�����������ռ����

p=inputParser;
addRequired(p,'A');
addRequired(p,'nhd');    %number of lines in the head of each CS data block
addRequired(p,'iline_npt');
addParameter(p,'iline_xy1',defaultIxy1);     %����Ϊname-valule pair
addParameter(p,'iline_xy2',defaultIxy2);
validNcol=@(x) x==4||x==2;      %ÿ�����������ֻ��4�л�2��
addParameter(p,'ncol',defaultNcol,validNcol);
parse(p,A,nhd,iline_npt,varargin{:});
iline_xy1=p.Results.iline_xy1;
iline_xy2=p.Results.iline_xy2;
ncol=p.Results.ncol;     %ÿ�����������ռ����

ncs=size(A,2)/ncol;            
nrow_max=size(A,1);
b=cell(1,ncs);
if iline_xy1~=0&&iline_xy2~=0
    CS_array=struct('npt',b,'x',b,'zb',b,'name',b,'EdPt1_xy',b,'EdPt2_xy',b);
else
    CS_array=struct('npt',b,'x',b,'zb',b,'name',b);       %creat a struct array
end

for i=1:1:ncs
    col_start=1+(i-1)*ncol;
    CS_array(i).name=A{1,col_start};
    
    if iline_xy1~=0&&iline_xy2~=0
        CS_array(i).EdPt1_xy=cell2mat(A(iline_xy1, col_start:col_start+1));
        CS_array(i).EdPt2_xy=cell2mat(A(iline_xy2, col_start:col_start+1));
    end    
    
    if iline_npt~=0
        %-----------�Ѿ�ָ����ÿ�����������----------
        npt=A{iline_npt,col_start};
        CS_array(i).npt=npt;
        CS_array(i).x=zeros(npt,1);
        CS_array(i).zb=zeros(npt,1);
        
        if ncol==4
            try
                CS_array(i).x=cell2mat(A(nhd+1:nhd+npt,col_start+1));
            catch ME
                disp(['error at i=', num2str(i), '     CS name is ',CS_array(i).name]);
                rethrow(ME);
            end
            CS_array(i).zb=cell2mat(A(nhd+1:nhd+npt,col_start+2));
            CS_array(i).kchfp=cell2mat(A(nhd+1:nhd+npt,col_start+3));
        elseif ncol==2
            try
                CS_array(i).x=cell2mat(A(nhd+1:nhd+npt,col_start));
            catch ME
                disp(['error at i=', num2str(i), '     CS name is ',CS_array(i).name]);
                rethrow(ME);
            end
            CS_array(i).zb=cell2mat(A(nhd+1:nhd+npt,col_start+1));
        end
    else
        %-----------δָ��ÿ���������������Ҫ���ж�ȡ----------
        npt=0;
        iline=nhd+1;
        while iline<=nrow_max&&~isempty(A{iline,col_start}) 
            npt=npt+1;
            if ncol==4
                CS_array(i).x(npt)=A{iline,col_start+1};
                CS_array(i).zb(npt)=A{iline,col_start+2};
                CS_array(i).kchfp(npt)=A{iline,col_start+3};
            elseif ncol==2
                CS_array(i).x(npt)=A{iline,col_start};
                CS_array(i).zb(npt)=A{iline,col_start+1};
            end
            iline=iline+1;
        end
        CS_array(i).npt=npt;
        
        CS_array(i).x=(CS_array(i).x).';
        CS_array(i).zb=(CS_array(i).zb).';
        if isfield(CS_array(i),'kchfp')
            CS_array(i).kchfp=(CS_array(i).kchfp).';
        end
    end
    CS_array(i).zbmin=min(CS_array(i).zb); 
    
    %����������ݺϷ���
    if numel(unique(CS_array(i).x))~=numel(CS_array(i).x)
        disp(['repeated x value in CS', num2str(i), '. name is ', CS_array(i).name]);
    end
end


%********************************************************
%nested function
%********************************************************



end

