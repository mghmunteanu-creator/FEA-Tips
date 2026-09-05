% *** strain_el ***

% Current trial nodal coordinates
xelt=xel+sels(1:2:8);
yelt=yel+sels(2:2:8);

% Current trial Jacobian
Jt=H*[xelt yelt];

% Incremental and total deformation gradients
Finc=(J\Jt)';
Ftot=Finc*Fp;

% Right stretch tensor
C=Ftot'*Ftot;

[Q,L]=eig(C);
la=sqrt(diag(L));

U=Q*diag(la)*Q';

if istrain==1
    EE=Q*diag(log(la))*Q';
elseif istrain==2
    EE=U-eye(2);
else
    error('Unknown strain tensor option')
end

% Engineering notation in the global frame
estr=[  EE(1,1)
        EE(2,2)
      2*EE(1,2)];
