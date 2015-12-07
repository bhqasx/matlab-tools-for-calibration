function [a]=fit_realparas_jdc_q(x,y,lb,ub)
%带上下限约束率定公式中的参数，以下金德春的倒灌流量公式中能量损失系数为例

a0=0.5;           %拟合参数初始猜测
a=lsqcurvefit(@Q_tri_intr,a0,x,y,lb,ub);
%需要参数率定的公式作为内嵌函数
    function q_pred=Q_tri_intr(a,x)
        %the first column of x is eta, the second colunm is depth of
        %turbid water in the main channel
        q_coeff=2/3*sqrt(2/3/(1+a-4/9));
        q_pred=q_coeff.*(x(:,1)*9.81).^0.5.*x(:,2).^1.5;
    end
end