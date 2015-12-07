function [a]=fit_realparas_jdc_q(x,y,lb,ub)
%��������Լ���ʶ���ʽ�еĲ��������½�´��ĵ���������ʽ��������ʧϵ��Ϊ��

a0=0.5;           %��ϲ�����ʼ�²�
a=lsqcurvefit(@Q_tri_intr,a0,x,y,lb,ub);
%��Ҫ�����ʶ��Ĺ�ʽ��Ϊ��Ƕ����
    function q_pred=Q_tri_intr(a,x)
        %the first column of x is eta, the second colunm is depth of
        %turbid water in the main channel
        q_coeff=2/3*sqrt(2/3/(1+a-4/9));
        q_pred=q_coeff.*(x(:,1)*9.81).^0.5.*x(:,2).^1.5;
    end
end