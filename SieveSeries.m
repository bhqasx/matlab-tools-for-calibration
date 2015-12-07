function [sd]=SieveSeries(od,jump)
% 从原始数据od中每隔jump行取出一行

rows=size(od,1);
sd=od(1,:);
for i=2:1:rows
    if mod(i-1,jump)==0
        sd=[sd;od(i,:)];
    end
end