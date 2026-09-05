%*** plot_strain ***
iedge=0;    % iedge=1 - plot element contours
            % iedge=0 - does not plot
istep=input('Load step (default=nstep): ');   
if length(istep)==0, istep=nstep; end            
istrain=input('Strain (1-ex, 2-ey, 3-ez, 4-exy, default=1): ');
if length(istrain)==0, istrain=1; end            
scale=input('Scale (default=0): ');
if length(scale)==0, scale=0; end
u=St(1:2:neq,istep+1);
v=St(2:2:neq,istep+1);
x1=x+scale*u;
y1=y+scale*v;
if istrain==1
    sigmat=strnt(:,1,istep+1);
elseif istrain==2
    sigmat=strnt(:,2,istep+1);
elseif istrain==3
    sigmat=strnt(:,3,istep+1);
elseif istrain==4
    sigmat=strnt(:,4,istep+1);
end
strs=zeros(nnd,2);
isg=0;
for i=1:nel
    for j=1:4
        nod=elem(i,j);
        strs(nod,2)=strs(nod,2)+1;
        isg=isg+1;
        strs(nod,1)=strs(nod,1)+sigmat(isg);
    end
end
stress=strs(:,1)./strs(:,2);
smx=max(stress);
smn=min(stress);
figure(19+istrain)
clf
hold on
axis('equal')
colormap(turbo(16));
if iedge==0
    patch('Vertices',[x1 y1],'Faces',elem,'CData',stress,'Facecolor','interp','edgecolor','none')
else
    patch('Vertices',[x1 y1],'Faces',elem,'CData',stress,'Facecolor','interp','edgecolor','w')
end
colorbar
lighting phong

sigma_max=smx
sigma_min=smn
xlabel(['Min:' num2str(smn) '             Max:' num2str(smx)])
ww=' Green-Lagrange';
if istrain==1
    title(strcat('\epsilon_x',ww))
elseif istrain==2
    title(strcat('\epsilon_y',ww))    
elseif istrain==3
    title(strcat('\epsilon_z',ww))   
elseif istrain==4
    title(strcat('\epsilon_x_y',ww))   
end
drawnow
