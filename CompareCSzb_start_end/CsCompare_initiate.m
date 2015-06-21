function handles=CsCompare_initiate(handles)
%compare the initial and final profile of each cross-section
global CS;
global CS_af;         %cross-sections after flood
file_id=fopen(['CSZBnd.TXT']);
tline=fgetl(file_id);
tline=fgetl(file_id);
a=textscan(tline,'%s%f');
ncs=a{2}(1);          %get the number of cross-sections
set(handles.slider1,'Min',1);          %set slider initial starte
set(handles.slider1,'Max',ncs);
set(handles.slider1,'Value',1);
set(handles.slider1,'SliderStep',[1/(ncs-1),1/(ncs-1)]);
b=cell(1,ncs);
CS=struct('npt',b,'x',b,'zb0',b,'zbk',b);       %creat a struct array
tline=fgetl(file_id);
for i=1:1:ncs
    tline=fgetl(file_id);
    a=textscan(tline,'%d');
    tmp=a{1}(1);
    CS(i).npt=tmp;
    CS(i).x=zeros(tmp,1);
    CS(i).zb0=zeros(tmp,1);
    CS(i).zbk=zeros(tmp,1);
end
tline=fgetl(file_id);
tline=fgetl(file_id);
tline=fgetl(file_id);
for i=1:1:ncs
    tline=fgetl(file_id);
    tline=fgetl(file_id);
    for j=1:1:CS(i).npt
        tline=fgetl(file_id);
        a=textscan(tline,'%f');
        CS(i).x(j)=a{1}(3);          %read distance of a measuring point at a CS
        CS(i).zb0(j)=a{1}(4);
        CS(i).zbk(j)=a{1}(5);
    end
end
        
fclose(file_id);

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
        tline=fgetl(file_id);
        for j=1:1:CS_af(ireverse).npt
            tline=fgetl(file_id);
            a=textscan(tline,'%f');  
            CS_af(ireverse).x(j)=a{1}(2);
            CS_af(ireverse).zb(j)=a{1}(3);
        end
    end
    fclose(file_id);
end