function handles=CsCompare_initiate(handles)
%compare the initial and final profile of each cross-section
global CS;
global CS_af;         %cross-sections after flood

%----------��ȡ��һ�������ļ�����ʽ�����fortranģ�������CSZBnd.TXT---------
button=questdlg('��ѡ������ļ�','Guide','Yes');
if ~strcmp(button,'Yes')
    return;
end
[filename,path,FilterIndex]=uigetfile('*.*');
[pathstr,name,ext] = fileparts(filename);
if strcmp(ext,'.mat')
    load([path,filename],'River');
    CS=River(1).CS;      %Ŀǰÿ��ִ��ֻ�ܿ�һ���ӵ����ж���
    if isfield(River(1),'ncs')
        ncs=River(1).ncs;
    else
        ncs=numel(River(1).CS);
    end
    for i=1:1:ncs
        CS(i).zb0=CS(i).zb;
        CS(i).zbk=CS(i).zb;
    end
    CS=rmfield(CS,'zb');
else    
    [ncs,CS]=readCS_txt('fpath', [path, filename]);
    for i=1:1:ncs
        CS(i).zb0=CS(i).zb;
        CS(i).zbk=CS(i).zb;
    end
    CS=rmfield(CS,'zb');
end

set(handles.slider1,'Min',1);          %set slider initial starte
set(handles.slider1,'Max',ncs);
set(handles.slider1,'Value',1);
set(handles.slider1,'SliderStep',[1/(ncs-1),1/(ncs-1)]);


%-------------------------------��ȡ�ڶ��������ļ�---------------------------
button=questdlg('��ѡ��Ѵ����ٻ�ƽ������ļ�','Guide','Yes');
if ~strcmp(button,'Yes')
    return;
end
[filename,path]=uigetfile('*.*');
[pathstr,name,ext] = fileparts(filename);

if strcmp(ext,'.mat')
    load([path,filename],'Rivers');
    CS_af=Rivers(1).CS;
    set(handles.checkbox_AfterFlood,'Enable','on');
else
    file_id=fopen(['AfterFlood.TXT']);
    if file_id>=3
        set(handles.checkbox_AfterFlood,'Enable','on');
        tline=fgetl(file_id);
        a=textscan(tline,'%s%f');
        ncs2=a{2}(1);          %get the number of cross-sections
        if ncs2~=ncs
            disp('CS numbers not equal, please stop');
            pause;
        end
        b=cell(1,ncs);
        CS_af=struct('npt',b,'x',b,'zb',b);       %creat a struct array
        for i=1:1:ncs
            tline=fgetl(file_id);
            tline=fgetl(file_id);
            tline=fgetl(file_id);
            a=textscan(tline,'%f');
            tmp=a{1}(1);
            ireverse=1+ncs-i;              %read CS info in reversed order
            CS_af(ireverse).npt=tmp;
            CS_af(ireverse).x=zeros(tmp,1);
            CS_af(ireverse).zb=zeros(tmp,1);
            CS_af(ireverse).chfp=zeros(tmp,1);
            tline=fgetl(file_id);
            for j=1:1:CS_af(ireverse).npt
                tline=fgetl(file_id);
                a=textscan(tline,'%f');
                CS_af(ireverse).x(j)=a{1}(2);
                CS_af(ireverse).zb(j)=a{1}(3);
                CS_af(ireverse).chfp(j)=a{1}(4);
            end
        end
        fclose(file_id);
    end
end