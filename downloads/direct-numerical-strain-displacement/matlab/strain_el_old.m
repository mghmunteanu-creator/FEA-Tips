% *** strain_el ***

% Current trial nodal coordinates
xelt=xel0+sels(1:2:8);
yelt=yel0+sels(2:2:8);

% Current trial Jacobian
Jt=H*[xelt yelt];

% Total deformation gradient
Ftot=(J0\Jt)';

% Polar decomposition F=R*U
C=Ftot'*Ftot;
U=sqrtm(C);
R=Ftot/U;

% Strain tensor referred to the initial orientation
if istrain==1
    EE=logm(U);              % Hencky strain tensor
elseif istrain==2
    EE=U-eye(2);             % Biot strain tensor
else
    error('Unknown strain tensor option')
end

% Same strain tensor rotated to the current orientation
ee=R*EE*R';

% Engineering notation
estr=[  ee(1,1)
        ee(2,2)
      2*ee(1,2)];
