%*** main ***
clear
format short e
gen
nstep=10; 
itermax=100;
tol=1e-5;
S=zeros(neq,1);
St=zeros(neq,nstep);
stress=zeros(nel,3,nstep);
figure(5), clf, hold on, grid on, axis('equal')
plot(x/Rd,y/Rd,'k','linewidth',1.5)
for istep=1:nstep
    error=1;
    iter=0;
    while (error > tol) & (iter < itermax)
        iter=iter+1;
        stiff
        dS=K\F;
        S=S-dS;
        error=sqrt(dS'*dS/nnd);
    end
    plot((x+S(1:3:neq))/Rd,(y+S(2:3:neq))/Rd,'b','linewidth',1)
    [istep iter error]
    St(:,istep+1)=S;
    pause(0.01)
end
print_results
diagrams
