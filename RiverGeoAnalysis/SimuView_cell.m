function SimuView_cell
%plot simulations results for each cell

nzone_max=500;
th=zeros(nzone_max,1);

[filename,path,FilterIndex]=uigetfile('','Choose a file of simulation results');
file_id=fopen([path,filename]);

nzone=1;
tline=fgetl(file_id);
tline=fgetl(file_id);
tline=fgetl(file_id);
a=textscan(tline,'%s%f');
th(nzone)=a{2}(1);
ntri=a{2}(3);          %get number of triangles

xcell=zeros(ntri,1);
ycell=zeros(ntri,1);
ux=zeros(ntri,nzone_max);
uy=zeros(ntri,nzone_max);

tline=fgetl(file_id);
for i=1:1:ntri
    tline=fgetl(file_id);
    a=textscan(tline,'%f');
    xcell(i)=a{1}(2);
    ycell(i)=a{1}(3);
    
    ux(i,nzone)=a{1}(7);
    uy(i,nzone)=a{1}(8);    
end

while ~feof(file_id)
    nzone=nzone+1;
    tline=fgetl(file_id);
    tline=fgetl(file_id);
    a=textscan(tline,'%s%f');
    th(nzone)=a{2}(1);
    tline=fgetl(file_id);
    
    for i=1:1:ntri
        tline=fgetl(file_id);
        a=textscan(tline,'%f');
        
        ux(i,nzone)=a{1}(7);
        uy(i,nzone)=a{1}(8);
    end
end

h=figure;
nhit=0;
set(h,'KeyPressFcn',@PlotCellCallback);

fclose(file_id); 

%---------------------nested function------------------
function PlotCellCallback(hObj,cb_data)

if strcmp(cb_data.Key,'rightarrow')
    nhit=nhit+1;
    izone=mod(nhit,nzone);
    if izone==0
        izone=nzone;
    end
    t_str=['istep=',num2str(th(izone)),'   izone=',num2str(izone)];    
    quiver(xcell,ycell,ux(:,izone),uy(:,izone));
    title(t_str);
end

end

end
