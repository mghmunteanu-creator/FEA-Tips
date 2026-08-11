%*** gen ***
%==========================================================================
% It generates input data for a rectangular cross-section curved beam:
%   Rd - radius of the curved beam
%   width - width of the rectangular cross-section
%   t - height of the cross section
%   E - Young's modulus
%   H0 - horizontal force applied on the cantilever free end
%==========================================================================
% x, y  contain x and y nodal coordinates respectively    
%         
% elem  table contains element nodes
%       [node1  node2 
%        :      :     ]
%
% cond  table contains nodal constraints
%       (dir=1 - x direction, dir=2 - y direction)
%       [node1  dir1
%        node2  dir2
%        :      :   ]
%
% forze table contains nodal loads: node, direction, value
%       [node1  dir1  force1
%        node2  dir2  force2
%        :      :     :           :     ]
%==========================================================================
Rd=50;
width=20;
t=1;
E=2e5;
I=width*t^3/12;
A=width*t;
H0=300;            
EA=E*A;
GA=EA/2.6/1.2;
EI=E*width*t^3/12;
%==========================================================================
% nodal coordinates
nel=100;             % number of finite elements
nnd=nel+1;             % number of nodes
neq=3*nnd;
ang=pi/(nnd-1);
for i=1:nnd
    x(i,1)=Rd*cos((i-1)*ang);
    y(i,1)=Rd*sin((i-1)*ang);
end
elem=[[1:nel]' [2:nnd]'];
%==========================================================================
% constraints
cond=[  1   1
        1   2
        nnd 2];
%==========================================================================
% load
nf=nnd;
forze=[nf 1 H0];
%==========================================================================
Rt=zeros(6,6,nel);
for ie=1:nel
    n1=elem(ie,1);
    n2=elem(ie,2);
    dx=x(n2)-x(n1);
    dy=y(n2)-y(n1);
    L=sqrt(dx*dx+dy*dy);
    cs=dx/L;            
    sn=dy/L;
    Lt(ie)=L;    
    Rt(:,:,ie)=[ cs sn  0   0   0  0           
                -sn cs  0   0   0  0  
                  0  0  1   0   0  0  
                  0  0  0  cs  sn  0  
                  0  0  0 -sn  cs  0  
                  0  0  0   0   0  1];
end
