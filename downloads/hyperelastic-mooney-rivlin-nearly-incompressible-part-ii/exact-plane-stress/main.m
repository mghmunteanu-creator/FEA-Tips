%*** main ***
clear
format short e
nstep=20;           % number of load steps
itermax=1000;       % Maximum number of iterations
tol=1e-6;           % Tolerance
iplane=2;           % 1 - J=1 approximation
                    % 2 - exact plane stress, Sz=0
figure(5)
clf, hold on, grid on, axis('equal')
gen
S=zeros(neq,1);                 % nodal displacemens for the current load step
St=zeros(neq,nstep);            % nodal displacements for all load steps
strnt=zeros(4*nel,4,nstep+1);   % Green-Lagrange strain for all elements & for all load steps
sigmt=zeros(4*nel,4,nstep+1);   % 2nd Piola-Kirchh0ff stresses for all elements & for all load steps
for istep=1:nstep
    error=1;
    iter=0;
    while (error > tol) & (iter < itermax)
        iter=iter+1;
        stiff
        dS=K\F;
        S=S-dS;
        error=sqrt(dS'*dS/neq);
    end
    u=S(1:2:neq);
    v=S(2:2:neq);
    patch('Vertices',[x+u y+v],'Faces',elem,'Facecolor',[1 1 1],'linewidth',0.75,'edgecolor','b')    
    drawnow
    [istep iter error]
    St(:,istep+1)=S;
    pause(0.01)
end

if iplane==2, disp(['J_mean = ',num2str(Jt/4/nel)]), end
