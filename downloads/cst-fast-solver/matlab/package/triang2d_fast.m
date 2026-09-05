%*** triang2d_fast ***
tic
nnd=length(x(:,1));	                % number of nodes
nel=length(elem(:,1));		        % number of finite elements
ngn=2;                              % number of DOF/node
neq=nnd*ngn;                        % total number of equations (unknowns)
nodo1=elem(:,1);
nodo2=elem(:,2);
nodo3=elem(:,3);
E1=E/(1-nu*nu);		
G=E/2/(1+nu);
y23=y(nodo2)-y(nodo3);
y31=y(nodo3)-y(nodo1); 
y12=y(nodo1)-y(nodo2);
        
x32=x(nodo3)-x(nodo2);
x13=x(nodo1)-x(nodo3); 
x21=x(nodo2)-x(nodo1);
        
Ael=(x21.*y31-x13.*y12);                % element area
B=zeros(3,6,nel);
B(1,1,:)=y23./Ael; B(1,3,:)=y31./Ael; B(1,5,:)=y12./Ael;
B(2,2,:)=x32./Ael; B(2,4,:)=x13./Ael; B(2,6,:)=x21./Ael;
B(3,1,:)=x32./Ael; B(3,3,:)=x13./Ael; B(3,5,:)=x21./Ael; 
B(3,2,:)=y23./Ael; B(3,4,:)=y31./Ael; B(3,6,:)=y12./Ael;
Ath=abs(Ael)*th/2;
DHooke=zeros(3,3,nel);
DHooke(1,1,:)=E1*Ath;
DHooke(1,2,:)=nu*E1*Ath;
DHooke(2,1,:)=nu*E1*Ath;
DHooke(2,2,:)=E1*Ath;
DHooke(3,3,:)=G*Ath;

DBt=multiprod(DHooke,B);
kelt=reshape(multiprod(permute(B,[2 1 3]),DBt),36,nel); % stiffness matrices of all finite elements
ipos0=[ngn*nodo1-1 ngn*nodo1 ngn*nodo2-1 ngn*nodo2 ngn*nodo3-1 ngn*nodo3]';
ipos1=[ipos0; ipos0; ipos0; ipos0; ipos0; ipos0];
ipos2=permute(reshape(ipos1,6,6,nel),[2 1 3]);
K=sparse(ipos1,ipos2(:),kelt(:),neq,neq);   % assembling

F=zeros(neq,1);                             % nodal load
loc=ngn*(forze(:,1)-1)+forze(:,2);
F(loc)=F(loc)+forze(:,3);

loc=ngn*(cond(:,1)-1)+cond(:,2);            % nodal constraints
K(loc,:)  =0; K(:,loc)  =0; F(loc,:)  =0; 
K(loc,loc)=eye(length(loc));
toc
tic
S=K\F;                                      % solving the linear system
toc
DBt = DBt./reshape(Ath,1,1,[]);
