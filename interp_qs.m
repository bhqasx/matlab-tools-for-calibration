function ry=interp_qs(xx,yy,x)
%��������ʱ���Ժ�ɳ����ֵ��Ҳ������Ҫ�����������Բ�ֵ��������ݣ��磺�����ڸ������ϲ�ֵ��������ʼ�ļ�ʱ
%��֪���ɸ�ˮλ��ȫ�Ӷβ�ֵ��
%��������ʱ������x�϶�Ӧ�Ĳ�ֵ���
%��β���˱�������ֵ�������

if nargin==2    
    rows=size(yy,1);
    cols=size(yy,2);        %yy�����Ƕ���

    for k=1:cols
        for i=1:rows
            if yy(i,k)==0
                x1=xx(i-1);
                y1=yy(i-1,k);
                j=i+1;
                while yy(j,k)==0
                    j=j+1;
                end
                x2=xx(j);
                y2=yy(j,k);
                yy(i,k)=y1+(y2-y1)/(x2-x1)*(xx(i)-x1);
            end
        end
    end
    ry=yy;
else
    rows=size(yy,1);
    
    if x<=xx(1)
        ry=yy(1);
        return;
    end
    
    if x>xx(rows)
        ry=yy(rows);
        return;
    end
    
    for k=1:1:rows-1
        if (x>xx(k))&&(x<=xx(k+1))
            ry=yy(k)+(yy(k+1)-yy(k))/(xx(k+1)-xx(k))*(x-xx(k));
            break;
        end
    end
end