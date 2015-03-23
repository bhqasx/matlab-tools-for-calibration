function F=F_cal(UL,UR,zbf)
g=9.81;
h_L=UL(1,:)-zbf; u_L=UL(2,:)./h_L; a_L=sqrt(g*h_L);
h_R=UR(1,:)-zbf; u_R=UR(2,:)./h_R; a_R=sqrt(g*h_R);

h_star=(0.5*(a_L+a_R)+0.25*(u_L-u_R)).^2/g;
u_star=(u_L+u_R)/2+a_L-a_R;
a_star=sqrt(g*h_star);

s_L=min(u_L-a_L,u_star-a_star);
s_R=min(u_R+a_R,u_star+a_star);

FL(1,:)=UL(2,:);
FL(2,:)=u_L.*UL(2,:)+0.5*g*(UL(1,:).^2-2*UL(1,:).*zbf);

FR(1,:)=UR(2,:);
FR(2,:)=u_R.*UR(2,:)+0.5*g*(UR(1,:).^2-2*UR(1,:).*zbf);

F_star1=(s_R.*FL(1,:)-s_L.*FR(1,:)+s_L.*s_R.*(UR(1,:)-UL(1,:)))./(s_R-s_L);
F_star2=(s_R.*FL(2,:)-s_L.*FR(2,:)+s_L.*s_R.*(UR(2,:)-UL(2,:)))./(s_R-s_L);

F(1,:)=(s_L>=0).*FL(1,:)+((s_L<0) & (s_R>=0)).*F_star1+(s_R<0).*FR(1,:);
F(2,:)=(s_L>=0).*FL(2,:)+((s_L<0) & (s_R>=0)).*F_star2+(s_R<0).*FR(2,:);
return