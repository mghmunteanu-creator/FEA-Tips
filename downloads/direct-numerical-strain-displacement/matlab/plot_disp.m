% *** plot_disp ***
iedge=0;    % iedge=1 - plot element contours
            % iedge=0 - does not plot
istep=input('Load step (default=nstep): ');   
if length(istep)==0, istep=nstep; end           
idisp=input('Displacement (1-u, 2-v) (default=2): ');
if length(idisp)==0, idisp=2; end           
scale=input('Scale (default=1): ');
if length(scale)==0; scale=1; end
load_step=istep
u=St(1:2:neq,istep+1);
v=St(2:2:neq,istep+1);
%===================================
xc=x0+scale*u;
yc=y0+scale*v;
figure(9+idisp)
clf
hold on
axis('equal')
colormap(turbo(16));
disp=St(idisp:2:neq,istep+1);
dmx=max(disp);
dmn=min(disp);
if iedge==0
    patch('Vertices',[xc yc],'Faces',elem,'CData',disp,'Facecolor','interp','edgecolor','none')
else
    patch('Vertices',[xc yc],'Faces',elem,'CData',disp,'Facecolor','interp','edgecolor','w')
end
colorbar
lighting phong
disp_max=dmx
disp_min=dmn
if idisp==1
    sss='u  -  Load step ';
elseif idisp==2
    sss='v  -  Load step ';
end
title({[sss,num2str(istep)];['min= ',num2str(dmn),'  max=',num2str(dmx)]})
drawnow

