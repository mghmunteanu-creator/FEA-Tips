%*** plot_stress ***

iedge=0;    % iedge=1 - plot element contours
            % iedge=0 - does not plot         
istress=input('Stress (1-sx, 2-sy, 3-txy, 4-VM): ');
if length(istress)==0; istress=1; end
scale=input('Displacement scale: ');
if length(scale)==0; scale=1; end
u=S(1:ngn:neq);
v=S(2:ngn:neq);
Ht=[1  -1   0   0
    1   0   0  -1
    1  -1   0   0
    0   1  -1   0
    0   0  -1   1
    0   1  -1   0
    0   0  -1   1
    1   0   0  -1]/2;
B=zeros(3,6);   
sigmat=zeros(4*nel,4);
ig=0;
for i=1:nel
	n1=elem(i,1); n2=elem(i,2); n3=elem(i,3); n4=elem(i,4);
	ip=[ngn*n1-1 ngn*n1 ngn*n2-1 ngn*n2 ngn*n3-1 ngn*n3 ngn*n4-1 ngn*n4];
	xel=x([n1 n2 n3 n4]); yel=y([n1 n2 n3 n4]);     % nodal coordinates
	del=S(ip);
	for ip=1:4;
        H=Ht(2*ip-1:2*ip,:);
		J=H*[xel   yel];                            % the Jacobian
		br=inv(J)*H;
        B(1,[1 3 5 7])=br(1,:); 
        B(2,[2 4 6 8])=br(2,:);
        B(3,[2 4 6 8 1 3 5 7])=[br(1,:) br(2,:)];
        % stresses (sigma_x, sigma_y, tau_xy):
		sigma=DHooke*B*del; 
        % von Mises stress:
	   	sgech=sigma(1)^2+sigma(2)^2-sigma(1)*sigma(2)+3*sigma(3)^2;
        % sigma_x, sigma_y, tau_xy, von Mises stress:
        sigma=[sigma' sqrt(sgech)]; 	
        ig=ig+1;
        sigmat(ig,:)=sigma;
	end;
end;
x1=x+scale*u;
y1=y+scale*v;
strs=zeros(nnd,2);
ig=0;
for i=1:nel
    for j=1:4
        nod=elem(i,j);
        strs(nod,2)=strs(nod,2)+1;
        ig=ig+1;
        strs(nod,1)=strs(nod,1)+sigmat(ig,istress);
    end
end
stress(:,1)=strs(:,1)./strs(:,2);
smx=max(stress);
smn=min(stress);
figure(3)
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
