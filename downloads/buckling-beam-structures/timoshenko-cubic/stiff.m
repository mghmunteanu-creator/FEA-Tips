% *** stiff ***
F=zeros(neq,1);
K=zeros(neq);
for ie=1:nel
    R=Rt(:,:,ie);
    n1=elem(ie,1);
    n2=elem(ie,2);
    L=Lt(ie);               % length of the beam element
    ipos=[3*n1-2 3*n1-1 3*n1 3*n2-2 3*n2-1 3*n2];
% Timoshenko beam model, third-degree shape function
    ge=ga*L^2 + 12*ei;
    kel=[  ea/L,                  0,                              0, -ea/L,                  0,                              0 
              0,  (12*ei*ga)/(L*ge),                   (6*ei*ga)/ge,     0, -(12*ei*ga)/(L*ge),                   (6*ei*ga)/ge
              0,       (6*ei*ga)/ge,  (4*ei*(ga*L^2 + 3*ei))/(L*ge),     0,      -(6*ei*ga)/ge, -(2*ei*(6*ei - ga*L^2))/(L*ge)
          -ea/L,                  0,                              0,  ea/L,                   0,                             0
              0, -(12*ei*ga)/(L*ge),                  -(6*ei*ga)/ge,     0,  (12*ei*ga)/(L*ge),                  -(6*ei*ga)/ge
              0,       (6*ei*ga)/ge, -(2*ei*(6*ei - ga*L^2))/(L*ge),     0,      -(6*ei*ga)/ge,  (4*ei*(ga*L^2 + 3*ei))/(L*ge)];
    K(ipos,ipos)=K(ipos,ipos)+R'*kel*R;
end
% Constraints
loc=3*(cond(:,1)-1)+cond(:,2);
K(loc,:  )=0; K(:  ,loc)=0; F(loc,:  )=0;                    
K(loc,loc)=eye(length(loc)); 
% Concentrated forces
loc=3*(forze(:,1)-1)+forze(:,2);
F(loc)=F(loc)+forze(:,3);               
