%*** stiff ***
xg=[-sqrt(3)/3 sqrt(3)/3];
F=zeros(neq,1);
K=zeros(neq);
ii=0;
for ie=1:nel
    n1=elem(ie,1);
    n2=elem(ie,2);
    L=Lt(ie);
    ip=[3*n1-2 3*n1-1 3*n1 3*n2-2 3*n2-1 3*n2];
    R=Rt(:,:,ie);
    uel=R*S(ip);
    fel=zeros(6,1);
    kel=zeros(6);
    for ig=1:2 
        ii=ii+1;
        xc=1/2*(1+xg(ig));          % Gauss points
        deriv
        % update eps0 and curvature
    	ep=ep+strn(ii,1,istep);
        ca=ca+strn(ii,2,istep);
        fel=fel+L/2*(EA*ep*ep1+EI*ca*ca1);
        kel=kel+L/2*(EA*(ep*ep2+ep1*ep1')+EI*(ca*ca2+ca1*ca1'));
        % eps0 and curvature:
        strn(ii,1:2,istep+1)=[ep ca];
    end
    F(ip)=F(ip)+R'*fel;
    K(ip,ip)=K(ip,ip)+R'*kel*R;
end
% Constraints
loc=3*(cond(:,1)-1)+cond(:,2);
K(loc,:  )=0; K(:  ,loc)=0; F(loc,:  )=0;                    
K(loc,loc)=eye(length(loc)); 
% Concentrated forces
loc=3*(forze(:,1)-1)+forze(:,2);
F(loc)=F(loc)-forze(:,3)*istep/nstep;
