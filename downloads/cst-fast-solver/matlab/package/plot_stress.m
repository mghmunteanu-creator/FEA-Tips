%*** plot_stress ***

iedge=0;    % iedge=1 - plot element contours
            % iedge=0 - does not plot
istress=input('Stress (1-sx, 2-sy, 3-txy, 4-VM): ');
if length(istress)==0, istress=1, end
scale=input('Displacement scale: ');
if length(scale)==0, scale=1, end         
u=S(1:ngn:neq);
v=S(2:ngn:neq);
sigmat=zeros(nel,3);
for ie=1:nel;
    nd1=elem(ie,1); nd2=elem(ie,2); nd3=elem(ie,3);
    DB0=DB(:,:,ie)/Ath(ie);
    % nodal displacements of the current element:
    uel=[u(nd1) v(nd1) u(nd2) v(nd2) u(nd3) v(nd3)]';  
    % stresses:
    sigma=DB0*uel;     
    sigmat(ie,:)=sigma';
end;
sgech=sqrt(sigmat(:,1).^2+sigmat(:,2).^2-sigmat(:,1).*sigmat(:,2)+3*sigmat(:,3).^2);
sigmat=[sigmat sgech];
%===================================
nodelem=zeros(n,8);
for ie=1:nel
	for j=1:3
        nod=elem(ie,j);
        nodelem(nod,1)=nodelem(nod,1)+1;
        iloc=nodelem(nod,1)+1;
        nodelem(nod,iloc)=ie;
	end
end    

for i=1:n                     % Computing of stresses in each node
        nmax=nodelem(i,1);
        nrel=nodelem(i,2:nmax+1);
        stress(i)=sum(sigmat(nrel',istress))/nmax;
end
%===================================
x1=x+scale*u;
y1=y+scale*v;

figure(3)
clf
hold on
axis('equal')
colormap(jet(16));

smx=max(stress);
smn=min(stress);

if iedge==0
    patch('Vertices',[x1 y1],'Faces',elem(:,1:3),'CData',stress,'Facecolor','interp','edgecolor','none')
else
    patch('Vertices',[x1 y1],'Faces',elem(:,1:3),'CData',stress,'Facecolor','interp','edgecolor','w')
end
colorbar

sigma_max=smx
sigma_min=smn

if istress==1
    title('\sigma_x')
elseif istress==2
    title('\sigma_y')   
elseif istress==3
    title('\tau_x_y')  
elseif istress==4
    title('\sigma_V_M')
end
