%*** gen ***
%==========================================================================
% It generates input data for a rectangular cantilever beam:
%   L  - beam length
%   H  - beam height
%   th - thickness
%   E  - Young's modulus
%   nu - Poisson's ratio
%   nL - number of subdivisions along the beam length
%   nH - number of subdivisions through the beam height
%==========================================================================
% x, y  vectors that contain the nodal coordinates
%
% elem  table contains the nodes of each CST element: 
%       [node1  node2  node3 
%       [node1  node2  node3 
%        :      :      :     ]
%               
% cond  table contains nodal constraints
%       (dir=1 - x direction, dir=2 - y direction)
%       [node1  dir1
%        node2  dir2
%        :      :   ]
% forze table contains nodal loads
%        node   DOF   value
%       [node1  dir1  force1
%        node2  dir2  force2
%        :      :     :     ]
%==========================================================================

L=200;
H=50;
th=5;
E=2.1e5;
nu=0.3;
F0=1000;

nL=200;
nH=80;
%========================================
% Generation of the table "x"
dH=H/nH;
dL=L/nL;
n=(nL+1)*(nH+1);            % number of nodes
nel=2*nL*nH;                % number of finite elements
elem=zeros(nel,3);
inod=0;
xx=0;
for i=1:nL+1
   yy=0;
   for j=1:nH+1
      inod=inod+1;
      x(inod,1)=xx;
      y(inod,1)=yy;
      yy=yy+dH;
   end
   xx=xx+dL;
end
%========================================
% Generation of the table "elem"
iel=0;
inod=0;
for i=1:nL
    for j=1:nH
        j1=rem(j,2);
        inod=inod+1;
        iel=iel+1;
        if j1==1
            elem(iel,:)=[inod   inod+nH+1 inod+nH+2];
            iel=iel+1;
            elem(iel,:)=[inod   inod+1    inod+nH+2];
        elseif j1==0
            elem(iel,:)=[inod   inod+1    inod+nH+1];
            iel=iel+1;
            elem(iel,:)=[inod+1 inod+nH+2 inod+nH+1];
        end 
   end
   inod=inod+1;
end
%========================================
% Generation of the table "cond"
ic=0;
for i=1:nH+1
    ic=ic+1;
    cond(ic,1)=i;
    cond(ic,2)=1;
    ic=ic+1;
    cond(ic,1)=i;
    cond(ic,2)=2;
end
%========================================
% Generation of the table "forze"
dF=F0/nH;
for i=1:nH+1
   forze(i,1)=n+1-i;
   forze(i,2)=2;
   forze(i,3)=-dF;
   if i==1 | i==nH+1
      forze(i,3)=-dF/2;
   end
end
%========================================
figure(1)
clf
hold on
axis('equal')
patch('Vertices',[x y],'Faces',elem(:,1:3),'Facecolor',[1 1 1],'linewidth',0.75,'edgecolor','b')
grid on

nd=n-nH:n;
ln=length(nd);
quiver(x(nd),y(nd),zeros(ln,1),-3.5*dH*ones(ln,1),'r','linewidth',1.5)
for i=1:nH+1
    xt=x(i); yt=y(i);
    fill([xt xt-dH/1.5 xt-dH/1.5],[yt yt+dH/3 yt-dH/3],'g')
    fill([xt xt-dH/3 xt+dH/3],[yt yt-dH/1.5 yt-dH/1.5],'g')
end
