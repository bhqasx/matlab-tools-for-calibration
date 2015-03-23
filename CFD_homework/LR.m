function U_LR=LR(ndir,U)   
global dx; 
global ncase;
    
    grad1=(U-[U(:,1),U(:,1:end-1)])./dx;       
    grad2=([U(:,2:end),U(:,end)]-U)./dx;
    grad=((grad1.*grad2)>0).*(grad1.*(abs(grad1)<=abs(grad2))+grad2.*(abs(grad2)<abs(grad1)));

if ndir==1          %calculate UeL
    U_LR=U+0.5*dx.*grad;
else                                 %calculate UeR
    U_LR=U-0.5*dx.*grad;             %calculate UwR(i)
    U_LR=circshift(U_LR,[0,-1]);     %UeR(i)=UwR(i+1), circshift(U_LR,[0,-1]): each column move left
end                                 %UeR at boundary is given in the main programmme
return