%*** gen ***
V0=90;              % vertical force
Lb=100;             % length of the beam
width=5;            % width of the cross-section
t=1;                % thickness of the cross-section
E=2e5;              % Young's modulus
G=E/2.5;            % shear modulus
EI=E*width*t^3/12;  
EA=E*width*t;
GA=G*width*t*5/6;   % rectangular cross-section
nel=20;             % number of finite elements
nnd=nel+1;          % number of nodes
neq=3*nnd;
L=Lb/nel;           % length of one finite element
x=[0:L:Lb+L/2]'*sqrt(0.5);
y=x;
elem=[[1:nel]' [2:nnd]'];
cond=[  1  2
        1  3
      nnd  1];
forze=[nnd 2 V0];
%==========================================================================
Rt=zeros(6,6,nel);
for ie=1:nel
    n1=elem(ie,1);
    n2=elem(ie,2);
    dx=x(n2)-x(n1);
    dy=y(n2)-y(n1);
    L=sqrt(dx*dx+dy*dy);
    Lt(ie)=L;
    cs=dx/L;            
    sn=dy/L;
    Rt(:,:,ie)=[ cs sn  0   0   0  0            
                -sn cs  0   0   0  0
                  0  0  1   0   0  0
                  0  0  0  cs  sn  0
                  0  0  0 -sn  cs  0
                  0  0  0   0   0  1];
end
