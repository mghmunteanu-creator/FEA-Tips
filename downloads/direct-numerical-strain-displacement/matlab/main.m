% *** main ***
clear
format short e
nstep=10;                           % number of load steps
itermax=30;                       % maximum n umber of iterations
tol=1e-4;                          % tolerance
figure(5)
clf, hold on, grid on, axis('equal')
pause(0.01)
gen
St=zeros(neq,nstep+1);
S =zeros(neq,1);

strnt=zeros(4*nel,3,nstep+1);
sigmt=zeros(4*nel,7,nstep+1);
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
    patch('Vertices',[x+S(1:2:neq) y+S(2:2:neq)],'Faces',elem,'Facecolor',[1 1 1],'linewidth',0.75,'edgecolor','b')    
    drawnow
    [istep iter error]
    St(:,istep+1)=S;
end
% Compute Von Mises stress:
sgech=sqrt(sigmt(:,1,:).^2+sigmt(:,2,:).^2-sigmt(:,1,:).*sigmt(:,2,:)+3*sigmt(:,3,:).^2);
sigmt(:,4,:)=sgech;

