function flag=Grid_generator(x, zb, precision)
%��������Fortran�����һά����
%x (m) is longitudinal coordinate
%precision is the number of digits after the decimal point

%---------------input parameters--------------
M=numel(zb);        %number of cells
if nargin==2
    precision=2;
end

npt=7;          %number of points at each cross-section
width=1.2;           %channel width
%---------------------------------------------------

%---------cross section profile-------------
dxx=width/(npt-1);
file_id=fopen('CSProf.Dat','w');
fprintf(file_id,'%s\n','�����������');
fprintf(file_id,'%d       %d      %s\n',M, npt+1, '!�ܶ�����      �����������ڵ����');
for i=1:1:M
    fprintf(file_id,'%s%d\n','CS',i);
    fprintf(file_id,'%s\n','assumed         rectangular');
    fprintf(file_id,'%d        %d\n',npt,2);
    fprintf(file_id,'%d        %d\n',100,100);
    
    fprintf(file_id,['%d\t%.1f\t%.',num2str(precision),'f\t%d\n'],1,0,zb(i),1);
    for j=2:1:npt-1
        fprintf(file_id,['%d\t%.1f\t%.',num2str(precision),'f\t%d\n'],j,(j-1)*dxx,zb(i),0);
    end
    fprintf(file_id,['%d\t%.1f\t%.',num2str(precision),'f\t%d\n'],npt,width,zb(i),1);
end

%---------------cross section location-----------
fprintf(file_id,'%s\n','�������س̾���(km)');
fprintf(file_id,'%s\n','i     DistLg(i)');
x=x/1000;   % m to km
for i=1:1:M
    fprintf(file_id,'%d\t%E\n',i,x(i));
end

fprintf(file_id,'%s\n','���ƶ���������');
fprintf(file_id,'%d\n',2);
fprintf(file_id,'%s\n','i        IPCTCS(i)');
fprintf(file_id,'%d         %d\n',1,1);
fprintf(file_id,'%d         %d\n',2,M);

fclose(file_id);
flag=1;