%*** triang2d ***
n=length(x(:,1));                 % number of nodes
nel=length(elem(:,1));            % number of finite elements
ngn=2;                            % number of DOFs / node
neq=ngn*n;                        % total number of equations (unknowns)

E1=E/(1-nu*nu);
G=E/2/(1+nu);
DHooke=[    E1     nu*E1       0
         nu*E1        E1       0
             0         0       G ];
DBt=zeros(3,6,nel);
K=sparse(neq,neq);
F=zeros(neq,1);                    % load vector initialization
for ie=1:nel;
    nd1=elem(ie,1); nd2=elem(ie,2); nd3=elem(ie,3);
    %----------------------------------------------------------------------
    y23=y(nd2)-y(nd3); y31=y(nd3)-y(nd1); y12=y(nd1)-y(nd2);
    x32=x(nd3)-x(nd2); x13=x(nd1)-x(nd3); x21=x(nd2)-x(nd1);
    Ael=(x21*y31-x13*y12)/2;                % element area
    B=[ y23   0   y31   0   y12   0         % strain-displacement matrix
          0  x32    0  x13    0  x21
        x32  y23  x13  y31  x21  y12]/2/Ael;
    DB=DHooke*B;
    kel=abs(Ael)*th*B'*DB;                  % element stiffness matrix
    DBt(:,:,ie)=DB;
    %----------------------------------------------------------------------
    ip=[ngn*nd1-1 ngn*nd1 ngn*nd2-1 ngn*nd2 ngn*nd3-1 ngn*nd3]; % assembly index vector
    K(ip,ip)=K(ip,ip)+kel;                  % assembling process
end

% Constraints
loc=2*(cond(:,1)-1)+cond(:,2);
K(loc,:)=0; K(:,loc)=0; F(loc,:)=0;
K(loc,loc)=eye(length(loc));
% Concentrated forces
loc=2*(forze(:,1)-1)+forze(:,2);
F(loc)=F(loc)+forze(:,3);
% Solve the linear system
S=K\F;
