function [sd]=SieveSeries(od,jump)
% ��ԭʼ����od��ÿ��jump��ȡ��һ��

rows=size(od,1);
sd=od(1,:);
for i=2:1:rows
    if mod(i-1,jump)==0
        sd=[sd;od(i,:)];
    end
end