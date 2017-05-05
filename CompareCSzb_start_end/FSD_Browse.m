function FSD_Browse(vd_data)
%查看FlowSedimentDesign程序设计出来的水沙过程

date_y=vd_data(:,1);
date_m=vd_data(:,2);
vd=vd_data(:,3:end);

nyear=size(vd,1)/12;
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
    ky=ky+1;
    if ky>nyear
        ky=ky-nyear;
    end
    v_1m=[];
    for km=1:1:12
        irow=(ky-1)*12+km;
        if km<=6
            nd=subday(km+6,date_y(irow));
        else
            nd=subday(km-6,date_y(irow)+1);
        end
        v_1m=[v_1m,vd(irow,1:nd)];
    end
    nd_1m=size(v_1m,2);
    plot(1:nd_1m,v_1m);
    title(num2str(date_y(irow)));
end

end


%----------------------------------------------------------
function nd=subday(mm,yy)
%计算水文年中第km个月的天数

if mm==2
    if (mod(yy,4)==0&&mod(yy,100)~=0)||(mod(yy,400)==0)
        nd=29;
    else
        nd=28;
    end
elseif mm==4||mm==6||mm==9||mm==11
    nd=30;
else
    nd=31;
end

end
    