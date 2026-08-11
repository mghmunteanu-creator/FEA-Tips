%*** main ***
clear
format short e
gen_ex1
nstep=100;              % number of load steps
tol=1e-5;               % tolerance 
itermax=50;             % max number of iterations
St=zeros(neq,nstep+1);  % nodal displacements in all load steps
strn  =zeros(2*nel,2,nstep+1);   % strains in Gauss points
stress=zeros(2*nel,2,nstep+1);   % stresses in Gauss points
figure(5), clf, hold on, grid on, axis('equal')
plot(x/Lb,y/Lb,'k','linewidth',1)
title('Deformed beam')
xlabel('x/L_b')
ylabel('y/L_b')
for istep=1:nstep
    S=zeros(neq,1);
    error=1;
    iter=0;
    while (error > tol) & (iter < itermax)
        iter=iter+1;
        stiff
        dS=K\F;
        S=S-dS;
        error=sqrt(dS'*dS/nnd);    
    end
    updt
    plot(x/Lb,y/Lb,'r','linewidth',1)
    [istep iter error]
    St(:,istep+1)=St(:,istep)+S;
    pause(0.01)
end
stress(:,1,:)=EA*strn(:,1,:);
stress(:,2,:)=EI*strn(:,2,:);
print_results
