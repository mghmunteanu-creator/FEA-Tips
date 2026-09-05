%*** MoonRiv_stress ***
Cxx=2*ex+1; Cyy=2*ey+1; Cxy=exy;
d=(Cxy^2 - Cxx*Cyy);
ez=-(1/d+1)/2;
I1=Cxx + Cyy - 1/d;
I2=Cxx*Cyy - Cxy^2 - Cxx/d - Cyy/d; 
I3=1;
 
I1E=[2 - (2*Cyy)/d^2
     2 - (2*Cxx)/d^2
                   0
         (2*Cxy)/d^2
                   0
                   0];                                
I2E=[ 2*Cyy - 2/d - (2*Cyy^2)/d^2 - (2*Cxx*Cyy)/d^2
      2*Cxx - 2/d - (2*Cxx^2)/d^2 - (2*Cxx*Cyy)/d^2
                                                  0
          (2*Cxx*Cxy)/d^2 - 2*Cxy + (2*Cxy*Cyy)/d^2
                                                  0
                                                  0];
I3E=zeros(6,1);
 
I1EE=[[                 -(8*Cyy^2)/d^3, - 4/d^2 - (8*Cxx*Cyy)/d^3,                     0,       (8*Cxy*Cyy)/d^3, 0, 0]
      [      - 4/d^2 - (8*Cxx*Cyy)/d^3,            -(8*Cxx^2)/d^3,                     0,       (8*Cxx*Cxy)/d^3, 0, 0]
      [                              0,                         0,                     0,                     0, 0, 0]
      [                (8*Cxy*Cyy)/d^3,           (8*Cxx*Cxy)/d^3,                     0, 2/d^2 - (8*Cxy^2)/d^3, 0, 0]
      [                              0,                         0,                     0,                     0, 0, 0]
      [                              0,                         0,                     0,                     0, 0, 0]];

I2EE=[[                     - (8*Cyy^3)/d^3 - (8*Cyy)/d^2 - (8*Cxx*Cyy^2)/d^3, 4 - (8*Cyy)/d^2 - (8*Cxx*Cyy^2)/d^3 - (8*Cxx^2*Cyy)/d^3 - (8*Cxx)/d^2, 0,                 (4*Cxy)/d^2 + (8*Cxy*Cyy^2)/d^3 + (8*Cxx*Cxy*Cyy)/d^3, 0, 0]
      [ 4 - (8*Cyy)/d^2 - (8*Cxx*Cyy^2)/d^3 - (8*Cxx^2*Cyy)/d^3 - (8*Cxx)/d^2,                     - (8*Cxx^3)/d^3 - (8*Cxx)/d^2 - (8*Cxx^2*Cyy)/d^3, 0,                 (4*Cxy)/d^2 + (8*Cxx^2*Cxy)/d^3 + (8*Cxx*Cxy*Cyy)/d^3, 0, 0]
      [                                                                     0,                                                                     0, 0,                                                                     0, 0, 0]
      [                 (4*Cxy)/d^2 + (8*Cxy*Cyy^2)/d^3 + (8*Cxx*Cxy*Cyy)/d^3,                 (4*Cxy)/d^2 + (8*Cxx^2*Cxy)/d^3 + (8*Cxx*Cxy*Cyy)/d^3, 0, (2*Cxx)/d^2 + (2*Cyy)/d^2 - (8*Cxx*Cxy^2)/d^3 - (8*Cxy^2*Cyy)/d^3 - 2, 0, 0]
      [                                                                     0,                                                                     0, 0,                                                                     0, 0, 0]
      [                                                                     0,                                                                     0, 0,                                                                     0, 0, 0]];
I3EE=zeros(6);
 
J1 =I1*I3^(-1/3);
J1E=I1E*I3^(-1/3)-1/3*I1*I3^(-4/3)*I3E;
J1EE=I1EE*I3^(-1/3)-1/3*I3^(-4/3)*(I1E*I3E'+I3E*I1E')+ 4/9*I1*I3^(-7/3)*I3E*I3E'-1/3*I1*I3^(-4/3)*I3EE;

J2 =I2*I3^(-2/3);
J2E=I2E*I3^(-2/3)-2/3*I2*I3^(-5/3)*I3E;
J2EE=I2EE*I3^(-2/3)-2/3*I3^(-5/3)*(I2E*I3E'+I3E*I2E')+10/9*I2*I3^(-8/3)*I3E*I3E'-2/3*I2*I3^(-5/3)*I3EE;

J3  =sqrt(I3);
J3E =1/2*I3^(-1/2)*I3E;
J3EE=1/2*I3^(-1/2)*I3EE-1/4*I3^(-3/2)*I3E*I3E';

% 2nd Piola-Kirchhoff stress tensor
SS=A10*J1E+A01*J2E+KK*(J3-1)*J3E;
sx =SS(1);
sy =SS(2);
sz =SS(3);
sxy=SS(4);
%==========================================================================
% D matrix
D=A10*J1EE+A01*J2EE+KK*J3E*J3E';
