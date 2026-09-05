%*** plot_disp ***
iedge=0;    % iedge=1 - plot element contours
            % iedge=0 - does not plot
istep=input('Load step (default=nstep): ');   
if length(istep)==0, istep=nstep; end
idisp=input('Displacement (1-u, 2-v, default=2): ');
if length(idisp)==0, idisp=2; end
scale=input('Scale (default=1): ');
if length(scale)==0, scale=1; end
u=St(1:2:neq,istep+1);
v=St(2:2:neq,istep+1);
x1=x+scale*u;
y1=y+scale*v;
figure(9+idisp)
clf
hold on
axis('equal')
colormap(turbo(16));
disp=St(idisp:2:neq,istep+1);
dmx=max(disp);
dmn=min(disp);
if iedge==0
    patch('Vertices',[x1 y1],'Faces',elem,'CData',disp,'Facecolor','interp','edgecolor','none')
else
    patch('Vertices',[x1 y1],'Faces',elem,'CData',disp,'Facecolor','interp','edgecolor','w')
end
colorbar
lighting phong
disp_max=dmx
disp_min=dmn
xlabel(['Min:' num2str(dmn) '             Max:' num2str(dmx)])
if idisp==1
    title('u')
elseif idisp==2
    title('v')   
end
drawnow
