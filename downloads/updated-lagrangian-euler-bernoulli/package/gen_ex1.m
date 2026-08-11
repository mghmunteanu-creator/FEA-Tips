%*** gen_ex1 ***
M0=5236;               % applied moment
Lb=100;                % length of beam
width=5;               % width of cross-section
t=1;                   % thickness of cross-section
E=2e5;                 % Young modulus
EI=E*width*t^3/12;
EA=E*width*t;
nel=100;               % number of finite elements
nnd=nel+1;             % number of nodes
neq=3*nnd;
L=Lb/nel;              % length of one finite element
Lt=ones(nel,1)*L;
x=[0:L:Lb+L/100]';     % nodal coordinates
y=x*0;
elem=[1:nel; 2:nnd]';  % finite elements
cond=[1    1           % boundary constraints
      1    2
      1    3];

nf=nnd; 
forze=[nf 3 M0];     % load
%==========================================================================
Rt=zeros(6,6,nel);     % Rotation matrices
for ie=1:nel
    n1=elem(ie,1);
    n2=elem(ie,2);
    dx=x(n2)-x(n1);
    dy=y(n2)-y(n1);
    L=sqrt(dx*dx+dy*dy);
    Lt(ie)=L;
    cs=dx/L;            
    sn=dy/L;
    Rt(:,:,ie)=[ cs sn  0   0   0  0        % initial rotation matrices    
                -sn cs  0   0   0  0
                  0  0  1   0   0  0
                  0  0  0  cs  sn  0
                  0  0  0 -sn  cs  0
                  0  0  0   0   0  1];
end
