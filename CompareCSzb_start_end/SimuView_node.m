function [p,t,zw,zb]=SimuView_node(varargin)
%plot simulations results on a 2d mesh, including water level, bed
%elevation, velocity

defaultXlim=[-inf, inf];
defaultYlim=[-inf, inf];
validXlim=@(x) size(x,1)==1&&size(x,2)==2;
validYlim=@(x) size(x,1)==1&&size(x,2)==2;

par=inputParser;
addParameter(par,'xrange',defaultXlim,validXlim);
addParameter(par,'yrange',defaultYlim,validYlim);
parse(par,varargin{:});
xrange=par.Results.xrange;
yrange=par.Results.yrange;

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
ux=zeros(nnod,nzone_max);
uy=zeros(nnod,nzone_max);
S=zeros(nnod,nzone_max);
dzb=zeros(nnod,nzone_max);   %variation of zb compared to the initial zb

zw_lim=zeros(nzone_max,2);
for i=1:1:nnod
    tline=fgetl(file_id);
    a=textscan(tline,'%f');
    p(i,1)=a{1}(1);
    p(i,2)=a{1}(2);
    
    zw(i,nzone)=a{1}(3);
    zb(i,nzone)=a{1}(8);
    ux(i,nzone)=a{1}(4);
    uy(i,nzone)=a{1}(5);
    S(i,nzone)=a{1}(12);
    dzb(i,nzone)=a{1}(14);
end
%zw_lim(nzone,1)=min(zw(:,nzone));
%zw_lim(nzone,2)=max(zw(:,nzone));

for i=1:1:ntri
    tline=fgetl(file_id);
    a=textscan(tline,'%f');
    t(i,:)=a{1}(1:3);
end

while ~feof(file_id)
    nzone=nzone+1;
    tline=fgetl(file_id);
    a=textscan(tline,'%s','Delimiter','=');
    aa=textscan(a{1}{2},'%s%f');
    th(nzone)=aa{2}(1);
    
    for i=1:1:nnod
        tline=fgetl(file_id);
        a=textscan(tline,'%f');      
        zw(i,nzone)=a{1}(3);
        zb(i,nzone)=a{1}(8);
        ux(i,nzone)=a{1}(4);
        uy(i,nzone)=a{1}(5);
        S(i,nzone)=a{1}(12);
        dzb(i,nzone)=a{1}(14);
    end
    %zw_lim(nzone,1)=min(zw(:,nzone));
    %zw_lim(nzone,2)=max(zw(:,nzone));
end

h=figure;
ctx_menu=uicontextmenu(h);
nhit=0;
kvar=1;
set(h,'KeyPressFcn',@MyFigureCallback);
% Assign the uicontextmenu to the figure
h.UIContextMenu = ctx_menu;
% Create child menu items for the uicontextmenu
m1 = uimenu(ctx_menu,'Label','save image','Callback',@MySaveFig);

fclose(file_id); 

%---------------------nested function------------------
function MyFigureCallback(hObj,cb_data)

if strcmp(cb_data.Key,'rightarrow')
    nhit=nhit+1;
elseif strcmp(cb_data.Key,'leftarrow')
    nhit=nhit-1;
elseif strcmp(cb_data.Key,'uparrow')
    kvar=kvar+1;
elseif strcmp(cb_data.Key,'downarrow')
    kvar=kvar-1;
elseif strcmp(cb_data.Key,'space')&&(nhit>0)
    find_node_cell;
    return
end

izone=mod(nhit,nzone);
if izone==0
    izone=nzone;
end

kvar=mod(kvar,5);
if kvar==0
    kvar=5;
end

switch kvar
    case 1
        trisurf(t,p(:,1),p(:,2),zw(:,izone));
        t_str=['zw, '];
        %set(gca,'CLim',zw_lim(izone,:));
    case 2
        quiver3(p(:,1),p(:,2),400*ones(nnod,1),ux(:,izone),uy(:,izone),zeros(nnod,1),'r');
        t_str=['uv, '];        
        hold on;
        trisurf(t,p(:,1),p(:,2),dzb(:,izone));
        shading('interp');
        cbar=colorbar;
        cbar.Label.String='冲刷深度 (m)';
        cbar.Label.FontSize=16;
        hold off;
    case 3
        trisurf(t,p(:,1),p(:,2),zb(:,izone));
        t_str=['zb, '];
    case 4
        trisurf(t,p(:,1),p(:,2),S(:,izone));
        t_str=['sus, '];
    case 5
        trisurf(t,p(:,1),p(:,2),dzb(:,izone));
        t_str=['dzb, '];
end

xlim(xrange);
ylim(yrange);
t_str=[t_str,'t=',num2str(th(izone)),'   izone=',num2str(izone)];
title(t_str);
view([0,90]);

disp(nhit);

end

%---------------------nested function 2---------------------
function find_node_cell

dcm_obj = datacursormode(h);
dcm_obj.removeAllDataCursors();
set(dcm_obj,'DisplayStyle','datatip',...
    'SnapToDataVertex','on','Enable','on');

button=questdlg('Click on the nodes, then press Return.');
if ~strcmp(button,'Yes')
    return;
end
% Wait while the user does this.
pause;

%hold Alt to pick mutiple points
cursor = getCursorInfo(dcm_obj);
%---------------------find the nodes by their xy-------------------
npick=size(cursor,2);
id_nod=zeros(npick,1);
for i=1:1:npick
    for j=1:1:nnod
        if (p(j,1)==cursor(i).Position(1))&&(p(j,2)==cursor(i).Position(2))
            id_nod(i)=j;
            break;
        end
    end
end

%---------------------find the cells including the nodes-------------------
id_cell=[];
nt=size(t,1);
if npick==1
    for j=1:1:nt
        if any(t(j,:)==id_nod(1))
            id_cell=[id_cell;j];
        end
    end
elseif npick==2
    for j=1:1:nt
        if any(t(j,:)==id_nod(1))&&(any(t(j,:)==id_nod(2)))
            id_cell=[id_cell;j];
        end
    end
elseif npick==3
    for j=1:1:nt
        if any(t(j,:)==id_nod(1))&&any(t(j,:)==id_nod(2))&&any(t(j,:)==id_nod(3))
            id_cell=[id_cell;j];
            break;
        end
    end    
end

disp(id_nod);
disp(id_cell);
end

%---------------------nested function 3---------------------
function MySaveFig(hObj,cb_data)
    izone=mod(nhit,nzone);
    if izone==0
        izone=nzone;
    end
    picFilnam=['F:\文档\畛水项目验收\XLD draw down2\', 'izone_',num2str(izone)];
    %print(h,'-dpng',picFilnam);
    print(picFilnam,'-dpng');
end

end
