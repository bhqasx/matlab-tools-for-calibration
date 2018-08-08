function nse=nash_sutcliffe(meas, calc)
%get the nash_sutcliffe coefficient
%the first col of meas is t, the second col is measured data
%the first col of calc is t, the second col is calculated/predicted data

tc=calc(:,1);
dc=calc(:,2);
[nrow,ncol]=size(meas);
calc2=zeros(nrow,1);   %the calculated data corresponding to measuring time
for i=1:1:nrow
    calc2(i)=interp_qs(tc,dc,meas(i,1));
end
m_meas=mean(meas(:,2));
nse=1-sum((meas(:,2)-calc2).^2)/sum((meas(:,2)-m_meas).^2);
