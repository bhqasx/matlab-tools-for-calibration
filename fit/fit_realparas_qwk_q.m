function [a]=fit_realparas_qwk_q(x,y,lb,ub)
%��������Լ���ʶ���ʽ�еĲ��������������Ŀ��ĵ���������ʽ��������ʧϵ��Ϊ��

a0=0.4;           %��ϲ�����ʼ�²�
a=lsqcurvefit(@Q_tri_intr,a0,x,y,lb,ub);
%��Ҫ�����ʶ��Ĺ�ʽ��Ϊ��Ƕ����
    function q_pred=Q_tri_intr(a,x)
        %the first column of x is eta, the second colunm is depth of
        %turbid water in the main channel
%         syms k1;
%         ksi_sym=sym(a);         %turn a into a symbol
%         f=(2-k1)^2*(1+ksi_sym)/4/k1^2-(1-k1)^2-2;
%         rf=feval(symengine,'solve',f,'k1');
        rf=solve(['(2-k1)^2*(1+',num2str(a),')/4/k1^2-(1-k1)^2-2']);
        q_coeff=sqrt((1-double(rf(1)))^3);
        q_pred=q_coeff.*(x(:,1)*9.81).^0.5.*x(:,2).^1.5;
    end
end