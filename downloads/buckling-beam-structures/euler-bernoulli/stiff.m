% *** stiff ***
F=zeros(neq,1);
K=zeros(neq);
for ie=1:nel
    R=Rt(:,:,ie);
    n1=elem(ie,1);
    n2=elem(ie,2);
    L=Lt(ie);               % length of the beam element
    ipos=[3*n1-2 3*n1-1 3*n1 3*n2-2 3*n2-1 3*n2];
    % 2-node Euler-Bernoulli beam element
    kel=[ ea/L,      0,           0,    -ea/L,      0,          0
            0,  12*ei/L^3,    6*ei/L^2,    0, -12*ei/L^3,   6*ei/L^2
            0,   6*ei/L^2,    4*ei/L,      0,  -6*ei/L^2,   2*ei/L
         -ea/L,      0,            0,    ea/L,      0,          0
            0, -12*ei/L^3,    -6*ei/L^2,   0,  12*ei/L^3,  -6*ei/L^2
            0,   6*ei/L^2,     2*ei/L,     0,  -6*ei/L^2,   4*ei/L  ];
    K(ipos,ipos)=K(ipos,ipos)+R'*kel*R;
end
% Constraints
loc=3*(cond(:,1)-1)+cond(:,2);
K(loc,:  )=0; K(:  ,loc)=0; F(loc,:  )=0;                    
K(loc,loc)=eye(length(loc)); 
% Concentrated forces
loc=3*(forze(:,1)-1)+forze(:,2);
F(loc)=F(loc)+forze(:,3);               
