%*** MoonRiv_exact_stress ***
% Three-dimensional constitutive response used for exact plane stress.

Cxx=2*ex+1; Cyy=2*ey+1; Czz=2*ez+1; Cxy=exy;

I1=Cxx+Cyy+Czz;
I2=Cxx*Cyy+Cyy*Czz+Czz*Cxx-Cxy^2;
I3=Czz*(Cxx*Cyy-Cxy^2);

I1E=[2; 2; 2; 0; 0; 0];
I2E=[2*(Cyy+Czz)
     2*(Cxx+Czz)
     2*(Cxx+Cyy)
     -2*Cxy
     0
     0];
I3E=[2*Cyy*Czz
     2*Cxx*Czz
     2*(Cxx*Cyy-Cxy^2)
     -2*Czz*Cxy
     0
     0];

I1EE=zeros(6);
I2EE=[0 4 4 0 0 0
      4 0 4 0 0 0
      4 4 0 0 0 0
      0 0 0 -2 0 0
      0 0 0 0 -2 0
      0 0 0 0 0 -2];
I3EE=[0 4*Czz 4*Cyy 0 0 0
      4*Czz 0 4*Cxx 0 0 0
      4*Cyy 4*Cxx 0 -4*Cxy 0 0
      0 0 -4*Cxy -2*Czz 0 0
      0 0 0 0 -2*Cxx 2*Cxy
      0 0 0 0 2*Cxy -2*Cyy];

J1 =I1*I3^(-1/3);
J1E=I1E*I3^(-1/3)-1/3*I1*I3^(-4/3)*I3E;
J1EE=I1EE*I3^(-1/3)-1/3*I3^(-4/3)*(I1E*I3E'+I3E*I1E')+...
       4/9*I1*I3^(-7/3)*I3E*I3E'-1/3*I1*I3^(-4/3)*I3EE;

J2 =I2*I3^(-2/3);
J2E=I2E*I3^(-2/3)-2/3*I2*I3^(-5/3)*I3E;
J2EE=I2EE*I3^(-2/3)-2/3*I3^(-5/3)*(I2E*I3E'+I3E*I2E')+...
       10/9*I2*I3^(-8/3)*I3E*I3E'-2/3*I2*I3^(-5/3)*I3EE;

J3  =sqrt(I3);
J3E =1/2*I3^(-1/2)*I3E;
J3EE=1/2*I3^(-1/2)*I3EE-1/4*I3^(-3/2)*I3E*I3E';

SS=A10*J1E+A01*J2E+KK*(J3-1)*J3E;
sx =SS(1);
sy =SS(2);
sz =SS(3);
sxy=SS(4);

D=A10*J1EE+A01*J2EE+KK*((J3-1)*J3EE+J3E*J3E');
