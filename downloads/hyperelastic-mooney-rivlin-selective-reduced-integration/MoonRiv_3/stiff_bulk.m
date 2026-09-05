%*** stiff_bulk ***
for i=1:nel;
	nodo1=elem(i,1); nodo2=elem(i,2); nodo3=elem(i,3); nodo4=elem(i,4);
    % conectivity matrix:
    ipos=[2*nodo1-1  2*nodo1  2*nodo2-1  2*nodo2  2*nodo3-1  2*nodo3  2*nodo4-1  2*nodo4];
    sel=S(ipos);
	xel=[x(nodo1) x(nodo2) x(nodo3) x(nodo4)]'; 	% nodal
	yel=[y(nodo1) y(nodo2) y(nodo3) y(nodo4)]'; 	% coordinates 
    H=[1/4  -1/4  -1/4  1/4
       1/4   1/4  -1/4 -1/4]; 	
    J=H*[ xel    yel];                           % Jacobian
    detJ=abs(det(J));
    J1=inv(J);
    b=J1*H;
        
    Bux=[b(1,1)       0    b(1,2)       0    b(1,3)       0    b(1,4)       0];
    Buy=[b(2,1)       0    b(2,2)       0    b(2,3)       0    b(2,4)       0];
    
    Bvx=[   0    b(1,1)       0    b(1,2)       0    b(1,3)       0    b(1,4)];
    Bvy=[   0    b(2,1)       0    b(2,2)       0    b(2,3)       0    b(2,4)];    
    ux=Bux*sel;
    uy=Buy*sel;
    vx=Bvx*sel;
    vy=Bvy*sel; 
    % Green-Lagrange strains:
    ex =ux+ux^2/2+vx^2/2;
    ey =vy+uy^2/2+vy^2/2;
    exy=uy+vx+ux*uy+vx*vy;
    MoonRiv_bulk
    % store stresses:
    sigmt(4*i-3:4*i,:,istep+1)=sigmt(4*i-3:4*i,:,istep+1)+ones(4,1)*[sx sy sz sxy];   
    %G matrices:
    Gx =Bux'*Bux+Bvx'*Bvx;
    Gy =Buy'*Buy+Bvy'*Bvy;
    Gxy=Bux'*Buy+Bvx'*Bvy+Buy'*Bux+Bvy'*Bvx;
    % B matrix:
    Bx=Bux+sel'*Gx;
    By=Bvy+sel'*Gy;
    Bxy=Buy+Bvx+sel'*Gxy;
    B=[Bx; By; Bxy];
    % force and tangent stiffness matrices:
    fel=th*detJ*B'*[sx sy sxy]';
    kel=th*detJ*(B'*D([1 2 4],[1 2 4])*B+sx*Gx+sy*Gy+sxy*Gxy);
    % assembling process:
    F(ipos)=F(ipos)+4*fel;
    K(ipos,ipos)=K(ipos,ipos)+4*kel;
end
