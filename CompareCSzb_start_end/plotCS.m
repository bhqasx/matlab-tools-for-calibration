function plotCS(csobj,csobj2)
%csobj: a object contains info of one CS
plot(csobj.x,csobj.zb0,'bo-');
hold on;
plot(csobj.x,csobj.zbk,'ro-');

if nargin==2
    plot(csobj2.x,csobj2.zb,'go-');
    legend('start','end','after flood');
else
    legend('start','end');
end
hold off;
