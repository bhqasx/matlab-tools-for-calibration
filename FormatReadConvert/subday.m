function nd=subday(mm,yy)
%�����������е�mm���µ�����

if mm==2
    if (mod(yy,4)==0&&mod(yy,100)~=0)||(mod(yy,400)==0)
        nd=29;
    else
        nd=28;
    end
elseif mm==4||mm==6||mm==9||mm==11
    nd=30;
else
    nd=31;
end