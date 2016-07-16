function t_rels=GetReleaseTime(qin,qout_d,Vol_tg)
%求设计下泄流量下，水库达到蓄水量目标净增值所需的时间
%qin为入库流量过程，qout_d为设计下泄流量
%Vol_tg为一段时间内入库水量减出库水量
nt=size(qin,1);
qin_sum=zeros(nt,2);
qin_sum(:,1)=qin(:,1);

qin_sum(1,2)=0.0;
for i=2:1:nt
    qin_sum(i,2)=qin_sum(i-1,2)+(qin(i-1,2)+qin(i,2))/2*(qin_sum(i,1)-qin_sum(i-1,1))*3600;
end

for i=1:1:nt-1
    v1=(qin_sum(i,1)-qin_sum(1,1))*3600*qout_d;
    v2=(qin_sum(i+1,1)-qin_sum(1,1))*3600*qout_d;
    
    net1=qin_sum(i,2)-v1;
    net2=qin_sum(i+1,2)-v2;
    
    if (net1-Vol_tg)*(net2-Vol_tg)<0.0
        break;
    end
end

qsum_grad=(qin_sum(i+1,2)-qin_sum(i,2))/(qin_sum(i+1,1)-qin_sum(i,1));
t_rels=Vol_tg-qin_sum(i,2)+qsum_grad*qin_sum(i,1)...
           -3600*qin_sum(1,1)*qout_d;
t_rels=t_rels/(qsum_grad-3600*qout_d);