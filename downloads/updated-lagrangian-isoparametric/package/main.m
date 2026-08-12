%*** main ***
clear
format short e
gen
nstep=10;        % number of load steps
itermax=100;	 % maximum iteration loops
tol=1e-5;        % tolerance
St=zeros(neq,nstep+1);
strn  =zeros(nel,3,nstep+1);
stress=zeros(nel,3,nstep+1);
figure(5), clf, hold on, grid on, axis('equal')
plot(x/Lb,y/Lb,'k','linewidth',1.5)
%cl='k'; plt
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
    plot(x/Lb,y/Lb,'k','linewidth',1.5)
    %cl='b'; plt
    [istep iter error]
    St(:,istep+1)=St(:,istep)+S;
    pause(0.01)
end
stress(:,1,:)=EA*strn(:,1,:);
stress(:,2,:)=EI*strn(:,2,:);
stress(:,3,:)=GA*strn(:,3,:);
print_results
