function dm=MedianDiameter(d_sieve,psedi_mtx)
%calculate the median diameter of sorted sediment. d_sieve is a row vector
%of sieve diameters, the unit of dm is the same as d_sieve. psedi_mtx are
%the percentages smaller than each sieve diamater

ddd=log10(d_sieve).';
rows=size(psedi_mtx,1);
dm=zeros(rows,1);
for i=1:1:rows
    dm(i)=interp_qs(psedi_mtx(i,:).', ddd, 50);
    dm(i)=10^dm(i);
end
