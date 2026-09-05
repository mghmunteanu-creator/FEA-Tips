% *** stiff ***
istrain=1;   % 1 - Hencky strain
             % 2 - Biot strain

ddB=1e-3;    % perturbation for numerical B
ddK=1e-3;    % perturbation for numerical kel

E1=E/(1-nu*nu);
E2=nu*E1;
G=E/2/(1+nu);

DHooke=[E1 E2 0
        E2 E1 0
         0  0 G];

F=zeros(neq,1);
K=zeros(neq);

for ie=1:nel

    n1=elem(ie,1);
    n2=elem(ie,2);
    n3=elem(ie,3);
    n4=elem(ie,4);

    ipos=[2*n1-1 2*n1 ...
          2*n2-1 2*n2 ...
          2*n3-1 2*n3 ...
          2*n4-1 2*n4];

    sel=S(ipos);

    % Nodal coordinates at the beginning of the current load step
    xel=[x(n1) x(n2) x(n3) x(n4)]';
    yel=[y(n1) y(n2) y(n3) y(n4)]';

    % Internal force vector
    isave=1;
    fel_el
    fel0=fel;

    % Numerical tangent stiffness matrix
    kel=zeros(8);
    isave=0;

    for ipert=1:8

        sel(ipert)=sel(ipert)+ddK;
        fel_el
        felp=fel;

        sel(ipert)=sel(ipert)-2*ddK;
        fel_el
        felm=fel;

        sel(ipert)=sel(ipert)+ddK;

        kel(:,ipert)=(felp-felm)/(2*ddK);

    end

    % Assembly
    F(ipos)=F(ipos)+fel0;
    K(ipos,ipos)=K(ipos,ipos)+kel;

end

% Constraints
loc=2*(cond(:,1)-1)+cond(:,2);

K(loc,:)=0;
K(:,loc)=0;
F(loc)=0;

K(loc,loc)=eye(length(loc));

% Concentrated force
loc=2*(forze(:,1)-1)+forze(:,2);

F(loc)=F(loc)-forze(:,3)*istep/nstep;
