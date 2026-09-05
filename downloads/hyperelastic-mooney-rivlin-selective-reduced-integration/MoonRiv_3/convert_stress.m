%*** convert_stress ***
% Converts the stored second Piola-Kirchhoff stresses to Cauchy stresses.
ii=0;
for i=1:nel;
	nodo1=elem(i,1); nodo2=elem(i,2); nodo3=elem(i,3); nodo4=elem(i,4);
    % conectivity matrix:
    ipos=[2*nodo1-1  2*nodo1  2*nodo2-1  2*nodo2  2*nodo3-1  2*nodo3  2*nodo4-1  2*nodo4];
    sel=St(ipos,istep+1);
	xel=[x(nodo1) x(nodo2) x(nodo3) x(nodo4)]';
	yel=[y(nodo1) y(nodo2) y(nodo3) y(nodo4)]';
	for j=1:4;
        ii=ii+1;
        s=st(1,j);
        t=st(2,j);

        H=[(1+t)/4  -(1+t)/4  -(1-t)/4  (1-t)/4
           (1+s)/4   (1-s)/4  -(1-s)/4 -(1+s)/4]; 	
        J=H*[ xel    yel];                           % Jacobian
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

        FF=[1+ux uy  0; vx 1+vy  0; 0  0  1];
        FF1=inv(FF); 
        % 2nd Piola-Kirchhoff to Cauchy stress
        ja=det(FF); 
        sgm=sigmt(ii,:,istep+1);
        sPK2=[sgm(1) sgm(4) 0; sgm(4) sgm(2)  0;  0   0  sgm(3)];
        scauchy=1/ja*FF*sPK2*FF';
        sigmC(ii,:,istep+1)=[scauchy(1,1) scauchy(2,2) scauchy(3,3) scauchy(1,2)];        
    end	
end

