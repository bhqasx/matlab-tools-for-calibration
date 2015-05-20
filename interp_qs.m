function r_qs=interp_qs(timehr,qs)
%�Ժ�ɳ����ֵ��Ҳ������Ҫ�����������Բ�ֵ��������ݣ��磺�����ڸ������ϲ�ֵ��������ʼ�ļ�ʱ
%��֪���ɸ�ˮλ��ȫ�Ӷβ�ֵ
%��β���˱�������ֵ�������
rows=size(qs,1);
cols=size(qs,2);

for k=1:cols  
    for i=1:rows
        if qs(i,k)==0
            x1=timehr(i-1);
            y1=qs(i-1,k);
            j=i+1;
            while qs(j,k)==0
                j=j+1;
            end
            x2=timehr(j);
            y2=qs(j,k);
            qs(i,k)=y1+(y2-y1)/(x2-x1)*(timehr(i)-x1);
        end
    end
end
r_qs=qs;