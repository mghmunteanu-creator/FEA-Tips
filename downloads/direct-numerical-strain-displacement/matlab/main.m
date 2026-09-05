% *** main ***
clear
format short e

nstep=5;                           % number of load steps
itermax=100;                       % maximum number of iterations
tol=1e-5;                          % tolerance

figure(5)
clf, hold on, grid on, axis('equal')

gen

St=zeros(neq,nstep+1);
strnt=zeros(4*nel,3,nstep+1);
sigmt=zeros(4*nel,4,nstep+1);

Fprev=zeros(2,2,4*nel,nstep+1);
Fprev(1,1,:,:)=1;
Fprev(2,2,:,:)=1;

for istep=1:nstep

    S=zeros(neq,1);
    error=1;
    iter=0;

    while (error > tol) & (iter < itermax)

        iter=iter+1;
        stiff

        dS=K\F;
        S=S-dS;

        error=sqrt(dS'*dS/neq);

    end

    x=x+S(1:2:neq);
    y=y+S(2:2:neq);

    patch('Vertices',[x y],'Faces',elem,...
          'Facecolor',[1 1 1],'linewidth',0.75,'edgecolor','b')

    [istep iter error]

    St(:,istep+1)=St(:,istep)+S;

    drawnow
    pause(0.01)

end

% Compute Von Mises stress:
sgech=sqrt(sigmt(:,1,:).^2+sigmt(:,2,:).^2-...
sigmt(:,1,:).*sigmt(:,2,:)+3*sigmt(:,3,:).^2);

sigmt(:,4,:)=sgech;
