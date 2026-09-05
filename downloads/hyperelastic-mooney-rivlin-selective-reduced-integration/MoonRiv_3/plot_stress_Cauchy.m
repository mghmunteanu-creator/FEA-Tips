%*** plot_stress_Cauchy ***
iedge=0;    % iedge=1 - plot element contours
            % iedge=0 - does not plot
istep=input('Load step (default=nstep): ');   
if length(istep)==0, istep=nstep; end            
istress=input('Stress (1-sx, 2-sy, 3-sz, 4-sxy, 5-VM, default=1): ');
if length(istress)==0, istress=1; end            
convert_stress
scale=input('Scale (default=0): ');
if length(scale)==0, scale=0; end

u=St(1:2:neq,istep+1);
v=St(2:2:neq,istep+1);

x1=x+scale*u;
y1=y+scale*v;

if istress==1
    sigmat=sigmC(:,1,istep+1);
elseif istress==2
    sigmat=sigmC(:,2,istep+1);
elseif istress==3
    sigmat=sigmC(:,3,istep+1);    
elseif istress==4
    sigmat=sigmC(:,4,istep+1);
elseif istress==5    
    sx =sigmC(:,1,istep+1);
    sy =sigmC(:,2,istep+1);
    sz =sigmC(:,3,istep+1);
    sxy=sigmC(:,4,istep+1);
    sigmat=sqrt(sx.^2+sy.^2+sz.^2-sx.*sy-sy.*sz-sz.*sx+3*sxy.^2);
elseif istress==6
    sigmat=sqrt(jat);
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

figure(19+istress)
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
ww=' Cauchy';
if istress==1
    title(strcat('\sigma_x',ww))
elseif istress==2
    title(strcat('\sigma_y',ww))    
elseif istress==3
    title(strcat('\sigma_z',ww))    
elseif istress==4
    title(strcat('\tau_x_y',ww))   
elseif istress==5
    title(strcat('\sigma_V_M',ww))
elseif istress==6
    title(strcat('J=det(F)'))
end
drawnow
