function [y_out,m_out,d_out,vData_d]=FillData_HydroCalendar(yy,mm,vData)
%将月或年平均数据填到水文年中的每一天
%yy,mm是水文年中的年、月

y_out=[];
m_out=[];
d_out=[];
vData_d=[];
if isempty(mm)
    %只有年平均数据
    nrow=size(yy,1);
    for i=1:1:nrow
       for km=1:1:12
           if km<=6
               mm=km+6;
               nd=subday(mm,yy(i));
           else
               mm=km-6;
               nd=subday(mm,yy(i)+1);
           end
           
           y_out=[y_out;yy(i)*ones(nd,1)];
           m_out=[m_out;mm*ones(nd,1)];
           d_out=[d_out;[1:nd].'];
           vData_d=[vData_d;repmat(vData(i,:),nd,1)];
       end
    end
else
    %有月平均数据
    nrow=size(yy,1);
    if nrow~=size(mm,1)
        disp('sizes do not match');
        pause
    end
    
    for i=1:1:nrow
       if mm(i)<=6
          nd=subday(mm(i),yy(i)+1); 
       else
          nd=subday(mm(i),yy(i)); 
       end
       
       y_out=[y_out;yy(i)*ones(nd,1)];
       m_out=[m_out;mm(i)*ones(nd,1)];
       d_out=[d_out;[1:nd].'];
       vData_d=[vData_d;repmat(vData(i,:),nd,1)];
    end
end