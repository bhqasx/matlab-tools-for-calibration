function writeCS2xls(fpath, CS, sheetName)
%write CS to xls file

ndate=numel(CS);

nrow=0;

for i=1:1:ndate
    if CS(i).npt>nrow
        nrow=CS(i).npt;
    end
end

xlsdata=NaN(nrow+1, 2*ndate);

for i=1:1:ndate
    npt=CS(i).npt;
    xlsdata(1,2*i-1)=CS(i).date;
    xlsdata(2:npt+1, 2*i-1)=CS(i).x;
    xlsdata(2:npt+1, 2*i)=CS(i).zb;
end

%try use current folder in fpath if writing failed
writematrix(xlsdata, fpath, 'Sheet', sheetName);
fclose all;