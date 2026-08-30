% *** fel_el ***

fel=zeros(8,1);

% Gauss points
st=[1  -1  -1   1
    1   1  -1  -1]*sqrt(3)/3;

for j=1:4

    s=st(1,j);
    t=st(2,j);

    H=[(1+t)/4  -(1+t)/4  -(1-t)/4   (1-t)/4
        (1+s)/4   (1-s)/4  -(1-s)/4  -(1+s)/4];

    % Initial Jacobian
    J0=H*[xel0 yel0];
    detJ=abs(det(J0));

    % -------------------------------------------------------------
    % Total strain for the unperturbed element displacement
    % -------------------------------------------------------------
    sels=sel;
    strain_el
    e0=estr;
    R0=R;                   % total rotation for the unperturbed state

    % -------------------------------------------------------------
    % Numerical strain-displacement matrix B
    % -------------------------------------------------------------
    B=zeros(3,8);

    for ib=1:8

        % +ddB
        sels=sel;
        sels(ib)=sels(ib)+ddB;

        strain_el
        ep=estr;

        % -ddB
        sels=sel;
        sels(ib)=sels(ib)-ddB;

        strain_el
        em=estr;

        B(:,ib)=(ep-em)/(2*ddB);

    end

    % -------------------------------------------------------------
    % Cauchy stresses
    % -------------------------------------------------------------
    sig=e0'*DHooke;

    % Thickness correction
    th1=(1-nu/(1-nu)*(e0(1)+e0(2)))*th;

    % -------------------------------------------------------------
    % Internal force vector
    % -------------------------------------------------------------
    fel=fel+th1*(B'*sig')*detJ;

    % Store only the unperturbed evaluation
    if isave==1

        ig=4*(ie-1)+j;

        % Global Cauchy stresses
        sigmt(ig,1:3,istep+1)=sig;

        % Local Cauchy stresses
        sg=[sig(1) sig(3)
            sig(3) sig(2)];

        sl=R0'*sg*R0;

        sigmt(ig,5:7,istep+1)=[sl(1,1) sl(2,2) sl(1,2)];

        strnt(ig,:,istep+1)=e0';

    end

end
