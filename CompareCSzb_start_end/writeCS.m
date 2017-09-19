function writeCS(CS,iline_npt,iline_xy1,iline_xy2)
%iline_npt: number of the line where the number of points at a
%cross-section is located

nSectionHead=4;      %number of lines in the head of each CS data block
if nargin<2
    disp('too few input args');
    return;
elseif nargin==2
    iline_xy1=0;
    iline_xy2=0;
end

filename=['CS_Output.DAT'];
file_id=fopen(filename, 'w');

fprintf(file_id,'%s\n','******');
ncs=numel(CS);
fprintf(file_id,'%d\t%s\n',ncs,'!ncs');
for ii=1:1:ncs
    for nl=1:1:nSectionHead
        if nl==1
            fprintf(file_id,'%s\n',char(CS(ii).name));
        elseif nl==iline_npt
            fprintf(file_id,'%d\n',CS(ii).npt);
        elseif nl==iline_xy1
            fprintf(file_id,'%f\t%f\n',CS(ii).EdPt1_xy(1),CS(ii).EdPt1_xy(2));
        elseif nl==iline_xy2
            fprintf(file_id,'%f\t%f\n',CS(ii).EdPt2_xy(1),CS(ii).EdPt2_xy(2));            
        else
            fprintf(file_id,'%s\n','******');
        end
    end
    
    for jj=1:1:CS(ii).npt
        fprintf(file_id,'%d\t%f\t%f\t%d\n',jj, CS(ii).L(jj), CS(ii).zb(jj), CS(ii).kchfp(jj)); 
    end
end

%输出断面沿程距离
fprintf(file_id,'%s\n','各断面沿程距离');
fprintf(file_id,'%s\n','i            DistLg(i)');
for ii=1:1:ncs
    fprintf(file_id,'%d\t%f\t%s\n', ii, CS(ii).dist/1000, char(CS(ii).name));
end

fclose(file_id);