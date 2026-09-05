%*** plot_disp ***
iedge=0;    % iedge=1 - plot element contours
            % iedge=0 - do not plot element contours

idisp=input('Displacement (1-u, 2-v, default 1): ');
if length(idisp)==0, idisp=1, end
scale=input('Displacement scale (default 0): ');
if length(scale)==0, scale=0, end
u=S(1:ngn:neq,1);
v=S(2:ngn:neq,1);
x1=x+scale*u;
y1=y+scale*v;

figure(2)
clf
hold on
axis('equal')
colormap(turbo(16));

disp=S(idisp:2:neq,1);
dmx=max(disp);
dmn=min(disp);

if iedge==0
    patch('Vertices',[x1 y1],'Faces',elem(:,1:3),'CData',disp,'Facecolor','interp','edgecolor','none')
else
    patch('Vertices',[x1 y1],'Faces',elem(:,1:3),'CData',disp,'Facecolor','interp','edgecolor','w')
end
colorbar
lighting phong

disp_max=dmx
disp_min=dmn

if idisp==1
    title('u')
elseif idisp==2
    title('v')
end
drawnow
