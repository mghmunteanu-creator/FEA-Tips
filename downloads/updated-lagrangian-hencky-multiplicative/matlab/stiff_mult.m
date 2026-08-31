% *** stiff_mult ***

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

    n1=elem(ie,1); n2=elem(ie,2);
    n3=elem(ie,3); n4=elem(ie,4);

    ipos=[2*n1-1  2*n1  2*n2-1  2*n2 ...
          2*n3-1  2*n3  2*n4-1  2*n4];

    sel=S(ipos);

    %----------------------------------------------------------------------
    % Initial nodal coordinates

    xel0=[x0(n1) x0(n2) x0(n3) x0(n4)]';
    yel0=[y0(n1) y0(n2) y0(n3) y0(n4)]';

    %----------------------------------------------------------------------
    % Nodal coordinates at the beginning of the current load step

    xel=[x(n1) x(n2) x(n3) x(n4)]';
    yel=[y(n1) y(n2) y(n3) y(n4)]';

    % Current trial nodal coordinates

    xelt=xel+sel(1:2:8);
    yelt=yel+sel(2:2:8);

    fel=zeros(8,1);
    kel=zeros(8);

    for j=1:4;

        ig=ig+1;

        s=st(1,j);
        t=st(2,j);

        H=[(1+t)/4  -(1+t)/4  -(1-t)/4   (1-t)/4
           (1+s)/4   (1-s)/4  -(1-s)/4  -(1+s)/4];

        %------------------------------------------------------------------
        % Jacobians

        J0=H*[xel0 yel0];       % initial configuration
        J =H*[xel  yel ];       % beginning of current load step
        Jt=H*[xelt yelt];       % current trial configuration

        detJ=abs(det(J));

        %------------------------------------------------------------------
        % Derivatives referred to the initial configuration

        J1=inv(J);
        b=J1*H;

        Bux=[b(1,1) 0 b(1,2) 0 b(1,3) 0 b(1,4) 0];
        Buy=[b(2,1) 0 b(2,2) 0 b(2,3) 0 b(2,4) 0];

        Bvx=[0 b(1,1) 0 b(1,2) 0 b(1,3) 0 b(1,4)];
        Bvy=[0 b(2,1) 0 b(2,2) 0 b(2,3) 0 b(2,4)];

        %------------------------------------------------------------------
        % Geometric matrices

        Gx =Bux'*Bux+Bvx'*Bvx;
        Gy =Buy'*Buy+Bvy'*Bvy;
        Gxy=Bux'*Buy+Bvx'*Bvy+Buy'*Bux+Bvy'*Bvx;

        %------------------------------------------------------------------
        % Incremental deformation gradient
        % current converged configuration -> current trial configuration

        Finc=(J\Jt)';

        %------------------------------------------------------------------
        % Multiplicative update
        %
        % Fprev(:,:,ig) is the total deformation gradient stored
        % at the end of the preceding converged load step

        Fp=Fprev(:,:,ig,istep);
        FF=Finc*Fp;
        Fprev(:,:,ig,istep+1)=FF;
        %------------------------------------------------------------------
        % Polar decomposition

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
        %------------------------------------------------------------------
        % Strain-displacement matrix
        %
        % New B_matrix is used.
        B_matrix_mult
        ex =ee(1,1);
        ey =ee(2,2);
        exy=2*ee(1,2);
        %------------------------------------------------------------------
        % Cauchy stresses
        sigmt(ig,1:3,istep+1)=[ex ey exy]*DHooke;
        % Thickness correction
        th1=(1-nu/(1-nu)*(ex+ey))*th;
        %------------------------------------------------------------------
        % Internal force vector
        fel=fel+th1*(B'*sigmt(ig,1:3,istep+1)')*detJ;
        %------------------------------------------------------------------
        % Tangent stiffness matrix
        kel=kel+th1*(B'*DHooke*B ...
            +sigmt(ig,1,istep+1)*Gx ...
            +sigmt(ig,2,istep+1)*Gy ...
            +sigmt(ig,3,istep+1)*Gxy)*detJ;
        strnt(ig,:,istep+1)=[ex ey exy];

    end
    % assembling process:
    F(ipos)=F(ipos)+fel;
    K(ipos,ipos)=K(ipos,ipos)+kel;

end

% Constraints
loc=2*(cond(:,1)-1)+cond(:,2);
K(loc,:)=0;
K(:,loc)=0;
F(loc)=0;
K(loc,loc)=eye(length(loc));

% Concentrated force
loc=2*(forze(:,1)-1)+forze(:,2);
F(loc)=F(loc)-forze(:,3)*istep/nstep;
