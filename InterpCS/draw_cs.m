function out=draw_cs(ics)
%���£��ɺͲ�ֵ���滭����
global CSold CSnew CS_intp;
plot(CSold(ics).x,CSold(ics).zb,'-sk');
hold on;
plot(CSnew(ics).x,CSnew(ics).zb,'-sb');
hold on;
plot(CS_intp(ics).x,CS_intp(ics).zb,'-sr');
legend('old','new','interp');
hold off;

out=1;