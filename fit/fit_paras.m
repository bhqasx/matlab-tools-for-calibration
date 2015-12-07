function [a]=fit_paras(x,y)
%�ʶ���ʽ�еĲ����������Ե���������ʽ��������ʧϵ��Ϊ��
options=statset('Jacobian','on');
a0=0.5;           %��ϲ�����ʼ�²�
[a,r]=nlinfit(x,y,@Q_tri_intr,a0,options);
%��Ҫ�����ʶ��Ĺ�ʽ��Ϊ��Ƕ����
    function q_pred=Q_tri_intr(a,x)
        %the first column of x is eta and the second colunm is depth of
        %turbid water in the main channel
        q_pred=sqrt((1+a)*(4-4*a)/(3-a)^3)*(x(:,1)*9.81).^0.5.*x(:,2).^1.5;
    end
end