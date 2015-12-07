function [a]=fit_realparas_qwk_q(x,y,lb,ub)
%带上下限约束率定公式中的参数，以下以秦文凯的倒灌流量公式中能量损失系数为例

a0=0.4;           %拟合参数初始猜测
a=lsqcurvefit(@Q_tri_intr,a0,x,y,lb,ub);
%需要参数率定的公式作为内嵌函数
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