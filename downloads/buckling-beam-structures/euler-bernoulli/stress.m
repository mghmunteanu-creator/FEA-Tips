% *** stress ***
% Sign convention: N<0 in compression.
for ie=1:nel
    n1=elem(ie,1);
    n2=elem(ie,2);
    L=Lt(ie);
    R=Rt(:,:,ie);
	ipos=[3*n1-2 3*n1-1 3*n1 3*n2-2 3*n2-1 3*n2];
    uel=R*S(ipos);
    Bux=[-1/L         0                  0          1/L       0                   0      ];
    ep=Bux*uel;
    N(ie,1)=ea*ep;
end
