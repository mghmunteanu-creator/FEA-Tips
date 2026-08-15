%*** plane2d ***
nnd=length(x(:,1));	                % number of nodes
nel=length(elem(:,1));		        % number of finite elements
ngn=2;                              % number of DOF/node
ngel=8;                             % dimension of element stiffness matrix
neq=nnd*ngn;                        % total number of equations (or unknowns)
K=sparse(neq,neq);                  % stiffness matrix initialization
F=zeros(neq,1);                     % load vector initialization
% Gauss points
st=[1  -1  -1   1
    1   1  -1  -1]*sqrt(3)/3;
E1=E/(1-nu*nu);
G=E/2/(1+nu);
DHooke=[   E1  nu*E1     0
	    nu*E1     E1     0
		    0      0     G ];
for i=1:nel;
	n1=elem(i,1);
	n2=elem(i,2);
	n3=elem(i,3);
	n4=elem(i,4);
    %----------------------------------------------------------------------
	xel=[x(n1) x(n2) x(n3) x(n4)]';         % nodal
	yel=[y(n1) y(n2) y(n3) y(n4)]';         % coordinates 
	kel=zeros(ngel);
	for j=1:4;
        s=st(1,j);
        t=st(2,j);
        H=[(1+t)/4  -(1+t)/4  -(1-t)/4  (1-t)/4
           (1+s)/4   (1-s)/4  -(1-s)/4 -(1+s)/4]; 	
        J=H*[ xel    yel];                  % Jacobian
        detJ=abs(det(J));
        J1=inv(J);
        b=J1*H;
        % strain-displacement matrix
        B=[b(1,1)       0    b(1,2)       0    b(1,3)       0    b(1,4)       0
  	           0    b(2,1)       0    b(2,2)       0    b(2,3)       0    b(2,4)
     	   b(2,1)   b(1,1)   b(2,2)   b(1,2)   b(2,3)   b(1,3)   b(2,4)   b(1,4)];
        kel=kel+th*B'*DHooke*B*detJ;        % element stiffness matrix
    end	
    %----------------------------------------------------------------------
    ip=[ngn*n1-1  ngn*n1  ngn*n2-1  ngn*n2  ngn*n3-1  ngn*n3  ngn*n4-1  ngn*n4];  % connectivity vector
	K(ip,ip)=K(ip,ip)+kel;                  % assembly
end
% Constraints
loc=2*(cond(:,1)-1)+cond(:,2);
K(loc,:  )=0; K(:  ,loc)=0; F(loc,:  )=0;                    
K(loc,loc)=eye(length(loc)); 
% Concentrated force
loc=2*(forze(:,1)-1)+forze(:,2);
F(loc)=F(loc)+forze(:,3); 
% solve the linear system
S=K\F;                                      
