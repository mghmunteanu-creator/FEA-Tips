%*** deriv ***
Nux=[-1/L         0                  0          1/L       0                   0      ];
Nvx=[  0    (-6*xc+6*xc*xc)/L   1-4*xc+3*xc*xc   0   (6*xc-6*xc*xc)/L   -2*xc+3*xc*xc];
Nca=[  0    (12*xc-6)/L/L       (6*xc-4)/L       0   (6-12*xc)/L/L      (6*xc-2)/L ]; 

%    linear       quadratic 
ep = Nux*uel   +1/2*(Nvx*uel)^2;
ep1= Nux'      +(Nvx'*Nvx)*uel;
ep2=            Nvx'*Nvx;

ca =Nca*uel;
ca1=Nca';
ca2=zeros(6);
