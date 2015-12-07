function [a]=fit_paras_Wang_q(x,y)
%率定公式中的参数，以下以考虑底坡的倒灌流量公式中能量损失系数为例
options=statset('Jacobian','on');
a0=0.5;           %拟合参数初始猜测
[a,r]=nlinfit(x,y,@Q_tri_intr,a0,options);
%需要参数率定的公式作为内嵌函数
    function q_pred=Q_tri_intr(a,x)
        %the first column of x is eta, the second colunm is depth of
        %turbid water in the main channel, the third column is slope
        q_coeff=sqrt((1+a)*((2*x(:,3)*9-4)*a-6*x(:,3)*9+4)/(3-a)^3);
        q_pred=q_coeff.*(x(:,1)*9.81).^0.5.*x(:,2).^1.5;
    end
end