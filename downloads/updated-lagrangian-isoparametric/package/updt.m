%*** updt ***
x=x+S(1:3:neq);
y=y+S(2:3:neq);
for ie=1:nel
    n1=elem(ie,1);
    n2=elem(ie,2);
    dx=x(n2)-x(n1);
    dy=y(n2)-y(n1);
    L=sqrt(dx*dx+dy*dy);
    Lt(ie)=L;
    cs=dx/L;            
    sn=dy/L;
    Rt(:,:,ie)=[ cs sn  0   0   0  0           
                -sn cs  0   0   0  0  
                  0  0  1   0   0  0  
                  0  0  0  cs  sn  0  
                  0  0  0 -sn  cs  0  
                  0  0  0   0   0  1 ];
end
