% *** brick3d_20_fast_full ***
% Fully vectorized 20-node hexahedral (HEX20) element
% All 27 Gauss points and all elements are processed simultaneously.
%
% This version is intended mainly to illustrate the trade-off
% between computational speed and memory usage in full vectorization.
% It preserves the node numbering, 3x3x3 Gauss integration and Bt storage
% convention used in brick3d_20.m.
%
% Requires: multiprod.m

nnd=length(x(:,1));                  % number of nodes
nel=length(elem(:,1));               % number of finite elements

ngn=3;                               % number of displacement DOFs per node
nnel=20;                             % number of nodes/element
ngel=60;                             % number of element displacement DOFs
neq=nnd*ngn;                         % total number of equations

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

lambda=nu1*E1;                       % Lamé constant

% -------------------------------------------------------------------------
% 3 x 3 x 3 Gauss integration
a=sqrt(3/5);

str=a*[-1  -1  -1  -1  -1  -1  -1  -1  -1   0   0   0   0   0   0   0   0   0   1   1   1   1   1   1   1   1   1
       -1  -1  -1   0   0   0   1   1   1  -1  -1  -1   0   0   0   1   1   1  -1  -1  -1   0   0   0   1   1   1
       -1   0   1  -1   0   1  -1   0   1  -1   0   1  -1   0   1  -1   0   1  -1   0   1  -1   0   1  -1   0   1];

% Mapping used by brick3d_20.m:
% Gauss positions corresponding to the 20 element nodes.
ind=[1 9 2 12 0 10 4 11 3 17 0 18 0 0 0 20 0 19 5 13 6 16 0 14 8 15 7];

wg=[1.7147e-01   2.7435e-01   1.7147e-01   2.7435e-01   4.3896e-01   2.7435e-01   1.7147e-01   2.7435e-01   1.7147e-01 ...
    2.7435e-01   4.3896e-01   2.7435e-01   4.3896e-01   7.0233e-01   4.3896e-01   2.7435e-01   4.3896e-01   2.7435e-01 ...
    1.7147e-01   2.7435e-01   1.7147e-01   2.7435e-01   4.3896e-01   2.7435e-01   1.7147e-01   2.7435e-01   1.7147e-01];

ngp=27*nel;

% -------------------------------------------------------------------------
% Natural coordinates of the 20 HEX20 nodes.
% They are reconstructed from the same 'ind' mapping used in the
% standard brick3d_20 routine, preserving the same node numbering.
nat=str/a;

sn=zeros(20,1);
tn=zeros(20,1);
rn=zeros(20,1);

jg=find(ind~=0);
sn(ind(jg))=nat(1,jg);
tn(ind(jg))=nat(2,jg);
rn(ind(jg))=nat(3,jg);

% -------------------------------------------------------------------------
% Shape-function derivatives at all 27 Gauss points, vectorized.
% dNds, dNdt, dNdr are 27 x 20.

s=str(1,:)';
t=str(2,:)';
r=str(3,:)';

S =s*ones(1,20);
T =t*ones(1,20);
R =r*ones(1,20);

SN=ones(27,1)*sn';
TN=ones(27,1)*tn';
RN=ones(27,1)*rn';

dNds=zeros(27,20);
dNdt=zeros(27,20);
dNdr=zeros(27,20);

% Corner nodes
ic=find(sn~=0 & tn~=0 & rn~=0);

f=S(:,ic).*SN(:,ic)+T(:,ic).*TN(:,ic)+R(:,ic).*RN(:,ic)-2;

dNds(:,ic)=SN(:,ic).*(1+T(:,ic).*TN(:,ic)).*(1+R(:,ic).*RN(:,ic)).* ...
           (f+1+S(:,ic).*SN(:,ic))/8;

dNdt(:,ic)=TN(:,ic).*(1+S(:,ic).*SN(:,ic)).*(1+R(:,ic).*RN(:,ic)).* ...
           (f+1+T(:,ic).*TN(:,ic))/8;

dNdr(:,ic)=RN(:,ic).*(1+S(:,ic).*SN(:,ic)).*(1+T(:,ic).*TN(:,ic)).* ...
           (f+1+R(:,ic).*RN(:,ic))/8;

% Midside nodes on edges parallel to s
is=find(sn==0);

dNds(:,is)=-S(:,is).*(1+T(:,is).*TN(:,is)).*(1+R(:,is).*RN(:,is))/2;
dNdt(:,is)= TN(:,is).*(1-S(:,is).^2).*(1+R(:,is).*RN(:,is))/4;
dNdr(:,is)= RN(:,is).*(1-S(:,is).^2).*(1+T(:,is).*TN(:,is))/4;

% Midside nodes on edges parallel to t
it=find(tn==0);

dNds(:,it)= SN(:,it).*(1-T(:,it).^2).*(1+R(:,it).*RN(:,it))/4;
dNdt(:,it)=-T(:,it).*(1+S(:,it).*SN(:,it)).*(1+R(:,it).*RN(:,it))/2;
dNdr(:,it)= RN(:,it).*(1-T(:,it).^2).*(1+S(:,it).*SN(:,it))/4;

% Midside nodes on edges parallel to r
ir=find(rn==0);

dNds(:,ir)= SN(:,ir).*(1-R(:,ir).^2).*(1+T(:,ir).*TN(:,ir))/4;
dNdt(:,ir)= TN(:,ir).*(1-R(:,ir).^2).*(1+S(:,ir).*SN(:,ir))/4;
dNdr(:,ir)=-R(:,ir).*(1+S(:,ir).*SN(:,ir)).*(1+T(:,ir).*TN(:,ir))/2;

% 3 x 20 x 27
H0=zeros(3,20,27);
H0(1,:,:)=permute(dNds,[3 2 1]);
H0(2,:,:)=permute(dNdt,[3 2 1]);
H0(3,:,:)=permute(dNdr,[3 2 1]);

clear S T R SN TN RN f dNds dNdt dNdr

% -------------------------------------------------------------------------
% Element nodal coordinates: 20 x 3 x nel
en=elem';

xyzel=zeros(20,3,nel);
xyzel(:,1,:)=reshape(x(en),20,1,nel);
xyzel(:,2,:)=reshape(y(en),20,1,nel);
xyzel(:,3,:)=reshape(z(en),20,1,nel);

% Expand Gauss derivatives and nodal coordinates to all 27*nel pages.
% Page order:
%   element 1: Gauss points 1...27
%   element 2: Gauss points 1...27
%   ...
H=repmat(H0,[1 1 nel]);

xyzel_all=reshape( ...
    repmat(reshape(xyzel,20,3,1,nel),[1 1 27 1]), ...
    20,3,ngp);

% -------------------------------------------------------------------------
% Jacobian matrices for all Gauss points and all elements
J=multiprod(H,xyzel_all);

detJ= J(1,1,:).*J(2,2,:).*J(3,3,:) ...
     +J(2,1,:).*J(3,2,:).*J(1,3,:) ...
     +J(3,1,:).*J(1,2,:).*J(2,3,:) ...
     -J(3,1,:).*J(2,2,:).*J(1,3,:) ...
     -J(1,1,:).*J(3,2,:).*J(2,3,:) ...
     -J(2,1,:).*J(1,2,:).*J(3,3,:);

% Inverse Jacobians, page-wise
J1=zeros(3,3,ngp);

J1(1,1,:)=(J(2,2,:).*J(3,3,:)-J(3,2,:).*J(2,3,:))./detJ;
J1(1,2,:)=(J(3,2,:).*J(1,3,:)-J(1,2,:).*J(3,3,:))./detJ;
J1(1,3,:)=(J(1,2,:).*J(2,3,:)-J(2,2,:).*J(1,3,:))./detJ;

J1(2,1,:)=(J(3,1,:).*J(2,3,:)-J(2,1,:).*J(3,3,:))./detJ;
J1(2,2,:)=(J(1,1,:).*J(3,3,:)-J(3,1,:).*J(1,3,:))./detJ;
J1(2,3,:)=(J(2,1,:).*J(1,3,:)-J(1,1,:).*J(2,3,:))./detJ;

J1(3,1,:)=(J(2,1,:).*J(3,2,:)-J(3,1,:).*J(2,2,:))./detJ;
J1(3,2,:)=(J(3,1,:).*J(1,2,:)-J(1,1,:).*J(3,2,:))./detJ;
J1(3,3,:)=(J(1,1,:).*J(2,2,:)-J(2,1,:).*J(1,2,:))./detJ;

% Global derivatives of the shape functions: 3 x 20 x (27*nel)
br=multiprod(J1,H);

% -------------------------------------------------------------------------
% Bt storage, exactly following the convention of brick3d_20.m.
% Only the first 20*nel pages are populated; the original routine allocates
% 27*nel pages as well.
gpnode=zeros(20,1);
gpnode(ind(jg))=jg;

pp=bsxfun(@plus,gpnode,27*(0:nel-1));
brn=br(:,:,pp(:));

Bt=zeros(6,60,27*nel);
nbt=20*nel;

Bt(1,1:3:60,1:nbt)=brn(1,:,:);
Bt(2,2:3:60,1:nbt)=brn(2,:,:);
Bt(3,3:3:60,1:nbt)=brn(3,:,:);

Bt(4,1:3:60,1:nbt)=brn(2,:,:);
Bt(4,2:3:60,1:nbt)=brn(1,:,:);

Bt(5,2:3:60,1:nbt)=brn(3,:,:);
Bt(5,3:3:60,1:nbt)=brn(2,:,:);

Bt(6,3:3:60,1:nbt)=brn(1,:,:);
Bt(6,1:3:60,1:nbt)=brn(3,:,:);

clear brn pp gpnode

% -------------------------------------------------------------------------
% Full Gauss integration without a Gauss-point loop.
%
% Instead of forming B'*D*B separately for all 27*nel integration points
% (which would require several multi-GB arrays), the 60x60 stiffness matrix
% is assembled from 20x20 weighted derivative products.
%
% br is reshaped to:
%   derivative direction x node x Gauss point x element

br4=reshape(br,3,20,27,nel);

bx=reshape(permute(br4(1,:,:,:),[3 2 4 1]),27,20,nel);
by=reshape(permute(br4(2,:,:,:),[3 2 4 1]),27,20,nel);
bz=reshape(permute(br4(3,:,:,:),[3 2 4 1]),27,20,nel);

W=bsxfun(@times,wg(:),abs(reshape(detJ,27,nel)));
W3=reshape(W,27,1,nel);

% Weighted derivative products:
% Qab(i,j,e) = sum_g W(g,e) * da(g,i,e) * db(g,j,e)

bxw=bsxfun(@times,bx,W3);
Qxx=multiprod(permute(bx,[2 1 3]),bxw);
clear bxw

byw=bsxfun(@times,by,W3);
Qyy=multiprod(permute(by,[2 1 3]),byw);
Qxy=multiprod(permute(bx,[2 1 3]),byw);
clear byw

bzw=bsxfun(@times,bz,W3);
Qzz=multiprod(permute(bz,[2 1 3]),bzw);
Qxz=multiprod(permute(bx,[2 1 3]),bzw);
Qyz=multiprod(permute(by,[2 1 3]),bzw);
clear bzw

% -------------------------------------------------------------------------
% Build all element stiffness matrices: 60 x 60 x nel
kel=zeros(60,60,nel);

iu=1:3:60;
iv=2:3:60;
iw=3:3:60;

% Diagonal displacement blocks
kel(iu,iu,:)=E1*Qxx + G*(Qyy+Qzz);
kel(iv,iv,:)=G*Qxx + E1*Qyy + G*Qzz;
kel(iw,iw,:)=G*(Qxx+Qyy) + E1*Qzz;

% Coupling blocks
kel(iu,iv,:)=lambda*Qxy + G*permute(Qxy,[2 1 3]);
kel(iv,iu,:)=lambda*permute(Qxy,[2 1 3]) + G*Qxy;

kel(iu,iw,:)=lambda*Qxz + G*permute(Qxz,[2 1 3]);
kel(iw,iu,:)=lambda*permute(Qxz,[2 1 3]) + G*Qxz;

kel(iv,iw,:)=lambda*Qyz + G*permute(Qyz,[2 1 3]);
kel(iw,iv,:)=lambda*permute(Qyz,[2 1 3]) + G*Qyz;

% Large Gauss-level arrays are no longer needed.
clear H0 H xyzel xyzel_all J J1 detJ br br4 bx by bz W W3
clear Qxx Qyy Qzz Qxy Qxz Qyz

% -------------------------------------------------------------------------
% Global sparse assembly
ipos0=zeros(60,nel);

ipos0(1:3:60,:)=ngn*en-2;
ipos0(2:3:60,:)=ngn*en-1;
ipos0(3:3:60,:)=ngn*en;

ii=repmat(reshape(ipos0,60,1,nel),1,60,1);
jj=repmat(reshape(ipos0,1,60,nel),60,1,1);

K=sparse(ii(:),jj(:),kel(:),neq,neq);

clear ii jj kel ipos0

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

% Same safeguard used in brick3d_20.m
iz=find(diag(K)==0);
if ~isempty(iz)
    K=K+sparse(iz,iz,1,neq,neq);
end

% Solve the linear system
S=K\F;
