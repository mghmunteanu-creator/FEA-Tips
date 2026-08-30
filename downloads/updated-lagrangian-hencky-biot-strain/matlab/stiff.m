%*** stiff ***
istrain=1;   % 1 - Hencky strain
             % 2 - Biot strain
E1=E/(1-nu*nu);  
E2=nu*E1;
G=E/2/(1+nu);
DHooke=[E1 E2 0
        E2 E1 0
         0  0 G];
F=zeros(neq,1);
K=zeros(neq);
% Gauss points
st=[1  -1  -1   1
    1   1  -1  -1]*sqrt(3)/3;
ig=0;
for ie=1:nel;
	n1=elem(ie,1); n2=elem(ie,2); n3=elem(ie,3); n4=elem(ie,4);
    ip=[2*n1-1  2*n1  2*n2-1  2*n2  2*n3-1  2*n3  2*n4-1  2*n4]; 
    sel=S(ip);
    %----------------------------------------------------------------------
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
        J=H*[ xel    yel];              % Jacobian
        detJ=abs(det(J));
        J1=inv(J);
        b=J1*H;
        Bux=[b(1,1)  0        b(1,2)   0        b(1,3)   0        b(1,4)   0     ];
        Buy=[b(2,1)  0        b(2,2)   0        b(2,3)   0        b(2,4)   0     ];
        Bvx=[0       b(1,1)   0        b(1,2)   0        b(1,3)   0        b(1,4)]; 
        Bvy=[0       b(2,1)   0        b(2,2)   0        b(2,3)   0        b(2,4)];            
        ux=Bux*sel;
        uy=Buy*sel;
        vx=Bvx*sel;
        vy=Bvy*sel; 
        % Deformation gradient F
        FF =[1+ux uy; vx 1+vy];
        C=FF'*FF;
        U=sqrtm(C);
        Ui=inv(U);        
        if istrain==1
            ee=logm(U);
            Uic=Ui^2;       % Hencky strain tensor
        elseif istrain==2
            ee=U-eye(2);
            Uic=Ui;         % Biot strain tensor
        else
            error('Unknown strain tensor option')
        end
        B_matrix
        ex =  ee(1,1)+strnt(ig,1,istep);
        ey =  ee(2,2)+strnt(ig,2,istep);
        exy=2*ee(1,2)+strnt(ig,3,istep);             
        sigmt(ig,1:3,istep+1)=[ex ey exy]*DHooke;
        th1=(1-nu/(1-nu)*(ex+ey))*th;
        fel=fel+th1*(B'*sigmt(ig,1:3,istep+1)')*detJ;
        kel=kel+th1*B'*DHooke*B*detJ;
        strnt(ig,:,istep+1)=[ex ey exy]; 
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
