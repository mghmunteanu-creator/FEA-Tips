%*** stiff ***
% Gauss points
F=zeros(neq,1);
K=zeros(neq);
Jt=0;
% Gauss points
st=[1  -1  -1   1
    1   1  -1  -1]*sqrt(3)/3;
ig=0;
for i=1:nel;
	n1=elem(i,1); n2=elem(i,2); n3=elem(i,3); n4=elem(i,4);
    ip=[2*n1-1  2*n1  2*n2-1  2*n2  2*n3-1  2*n3  2*n4-1  2*n4]; 
    sel=S(ip);
    %----------------------------------------------------------------------
    sel=S(ip);
	xel=[x(n1) x(n2) x(n3) x(n4)]'; 	% nodal
	yel=[y(n1) y(n2) y(n3) y(n4)]'; 	% coordinates 
	fel=zeros(8,1);
	kel=zeros(8);
    for j=1:4;
        ig=ig+1;
        s=st(1,j);
        t=st(2,j);
        H=[(1+t)/4  -(1+t)/4  -(1-t)/4  (1-t)/4
           (1+s)/4   (1-s)/4  -(1-s)/4 -(1+s)/4]; 	
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
        B0=[Bux; Bvy; Buy+Bvx];
        % Green-Lagrange strains:
        ex =ux+ux^2/2+vx^2/2;
        ey =vy+uy^2/2+vy^2/2;
        exy=uy+vx+ux*uy+vx*vy;
        % constitutive calculation:
        ia=[1 2 4];

        if iplane==1
            MoonRiv_stress
            Dps=D(ia,ia);

        elseif iplane==2

            Cxx=2*ex+1; Cyy=2*ey+1; Cxy=exy;
            ez=(1/(Cxx*Cyy-Cxy^2)-1)/2;

            tolz=1e-10;
            iterzmax=25;

            for iterz=1:iterzmax
                MoonRiv_exact_stress
                if abs(sz)<tolz, break, end
                ez=ez-sz/D(3,3);
            end

            Dps=D(ia,ia)-D(ia,3)*(D(3,3)\D(3,ia));

            Jt=Jt+sqrt(I3);

        else
            error('Unknown plane-stress option')
        end
        %G matrices:
        Gx =Bux'*Bux+Bvx'*Bvx;
        Gy =Buy'*Buy+Bvy'*Bvy;
        Gxy=Bux'*Buy+Bvx'*Bvy+Buy'*Bux+Bvy'*Bvx;
        BL=[sel'*Gx; sel'*Gy; sel'*Gxy];
        % B matrix:
        B=B0+BL;
        % store stresses:
        sigmt(ig,:,istep+1)=[sx sy sz sxy];   
        % force and tangent stiffness matrices:
        fel=fel+th*detJ*B'*[sx sy sxy]';
        kel=kel+th*detJ*(B'*Dps*B+sx*Gx+sy*Gy+sxy*Gxy);
        % store strains:
        strnt(ig,:,istep+1)=[ex,ey,ez,exy];   
    end	
    % assembling process:
    F(ip)=F(ip)+fel;
    K(ip,ip)=K(ip,ip)+kel;
end
% Constraints
loc=2*(cond(:,1)-1)+cond(:,2);
K(loc,:  )=0; K(:  ,loc)=0; F(loc,:  )=0;                    
K(loc,loc)=eye(length(loc)); 
% Concentrated force
loc=2*(forze(:,1)-1)+forze(:,2);
F(loc)=F(loc)-forze(:,3)*istep/nstep;               

