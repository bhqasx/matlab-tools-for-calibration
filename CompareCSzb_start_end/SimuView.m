function SimuView
%plot simulations results on a 2d mesh, including water level, bed
%elevation, velocity
nzone_max=1000;
th=zeros(nzone_max,1);

[filename,path,FilterIndex]=uigetfile('','Choose a file of simulation results');
file_id=fopen([path,filename]);

nzone=1;
tline=fgetl(file_id);
tline=fgetl(file_id);
a=textscan(tline,'%s','Delimiter','=');
aa=textscan(a{1}{2},'%s%f');
th(nzone)=aa{2}(1);
aa=textscan(a{1}{3},'%f');
nnod=aa{1}(1);       %get number of nodes
aa=textscan(a{1}{4},'%f');
ntri=aa{1}(1);          %get number of triangles

p=zeros(nnod,2);
t=zeros(ntri,3);
zw=zeros(nnod,nzone_max);     %water level
zb=zeros(nnod,nzone_max);      %bed elevation
for i=1:1:nnod
    tline=fgetl(file_id);
    a=textscan(tline,'%f');
    p(i,1)=a{1}(1);
    p(i,2)=a{1}(2);
    
    zw(i,nzone)=a{1}(3);
    zb(i,nzone)=a{1}(8);
end
for i=1:1:ntri
    tline=fgetl(file_id);
    a=textscan(tline,'%f');
    t(i,:)=a{1}(1:3);
end

while ~feof(file_id)
    nzone=nzone+1;
    tline=fgetl(file_id);
    tline=fgetl(file_id);
    a=textscan(tline,'%s','Delimiter','=');
    aa=textscan(a{1}{2},'%s%f');
    th(nzone)=aa{2}(1);
    
    for i=1:1:nnod
        tline=fgetl(file_id);
        a=textscan(tline,'%f');      
        zw(i,nzone)=a{1}(3);
        zb(i,nzone)=a{1}(8);
    end
    for i=1:1:ntri
        tline=fgetl(file_id);
    end
end

h=figure;
nhit=0;
set(h,'KeyPressFcn',@MyFigureCallback);

fclose(file_id); 

%---------------------nested function------------------
function MyFigureCallback(hObj,cb_data)

if strcmp(cb_data.Key,'rightarrow')
    nhit=nhit+1;
    izone=mod(nhit,nzone);
    trisurf(t,p(:,1),p(:,2),zw(:,izone));
    title(th(izone));
    hold on;
%     trisurf(t,p(:,1),p(:,2),zb(:,izone));
    hold off;
end

disp(nhit);

end

end
