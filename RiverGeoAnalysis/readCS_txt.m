function [ncs,CS_array]=readCS_txt(varargin)
%从txt文件中读入断面数据
%iline_npt: number of the line where the number of points at a
%cross-section is located

default_fpath='';
default_iline_npt=3;
default_iline_xy1=0;
default_iline_xy2=0;
default_nSectionHead=4;
default_nCol=4;

p=inputParser;
addOptional(p,'fpath',default_fpath);
addParameter(p,'iline_npt',default_iline_npt);
addParameter(p,'iline_xy1',default_iline_xy1); 
addParameter(p,'iline_xy2',default_iline_xy2); 
addParameter(p,'nSectionHead',default_nSectionHead); 
addParameter(p,'nCol',default_nCol); 

parse(p,varargin{:});
fpath=p.Results.fpath;
if isempty(fpath)
    [filename,path,FilterIndex]=uigetfile('*.*');
    fpath=[path,filename];    
end
iline_npt=p.Results.iline_npt;
iline_xy1=p.Results.iline_xy1;
iline_xy2=p.Results.iline_xy2;
nSectionHead=p.Results.nSectionHead;
nCol=p.Results.nCol;

% if nargin==0
%     [filename,path,FilterIndex]=uigetfile('*.*');
%     fpath=[path,filename];
%     iline_npt=3;
%     iline_xy1=0;
%     iline_xy2=0;
% elseif nargin==1
%     iline_npt=3;
%     iline_xy1=0;
%     iline_xy2=0;
% elseif nargin==2
%     iline_xy1=0;
%     iline_xy2=0;
% end

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
            if feof(file_id)||isempty(tline)
                disp('check the number of CS');
                return
            end
            
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
            CS_array(i).x(j)=a{1}(nCol-2);
            CS_array(i).zb(j)=a{1}(nCol-1);
            try
                CS_array(i).kchfp(j)=a{1}(nCol);
            catch
                warn_txt='no data for kchfp field';
            end
        end
        CS_array(i).zbmin=min(CS_array(i).zb);  %lowest level of a cross-section
    end
    fclose(file_id);
end
