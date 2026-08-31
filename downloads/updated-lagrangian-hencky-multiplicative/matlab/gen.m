% *** gen ***
%==========================================================================
% It generates input data for a rectangular cross-section cantilevr beam:
%   L  - beam length
%   H  - cross-section height
%   th - cross-section width
%   E  - Young modulus
%   nu - Poison ratio
%   nL - number of elements on beam lenght
%   nH - number of elements on beam height
%   F  - Force acting on the free end
%==========================================================================
% x,y    tables that contain the nodal coordinates
%
% elem  table contains element nodes
%       [node1  node2  node3  node4 
%       [node1  node2  node3  node4 
%        :      :      :      :    ]
%               
% cond  table contains nodal constraints
%       (dir=1 - x direction, dir=2 - y direction)
%       [node1  dir1
%        node2  dir2
%        :      :   ]
%
% forze table contains nodal loads
%       [node1  direction1  force1
%        node2  direction2  force2
%        :      :     :           :     ]
%==========================================================================
L=400;
H=20;
th=5;
E=1000;
nu=0.3;
F=100; 

nL=60;
nH= 8;
%========================================
% Generation of the table "x"
dH=H/nH;
dL=L/nL;
nnd=(nL+1)*(nH+1);          % number of nodes
nel=nL*nH;                  % number of finite elements
neq=2*nnd;                  % number of equations (DOFs)
elem=zeros(nel,4);
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
x0=x; y0=y;
%========================================
% Generation of the table "elem"
iel=0;
inod=0;
for i=1:nL
    for j=1:nH
        j1=rem(j,2);
        inod=inod+1;
        iel=iel+1;
        elem(iel,:)=[inod   inod+nH+1  inod+nH+2  inod+1];
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
dF=F/nH;
for i=1:nH+1
   forze(i,1)=nnd+1-i;
   forze(i,2)=2;
   forze(i,3)=-dF;
   if i==1 | i==nH+1
      forze(i,3)=-dF/2;
   end
end
%========================================
% Plot the mesh
axis('equal')
patch('Vertices',[x y],'Faces',elem(:,1:4),'Facecolor',[1 1 1],'linewidth',0.75,'edgecolor','b')
grid on
nd=nnd-nH:nnd;
ln=length(nd);
quiver(x(nd),y(nd),zeros(ln,1),-3.5*dH*ones(ln,1),'r','linewidth',1.5)
for i=1:nH+1
    xt=x(i); yt=y(i);
    fill([xt xt-dH/1.5 xt-dH/1.5],[yt yt+dH/3 yt-dH/3],'g')
    fill([xt xt-dH/3 xt+dH/3],[yt yt-dH/1.5 yt-dH/1.5],'g')
end   
drawnow
