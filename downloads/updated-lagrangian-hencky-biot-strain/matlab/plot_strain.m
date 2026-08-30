%*** plot_strain ***
iedge=0;    % iedge=1 - plot element contours
            % iedge=0 - does not plot
istep=input('Load step (default=nstep): ');
if length(istep)==0; istep=nstep; end
istrain=input('Strain (1-ex, 2-ey, 3-gxy) (default=1): ');
if length(istrain)==0; istrain=1; end
scale=input('Scale (default=1): ');
if length(scale)==0; scale=1; end
load_step=istep
u=St(1:2:neq,istep+1);
v=St(2:2:neq,istep+1);
xc=x0+u*scale;
yc=y0+v*scale;
%==========================================================================
% extrapolation of the strains from Gauss points to element nodes
% (the strains are computed in stiff subprogram, in Gauss points)
strnti=zeros(4*nel,3);
st=[1  -1  -1   1
    1   1  -1  -1]*sqrt(3)/3;
ig=1;
for ie=1:nel
    n1=elem(ie,1); n2=elem(ie,2); n3=elem(ie,3); n4=elem(ie,4);
    xel=[xc(n1) xc(n2) xc(n3) xc(n4)]'; 	% nodal
	yel=[yc(n1) yc(n2) yc(n3) yc(n4)]'; 	% coordinates 
    sig0=strnt(ig:ig+3,istrain,istep);
    for j=1:4
        s=st(1,j);
        t=st(2,j);
        N=[(1+s)*(1+t)/4 (1-s)*(1+t)/4 (1-s)*(1-t)/4 (1+s)*(1-t)/4];
        xst(j,1)=N*xel;
        yst(j,1)=N*yel;
    end
    A0=[xst yst ones(4,1)];
    A=A0'*A0;
    B=A0'*sig0;
    a=A\B;
    sig=a(1)*xel+a(2)*yel+a(3)*ones(4,1);
    strnti(ig:ig+3,istrain)=sig;
    ig=ig+4;
end   
%==========================================================================
% Compute the nodal strains performing the arithmetic average of the 
% strains for the elements connected in the same node.
strs=zeros(nnd,2);
ig=0;
for i=1:nel
    for j=1:4
        nod=elem(i,j);
        strs(nod,2)=strs(nod,2)+1;
        ig=ig+1;
        strs(nod,1)=strs(nod,1)+strnti(ig,istrain);
    end
end
strain=strs(:,1)./strs(:,2);
%==========================================================================
% Graphic representation
figure(14+istrain)
clf
hold on
axis('equal')
colormap(jet(16))
smx=max(strain);
smn=min(strain);
if iedge==0
    patch('Vertices',[xc yc],'Faces',elem,'CData',strain,'Facecolor','interp','edgecolor','none')
else
    patch('Vertices',[xc yc],'Faces',elem,'CData',strain,'Facecolor','interp','edgecolor','w')
end
colorbar
lighting phong
epsilon_max=smx
epsilon_min=smn
if istrain==1
    sss='\epsilon_x  -  Load step ';
elseif istrain==2
    sss='\epsilon_y  -  Load step ';
elseif istrain==3
    sss='\gamma_x_y  -  Load step ';
end
title({[sss,num2str(istep)];['min= ',num2str(smn),'  max=',num2str(smx)]})
