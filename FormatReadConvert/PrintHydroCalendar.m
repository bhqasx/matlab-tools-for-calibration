function date=PrintHydroCalendar(ystart,yend)
%顺序打印出水文年中的年月日

date=[];
for ky=ystart:1:yend
    for km=1:1:12
        if km<=6
            mm=km+6;
            nd=subday(mm,ky);
        else
            mm=km-6;
            nd=subday(mm,ky+1);
        end
        
        date_1m=zeros(nd,3);
        date_1m(:,1)=ky;
        date_1m(:,2)=mm;
        date_1m(:,3)=[1:nd].';
        
        date=[date;date_1m];
    end
end


