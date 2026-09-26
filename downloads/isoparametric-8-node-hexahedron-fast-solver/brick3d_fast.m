%*** brick3d_fast ***
nnd=length(x(:,1));	                % number of nodes
nel=length(elem(:,1));		        % number of finite elements

ngn=3;                              % number of displacement DOFs per node
ngel=24;                            % number of element displacement DOFs
neq=nnd*ngn;                        % total number of equations (unknowns)
gss=sqrt(3)/3;
tic
nodo1=ones(8,1)*elem(:,1)'; 
nodo2=ones(8,1)*elem(:,2)'; 
nodo3=ones(8,1)*elem(:,3)'; 
nodo4=ones(8,1)*elem(:,4)'; 
nodo5=ones(8,1)*elem(:,5)'; 
nodo6=ones(8,1)*elem(:,6)'; 
nodo7=ones(8,1)*elem(:,7)'; 
nodo8=ones(8,1)*elem(:,8)'; 
nodo1=nodo1(:); nodo2=nodo2(:); nodo3=nodo3(:); nodo4=nodo4(:);
nodo5=nodo5(:); nodo6=nodo6(:); nodo7=nodo7(:); nodo8=nodo8(:);

E1 =E.*(1-nu)./(1+nu)./(1-2*nu)*ones(nel,1);
nu1=nu./(1-nu)*ones(nel,1);
G=E/2./(1+nu)*ones(nel,1);

nel8=8*nel;
xel=[x(nodo1) x(nodo2) x(nodo3) x(nodo4) x(nodo5) x(nodo6) x(nodo7) x(nodo8)]'; 	
yel=[y(nodo1) y(nodo2) y(nodo3) y(nodo4) y(nodo5) y(nodo6) y(nodo7) y(nodo8)]'; 	
zel=[z(nodo1) z(nodo2) z(nodo3) z(nodo4) z(nodo5) z(nodo6) z(nodo7) z(nodo8)]'; 	

xyzel=zeros(8,3,nel8);
xyzel(:,1,:)=xel;
xyzel(:,2,:)=yel;
xyzel(:,3,:)=zel;

ss=[ gss -gss -gss  gss  gss -gss -gss  gss]'*ones(1,nel); ss=ss(:);    % Gauss points
tt=[ gss  gss -gss -gss  gss  gss -gss -gss]'*ones(1,nel); tt=tt(:);
rr=[ gss  gss  gss  gss -gss -gss -gss -gss]'*ones(1,nel); rr=rr(:);

dNst=zeros(3,8,nel8); 
dNst(1,1,:)= (1+tt).*(1+rr)/8; dNst(1,2,:)=-(1+tt).*(1+rr)/8; dNst(1,3,:)=-(1-tt).*(1+rr)/8; dNst(1,4,:)= (1-tt).*(1+rr)/8;
dNst(1,5,:)= (1+tt).*(1-rr)/8; dNst(1,6,:)=-(1+tt).*(1-rr)/8; dNst(1,7,:)=-(1-tt).*(1-rr)/8; dNst(1,8,:)= (1-tt).*(1-rr)/8;

dNst(2,1,:)= (1+ss).*(1+rr)/8; dNst(2,2,:)= (1-ss).*(1+rr)/8; dNst(2,3,:)=-(1-ss).*(1+rr)/8; dNst(2,4,:)=-(1+ss).*(1+rr)/8;
dNst(2,5,:)= (1+ss).*(1-rr)/8; dNst(2,6,:)= (1-ss).*(1-rr)/8; dNst(2,7,:)=-(1-ss).*(1-rr)/8; dNst(2,8,:)=-(1+ss).*(1-rr)/8;

dNst(3,1,:)= (1+ss).*(1+tt)/8; dNst(3,2,:)= (1-ss).*(1+tt)/8; dNst(3,3,:)= (1-ss).*(1-tt)/8; dNst(3,4,:)= (1+ss).*(1-tt)/8;
dNst(3,5,:)=-(1+ss).*(1+tt)/8; dNst(3,6,:)=-(1-ss).*(1+tt)/8; dNst(3,7,:)=-(1-ss).*(1-tt)/8; dNst(3,8,:)=-(1+ss).*(1-tt)/8;

J=multiprod(dNst,xyzel);                            % Jacobian
 
%Jdet=  J11*J22*J33               +J21*J32*J13+                      J31*J12*J23
%      -J31*J22*J13               -J11*J32*J23                      -J21*J12*J33;
detJ=J(1,1,:).*J(2,2,:).*J(3,3,:)+J(2,1,:).*J(3,2,:).*J(1,3,:)+J(3,1,:).*J(1,2,:).*J(2,3,:)-...
     J(3,1,:).*J(2,2,:).*J(1,3,:)-J(1,1,:).*J(3,2,:).*J(2,3,:)-J(2,1,:).*J(1,2,:).*J(3,3,:);
 
%Jinv={{J22*J33-J32*J23,J32*J13-J12*J33,J12*J23-J22*J13},
J1=zeros(3,3,nel8);                                 % J1=inv(J);
J1(1,1,:)=(J(2,2,:).*J(3,3,:)-J(3,2,:).*J(2,3,:))./detJ; 
J1(1,2,:)=(J(3,2,:).*J(1,3,:)-J(1,2,:).*J(3,3,:))./detJ;
J1(1,3,:)=(J(1,2,:).*J(2,3,:)-J(2,2,:).*J(1,3,:))./detJ;
%      {J31*J23-J21*J33,J11*J33-J31*J13,J21*J13-J11*J23},
J1(2,1,:)=(J(3,1,:).*J(2,3,:)-J(2,1,:).*J(3,3,:))./detJ; 
J1(2,2,:)=(J(1,1,:).*J(3,3,:)-J(3,1,:).*J(1,3,:))./detJ;
J1(2,3,:)=(J(2,1,:).*J(1,3,:)-J(1,1,:).*J(2,3,:))./detJ;
%      {J21*J32-J31*J22,J31*J12-J11*J32,J11*J22-J21*J12}};
J1(3,1,:)=(J(2,1,:).*J(3,2,:)-J(3,1,:).*J(2,2,:))./detJ;
J1(3,2,:)=(J(3,1,:).*J(1,2,:)-J(1,1,:).*J(3,2,:))./detJ;
J1(3,3,:)=(J(1,1,:).*J(2,2,:)-J(2,1,:).*J(1,2,:))./detJ;

br=multiprod(J1,dNst);
B=zeros(6,ngel,nel8);
B(1, 1,:)=br(1,1,:); B(1, 4,:)=br(1,2,:); B(1, 7,:)=br(1,3,:); B(1,10,:)=br(1,4,:); 
B(1,13,:)=br(1,5,:); B(1,16,:)=br(1,6,:); B(1,19,:)=br(1,7,:); B(1,22,:)=br(1,8,:); 

B(2, 2,:)=br(2,1,:); B(2, 5,:)=br(2,2,:); B(2, 8,:)=br(2,3,:); B(2,11,:)=br(2,4,:); 
B(2,14,:)=br(2,5,:); B(2,17,:)=br(2,6,:); B(2,20,:)=br(2,7,:); B(2,23,:)=br(2,8,:); 

B(3, 3,:)=br(3,1,:); B(3, 6,:)=br(3,2,:); B(3, 9,:)=br(3,3,:); B(3,12,:)=br(3,4,:); 
B(3,15,:)=br(3,5,:); B(3,18,:)=br(3,6,:); B(3,21,:)=br(3,7,:); B(3,24,:)=br(3,8,:); 

B(4, 1,:)=br(2,1,:); B(4, 4,:)=br(2,2,:); B(4, 7,:)=br(2,3,:); B(4,10,:)=br(2,4,:); 
B(4,13,:)=br(2,5,:); B(4,16,:)=br(2,6,:); B(4,19,:)=br(2,7,:); B(4,22,:)=br(2,8,:); 
B(4, 2,:)=br(1,1,:); B(4, 5,:)=br(1,2,:); B(4, 8,:)=br(1,3,:); B(4,11,:)=br(1,4,:); 
B(4,14,:)=br(1,5,:); B(4,17,:)=br(1,6,:); B(4,20,:)=br(1,7,:); B(4,23,:)=br(1,8,:); 

B(5, 2,:)=br(3,1,:); B(5, 5,:)=br(3,2,:); B(5, 8,:)=br(3,3,:); B(5,11,:)=br(3,4,:); 
B(5,14,:)=br(3,5,:); B(5,17,:)=br(3,6,:); B(5,20,:)=br(3,7,:); B(5,23,:)=br(3,8,:); 
B(5, 3,:)=br(2,1,:); B(5, 6,:)=br(2,2,:); B(5, 9,:)=br(2,3,:); B(5,12,:)=br(2,4,:); 
B(5,15,:)=br(2,5,:); B(5,18,:)=br(2,6,:); B(5,21,:)=br(2,7,:); B(5,24,:)=br(2,8,:); 

B(6, 3,:)=br(1,1,:); B(6, 6,:)=br(1,2,:); B(6, 9,:)=br(1,3,:); B(6,12,:)=br(1,4,:); 
B(6,15,:)=br(1,5,:); B(6,18,:)=br(1,6,:); B(6,21,:)=br(1,7,:); B(6,24,:)=br(1,8,:); 
B(6, 1,:)=br(3,1,:); B(6, 4,:)=br(3,2,:); B(6, 7,:)=br(3,3,:); B(6,10,:)=br(3,4,:); 
B(6,13,:)=br(3,5,:); B(6,16,:)=br(3,6,:); B(6,19,:)=br(3,7,:); B(6,22,:)=br(3,8,:); 

detJ=abs(detJ(:));
E1 =ones(8,1)*E1';
nu1=ones(8,1)*nu1';
G  =ones(8,1)*G';
E1=E1(:).*detJ;
nu1=nu1(:);
G=G(:).*detJ;
DHooke=zeros(6,6,nel8);
DHooke(1,1,:)=E1;
DHooke(1,2,:)=nu1.*E1;
DHooke(1,3,:)=nu1.*E1;

DHooke(2,1,:)=nu1.*E1;
DHooke(2,2,:)=E1;
DHooke(2,3,:)=nu1.*E1;

DHooke(3,1,:)=nu1.*E1;
DHooke(3,2,:)=nu1.*E1;
DHooke(3,3,:)=E1;

DHooke(4,4,:)=G;
DHooke(5,5,:)=G;
DHooke(6,6,:)=G;

DB=multiprod(DHooke,B);
kelt=reshape(multiprod(permute(B,[2 1 3]),DB),ngel^2,nel8);

ipos0=      [ngn*nodo1-2 ngn*nodo1-1 ngn*nodo1 ngn*nodo2-2 ngn*nodo2-1 ngn*nodo2];
ipos0=[ipos0 ngn*nodo3-2 ngn*nodo3-1 ngn*nodo3 ngn*nodo4-2 ngn*nodo4-1 ngn*nodo4];
ipos0=[ipos0 ngn*nodo5-2 ngn*nodo5-1 ngn*nodo5 ngn*nodo6-2 ngn*nodo6-1 ngn*nodo6];
ipos0=[ipos0 ngn*nodo7-2 ngn*nodo7-1 ngn*nodo7 ngn*nodo8-2 ngn*nodo8-1 ngn*nodo8]';

ipos1=[ipos0; ipos0; ipos0; ipos0; ipos0; ipos0];
ipos1=[ipos1; ipos1; ipos1; ipos1];
ipos2=permute(reshape(ipos1,ngel,ngel,nel8),[2 1 3]);
K=0;
K=sparse(ipos1,ipos2(:),kelt(:),neq,neq);           % sparse global assembly

F=zeros(neq,1);                                     %
loc=ngn*(forze(:,1)-1)+forze(:,2);                  % nodal forces
F(loc)=F(loc)+forze(:,3);                           %

loc=ngn*(cond(:,1)-1)+cond(:,2);
K(loc,:)  =0;                                       %                            
K(:,loc)  =0;                                       % nodal constraints
K(loc,loc)=eye(length(loc));                        %
F(loc,:)  =0;                                       %
t1=toc;
disp(['Generation of finite element & assembling: ',num2str(t1),' sec'])
tic
S=K\F;                                              % solve the linear system     					
t2=toc;
disp(['Solving the linear system: ',num2str(t2),' sec'])
