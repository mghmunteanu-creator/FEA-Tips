%*** stiff ***
F=zeros(neq,1);
K=zeros(neq);
for ie=1:nel
    L=Lt(ie);
    n1=elem(ie,1);
    n2=elem(ie,2);
    ip=[3*n1-2 3*n1-1 3*n1 3*n2-2 3*n2-1 3*n2];
    R=Rt(:,:,ie);
    s=R*S(ip);
    deriv
    fel=L*(EA*ep*ep1+EI*ca*ca1+GA*be*be1);
    kel=L*(EA*(ep*ep2+ep1*ep1')+EI*(ca*ca2+ca1*ca1')+GA*(be*be2+be1*be1'));
    F(ip)=F(ip)+R'*fel;
    K(ip,ip)=K(ip,ip)+R'*kel*R;
    % computes N, M, T:
    stress(ie,1:3,istep+1)=[EA*ep EI*ca GA*be];
end
% Constraints
loc=3*(cond(:,1)-1)+cond(:,2);
K(loc,:  )=0; K(:  ,loc)=0; F(loc,:  )=0;                    
K(loc,loc)=eye(length(loc)); 
% Concentrated force
loc=3*(forze(:,1)-1)+forze(:,2);
F(loc)=F(loc)-forze(:,3)*istep/nstep;               
