function FSD_Browse(vd_data)
%查看FlowSedimentDesign程序设计出来的水沙过程

if nargin==1
    date_y=vd_data(:,1);
    date_m=vd_data(:,2);
    vd1=vd_data(:,3:end);
else
    %同时画流量和含沙量
    [filename,path]=uigetfile('','Select a discharge or sediment concentration file');
    vd_data=importdata([path,filename]);
    date_y=vd_data(:,1);
    date_m=vd_data(:,2);
    vd1=vd_data(:,3:end);  
    
    [filename,path]=uigetfile('','Select a discharge or sediment concentration file');
    vd_data=importdata([path,filename]);
    vd2=vd_data(:,3:end);    
end

nyear=size(vd1,1)/12;
fig1=figure;
flag=0;
set(fig1,'CloseRequestFcn',{@MyCloseRequestFcn})
set(fig1,'KeyPressFcn',{@MyKeyPressF});
ky=0;

while (flag==0)
    uiwait;
end

%---------------nested function-----------------
function MyCloseRequestFcn(src,callbackdata)
    flag=1;
    delete(fig1);
end


function MyKeyPressF(hObject,eventdata)
%按任意键后画出下一年的过程

    a=exist('vd2','var');    %检查变量vd2是否存在
    
    ky=ky+1;
    if ky>nyear
        ky=ky-nyear;
    end
    v1_1y=[];
    v2_1y=[];
    for km=1:1:12
        irow=(ky-1)*12+km;
        if km<=6
            nd=subday(km+6,date_y(irow));
        else
            nd=subday(km-6,date_y(irow)+1);
        end
        v1_1y=[v1_1y,vd1(irow,1:nd)];
        if a==1
            v2_1y=[v2_1y,vd2(irow,1:nd)];
        end
    end
    nd_1m=size(v1_1y,2);
    yyaxis left;
    plot(1:nd_1m,v1_1y);
    title(num2str(date_y(irow)));
    
    yyaxis right;
    plot(1:nd_1m,v2_1y);
end

end


    