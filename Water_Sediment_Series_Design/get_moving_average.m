function [y_out,a_wfd,a_wa,a_sfd,a_sa]=get_moving_average(years,w_fd,w_a,s_fd,s_a,ny)
%w_fd，w_a分别为汛期和全年水量。s_fa,w_a分别为汛期和全年沙量
%ny是平均的时段长度（年）

ylen=size(years,1);
if ny>ylen
    disp('invalid ny');
    return;
end

y_out=cell(ylen,1);
a_wfd=zeros(ylen,1);
a_wa=zeros(ylen,1);
a_sfd=zeros(ylen,1);
a_sa=zeros(ylen,1);

for i=1:1:ylen
   if i+ny-1<=ylen
       y_select=[i:i+ny-1];
       y_out{i}=[num2str(years(i)),'~',num2str(years(i+ny-1))];
   else
       a1=i;
       a2=ylen;
       a3=1;
       a4=ny-(ylen-i)-1;
       y_select=[a1:a2,a3:a4];
       y_out{i}=[num2str(years(a1)),'~',num2str(years(a2)),'+',num2str(years(a3)),'~',num2str(years(a4))];
   end
   
   a_wfd(i)=sum(w_fd(y_select))/ny;
   a_wa(i)=sum(w_a(y_select))/ny;
   a_sfd(i)=sum(s_fd(y_select))/ny;
   a_sa(i)=sum(s_a(y_select))/ny;
end
y_out=char(y_out);
