%*** triang2d_fast2 ***
tic
nnd=length(x(:,1));                 % number of nodes
nel=length(elem(:,1));              % number of finite elements

ngn=2;                              % number of DOFs/node
ngel=6;                             % dimension of element stiffness matrix
neq=nnd*ngn;                        % total number of equations (unknowns)

nodo1=elem(:,1);
nodo2=elem(:,2);
nodo3=elem(:,3);
Et=E*ones(nel,1);
nut=nu*ones(nel,1);

E1=Et./(1-nut.*nut);
G=Et/2./(1+nut);
y23=y(nodo2)-y(nodo3);
y31=y(nodo3)-y(nodo1);
y12=y(nodo1)-y(nodo2);

x32=x(nodo3)-x(nodo2);
x13=x(nodo1)-x(nodo3);
x21=x(nodo2)-x(nodo1);

Ael=x21.*y31-x13.*y12;             % twice the signed element area
nel6=ngel*nel;
nel3=nel6/ngn;
b11=y23./Ael; b13=y31./Ael; b15=y12./Ael;
b22=x32./Ael; b24=x13./Ael; b26=x21./Ael;
b31=x32./Ael; b33=x13./Ael; b35=x21./Ael;
b32=y23./Ael; b34=y31./Ael; b36=y12./Ael;
i0=1:6:nel6;
i2=[i0 i0+2 i0+4 i0+1 i0+3 i0+5 i0 i0+1 i0+2 i0+3 i0+4 i0+5];
i0=1:3:nel3;
i1=[i0 i0 i0 i0+1 i0+1 i0+1 i0+2 i0+2 i0+2 i0+2 i0+2 i0+2];
B=sparse(i1,i2,[b11; b13; b15; b22; b24; b26; b31; b32; b33; b34; b35; b36]);
Ath=abs(Ael).*th/2;
d11=E1.*Ath; d12=nu.*E1.*Ath; d33=G.*Ath;
i1=[i0 i0+1 i0 i0+1 i0+2];
i2=[i0 i0 i0+1 i0+1 i0+2];
DHooke=sparse(i1,i2,[d11; d12; d12; d11; d33]);
DB=DHooke*B;
kelt=B'*DB;
ipos0=[ngn*nodo1-1 ngn*nodo1 ngn*nodo2-1 ngn*nodo2 ngn*nodo3-1 ngn*nodo3]';
ipos1=[ipos0; ipos0; ipos0; ipos0; ipos0; ipos0];
ipos2=permute(reshape(ipos1,6,6,nel),[2 1 3]);
ip0=reshape(1:nel*ngel,6,nel);
ip1=[ip0; ip0; ip0; ip0; ip0; ip0];
ip2=permute(reshape(ip1,6,6,nel),[2 1 3]);
ij=(ip1(:)-1)*ngel*nel+ip2(:);
K=sparse(ipos1(:),ipos2(:),kelt(ij),neq,neq); % assembly

F=zeros(neq,1);                             % nodal forces
loc=ngn*(forze(:,1)-1)+forze(:,2);
F(loc)=F(loc)+forze(:,3);

loc=ngn*(cond(:,1)-1)+cond(:,2);            % nodal constraints
K(loc,:)=0; K(:,loc)=0; F(loc,:)=0;
K(loc,loc)=eye(length(loc));
toc
tic
S=K\F;                                      % solve the linear system
toc
