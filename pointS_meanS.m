function S=pointS_meanS(z,zu,zs,u)

qs_z=zu.*zs;
n=size(z,1);

qs_all=0;
for ii=1:1:n-1
    qs_all=qs_all+(z(ii+1)-z(ii))*(qs_z(ii)+qs_z(ii+1))/2;
end

S=qs_all/u/(z(end,1)-z(1,1));