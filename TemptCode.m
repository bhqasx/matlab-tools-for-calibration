%-------------------读取原始地形文件,并逆序存储到结构体变量中------------------
file_id=fopen(['cs_output.txt']);
if file_id>=3
    tline=fgetl(file_id);
    tline=fgetl(file_id);
    a=textscan(tline,'%f%s');
    ncs=a{1}(1);          %get the number of cross-sections

    b=cell(1,ncs);
    CS=struct('npt',b,'x',b,'zb',b);       %creat a struct array
    for i=1:1:ncs
        tline=fgetl(file_id);
        tline=fgetl(file_id);
        tline=fgetl(file_id);
        a=textscan(tline,'%f');
        tmp=a{1}(1);
        ireverse=i;              %read CS 
        CS(ireverse).npt=tmp;  
        CS(ireverse).x=zeros(tmp,1);
        CS(ireverse).zb=zeros(tmp,1);
        CS(ireverse).chfp=zeros(tmp,1);
        tline=fgetl(file_id);
        for j=1:1:CS(ireverse).npt
            tline=fgetl(file_id);
            a=textscan(tline,'%f');  
            CS(ireverse).x(j)=a{1}(2);
            CS(ireverse).zb(j)=a{1}(3);
            CS(ireverse).chfp(j)=a{1}(4);
        end
%         %将矩形断面改为三角形断面
%         bank_slope=1;
%         for j=1:1:5
%             CS(i).zb(j)=CS(i).zb(3)+abs(CS(i).x(j)-CS(i).x(3))*bank_slope;
%         end

        %将矩形断面改为梯形断面
        bank_slope=1;
        CS(i).zb(1)=CS(i).zb(3)+0.15*bank_slope;
        CS(i).zb(2)=CS(i).zb(3);
        CS(i).zb(4)=CS(i).zb(2);
        CS(i).zb(5)=CS(i).zb(1);
    end
    fclose(file_id);
end

%-------------------------输出各断面-----------------------------
file_id=fopen('cs_output_reversed.txt', 'w');
fprintf(file_id,'%s\n','断面地形输入');
fprintf(file_id,'%d\n',ncs);
for ii=1:1:ncs
    fprintf(file_id,'%s\n',['CS',num2str(ii)]);
    fprintf(file_id,'%s\t%s\n', '100', '100');
    fprintf(file_id,'%d\t%d\n', CS(ii).npt, 100);
    fprintf(file_id,'%s\t%s\t%s\n', '序号', '起点距','高程');
    
    for jj=1:1:CS(ii).npt
        fprintf(file_id,'%d\t%7.2f\t%7.4f\t   %1d\n', jj, CS(ii).x(jj), CS(ii).zb(jj), CS(ii).chfp(jj));
    end
end
fclose(file_id);