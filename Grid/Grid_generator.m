%生成用于Fortran程序的一维网格

%---------------input parameters--------------
M=320;        %number of cells
L=32;           %channel length, unit: m
base=100;         %base bed level
npt=5;          %number of points at each cross-section
width=1;           %channel width
%---------------------------------------------------

%---------cross section profile-------------
dxx=width/(npt-1);
file_id=fopen('CSProf.Dat','w');
fprintf(file_id,'%s\n','断面地形输入');
fprintf(file_id,'%d      %s\n',M,'总断面数');
for i=1:1:M
    fprintf(file_id,'%s%d\n','CS',i);
    fprintf(file_id,'%s\n','assumed         rectangular');
    fprintf(file_id,'%d        %d\n',npt,2);
    fprintf(file_id,'%d        %d\n',100,100);
    
    fprintf(file_id,'%d\t%.1f\t%.2f\t%d\n',1,0,base,1);
    for j=2:1:npt-1
        fprintf(file_id,'%d\t%.1f\t%.2f\t%d\n',j,(j-1)*dxx,base,0);
    end
    fprintf(file_id,'%d\t%.1f\t%.2f\t%d\n',npt,width,base,1);
end

%---------------cross section location-----------
dx=L/M;
fprintf(file_id,'%s\n','各断面沿程距离(km)');
fprintf(file_id,'%s\n','i     DistLg(i)');
for i=1:1:M
    x=(dx/2+(i-1)*dx)/1000;          %unit: km
    fprintf(file_id,'%d\t%E\n',i,x);
end

fprintf(file_id,'%s\n','控制断面数及号');
fprintf(file_id,'%d\n',2);
fprintf(file_id,'%s\n','i        IPCTCS(i)');
fprintf(file_id,'%d         %d\n',1,1);
fprintf(file_id,'%d         %d\n',2,2);

fclose(file_id);