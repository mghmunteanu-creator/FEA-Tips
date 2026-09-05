% *** gen ***
%==========================================================================
% It generates input data for a cantilevr beam:
%   Lb- length of the beam
%   E - Young's modulus
%   G - Shear modulus
%   A - cross-section area
%   A0- shear area
%   I - geometrical inertia moment of cross-section
%   H - horizontal force applied on the cantilever free end
%==========================================================================
% x, y  contain x and y nodal coordinates 
%
% elem  table contains element nodes
%       [node1  node2 ]
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
H=-1;          % compressive horizontal force
Lb=1000;       % beam length
width=20;      % width of the rectangular cross-section
th=20;         % thickness of the rectangular cross-section
E=2e5;         % Young's modulus
G=E/2.5;       % transversal modulus of elasticity

nnd=100;          % number of nodes
nel=nnd-1;       % number of beam elemens
neq=3*nnd;
%--------------------------------------------------------------------------
A=width*th;
A0=5/6*A; % rectangular cross-section
I=width*th^3/12;
ea=E*A;
ga=G*A0;
ei=E*I;
%==========================================================================
% nodal coordinates
x=[0:Lb/nel:Lb]';
y=x*0;
%==========================================================================
% beam elements
n1=1:nel; n2=n1+1;
elem=[n1' n2'];
%==========================================================================
cond=[ 1   1
       1   2
       1   3
       nnd 2];
%==========================================================================
forze=[nnd 1 H];
%==========================================================================
%Rotation matrices:
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
