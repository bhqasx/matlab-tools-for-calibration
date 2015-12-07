function [a]=fit_paras_Wang_q(x,y)
%�ʶ���ʽ�еĲ����������Կ��ǵ��µĵ���������ʽ��������ʧϵ��Ϊ��
options=statset('Jacobian','on');
a0=0.5;           %��ϲ�����ʼ�²�
[a,r]=nlinfit(x,y,@Q_tri_intr,a0,options);
%��Ҫ�����ʶ��Ĺ�ʽ��Ϊ��Ƕ����
    function q_pred=Q_tri_intr(a,x)
        %the first column of x is eta, the second colunm is depth of
        %turbid water in the main channel, the third column is slope
        q_coeff=sqrt((1+a)*((2*x(:,3)*9-4)*a-6*x(:,3)*9+4)/(3-a)^3);
        q_pred=q_coeff.*(x(:,1)*9.81).^0.5.*x(:,2).^1.5;
    end
end