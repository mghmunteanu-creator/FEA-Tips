% *** brick3d_20_fast ***
% Fast/vectorized 20-node hexahedral (HEX20) element
% Vectorized over all elements; only the loop over the 27 Gauss points remains.
% Requires: shape20.m and multiprod.m

nnd=length(x(:,1));                  % number of nodes
nel=length(elem(:,1));               % number of finite elements

ngn=3;                               % number of displacement DOFs per node
nnel=20;                             % number of nodes/element
ngel=60;                             % number of element displacement DOFs
neq=nnd*ngn;                         % total number of equations (unknowns)

% -------------------------------------------------------------------------
% Hooke's law
E1 =E*(1-nu)/(1+nu)/(1-2*nu);
nu1=nu/(1-nu);
G  =E/2/(1+nu);

DHooke=[     E1   nu1*E1   nu1*E1
         nu1*E1      E1    nu1*E1
         nu1*E1   nu1*E1      E1  ];
DHooke(4,4)=G;
DHooke(5,5)=G;
DHooke(6,6)=G;

% -------------------------------------------------------------------------
% Element nodal coordinates, stored page-wise: 20 x 3 x nel
en=elem';

xyzel=zeros(nnel,3,nel);
xyzel(:,1,:)=reshape(x(en),nnel,1,nel);
xyzel(:,2,:)=reshape(y(en),nnel,1,nel);
xyzel(:,3,:)=reshape(z(en),nnel,1,nel);

% -------------------------------------------------------------------------
% 3 x 3 x 3 Gauss integration
a=sqrt(3/5);

str=a*[-1  -1  -1  -1  -1  -1  -1  -1  -1   0   0   0   0   0   0   0   0   0   1   1   1   1   1   1   1   1   1
       -1  -1  -1   0   0   0   1   1   1  -1  -1  -1   0   0   0   1   1   1  -1  -1  -1   0   0   0   1   1   1
       -1   0   1  -1   0   1  -1   0   1  -1   0   1  -1   0   1  -1   0   1  -1   0   1  -1   0   1  -1   0   1];

% Mapping used in brick3d_20.m for storing B at the 20 node-corresponding
% Gauss positions.
ind=[1 9 2 12 0 10 4 11 3 17 0 18 0 0 0 20 0 19 5 13 6 16 0 14 8 15 7];

wg=[1.7147e-01   2.7435e-01   1.7147e-01   2.7435e-01   4.3896e-01   2.7435e-01   1.7147e-01   2.7435e-01   1.7147e-01 ...
    2.7435e-01   4.3896e-01   2.7435e-01   4.3896e-01   7.0233e-01   4.3896e-01   2.7435e-01   4.3896e-01   2.7435e-01 ...
    1.7147e-01   2.7435e-01   1.7147e-01   2.7435e-01   4.3896e-01   2.7435e-01   1.7147e-01   2.7435e-01   1.7147e-01];

% Element stiffness matrices, one page per element
kel=zeros(ngel,ngel,nel);

% Same storage convention as brick3d_20.m
Bt=zeros(6,ngel,27*nel);

% -------------------------------------------------------------------------
% Integration loop: only 27 iterations; all elements are treated together
for j=1:27

    s=str(1,j);
    t=str(2,j);
    r=str(3,j);

    [~,dNds,dNdt,dNdr]=shape20(s,t,r);

    H=[dNds dNdt dNdr]';             % 3 x 20
    H3=repmat(H,[1 1 nel]);           % 3 x 20 x nel

    % Jacobian matrices: 3 x 3 x nel
    J=multiprod(H3,xyzel);

    % determinant of J, page-wise
    detJ= J(1,1,:).*J(2,2,:).*J(3,3,:) ...
         +J(2,1,:).*J(3,2,:).*J(1,3,:) ...
         +J(3,1,:).*J(1,2,:).*J(2,3,:) ...
         -J(3,1,:).*J(2,2,:).*J(1,3,:) ...
         -J(1,1,:).*J(3,2,:).*J(2,3,:) ...
         -J(2,1,:).*J(1,2,:).*J(3,3,:);

    % inverse of J, page-wise
    J1=zeros(3,3,nel);

    J1(1,1,:)=(J(2,2,:).*J(3,3,:)-J(3,2,:).*J(2,3,:))./detJ;
    J1(1,2,:)=(J(3,2,:).*J(1,3,:)-J(1,2,:).*J(3,3,:))./detJ;
    J1(1,3,:)=(J(1,2,:).*J(2,3,:)-J(2,2,:).*J(1,3,:))./detJ;

    J1(2,1,:)=(J(3,1,:).*J(2,3,:)-J(2,1,:).*J(3,3,:))./detJ;
    J1(2,2,:)=(J(1,1,:).*J(3,3,:)-J(3,1,:).*J(1,3,:))./detJ;
    J1(2,3,:)=(J(2,1,:).*J(1,3,:)-J(1,1,:).*J(2,3,:))./detJ;

    J1(3,1,:)=(J(2,1,:).*J(3,2,:)-J(3,1,:).*J(2,2,:))./detJ;
    J1(3,2,:)=(J(3,1,:).*J(1,2,:)-J(1,1,:).*J(3,2,:))./detJ;
    J1(3,3,:)=(J(1,1,:).*J(2,2,:)-J(2,1,:).*J(1,2,:))./detJ;

    % derivatives with respect to global coordinates
    br=multiprod(J1,H3);              % 3 x 20 x nel

    % strain-displacement matrices: 6 x 60 x nel
    B=zeros(6,ngel,nel);

    B(1,1:3:ngel,:)=br(1,:,:);
    B(2,2:3:ngel,:)=br(2,:,:);
    B(3,3:3:ngel,:)=br(3,:,:);

    B(4,1:3:ngel,:)=br(2,:,:);
    B(4,2:3:ngel,:)=br(1,:,:);

    B(5,2:3:ngel,:)=br(3,:,:);
    B(5,3:3:ngel,:)=br(2,:,:);

    B(6,3:3:ngel,:)=br(1,:,:);
    B(6,1:3:ngel,:)=br(3,:,:);

    % Preserve Bt storage used by the standard brick3d_20 routine
    ib=ind(j);
    if ib~=0
        ii=20*(0:nel-1)+ib;
        Bt(:,:,ii)=B;
    end

    % DHooke*B for all elements
    DB=reshape(DHooke*reshape(B,6,ngel*nel),6,ngel,nel);

    % B'*DHooke*B for all elements
    kg=multiprod(permute(B,[2 1 3]),DB);

    % Gauss contribution
    detJ3=reshape(abs(detJ),1,1,nel);
    kel=kel+wg(j)*bsxfun(@times,kg,detJ3);
end

% -------------------------------------------------------------------------
% Connectivity matrix for all elements
ipos0=zeros(ngel,nel);

ipos0(1:3:ngel,:)=ngn*en-2;
ipos0(2:3:ngel,:)=ngn*en-1;
ipos0(3:3:ngel,:)=ngn*en;

% Global sparse assembly
ii=repmat(reshape(ipos0,ngel,1,nel),1,ngel,1);
jj=repmat(reshape(ipos0,1,ngel,nel),ngel,1,1);

K=sparse(ii(:),jj(:),kel(:),neq,neq);

% -------------------------------------------------------------------------
% Load vector
F=zeros(neq,1);

loc=ngn*(forze(:,1)-1)+forze(:,2);
F(loc)=F(loc)+forze(:,3);

% Constraints
loc=ngn*(cond(:,1)-1)+cond(:,2);
K(loc,:)=0;
K(:,loc)=0;
K(loc,loc)=eye(length(loc));
F(loc,:)=0;

% Same safeguard as in the standard brick3d_20 routine
iz=find(diag(K)==0);
if ~isempty(iz)
    K=K+sparse(iz,iz,1,neq,neq);
end

% Solve the linear system
S=K\F;
