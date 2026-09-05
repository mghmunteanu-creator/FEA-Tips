%*** gen ***
E=4;                % Young modulus
nu=0.495;           % Poisson ratio

A10=0.48;           % Mooney-Rivlin 
A01=0.11;           % material constants

KK=E/3/(1-2*nu);    % Bulk modulus
FFF=160;            % Load
th=1;               % Thickness
%==========================================================================
load nodes
x=nodes(:,2); 
y=nodes(:,3);
load elements
elem=elements(:,7:10);
ndfx=[  27    62    63    64    65    66    67    68    69    70    71    72    73    74    75    76    77    78    79    80 81    82    83    84    85    86];
ic=0;
for i=1:length(ndfx)
    ic=ic+1;
    cond(ic,1)=ndfx(i);
    cond(ic,2)=2;
end
ic=ic+1;
cond(ic,1)=74;
cond(ic,2)=1;

nld= [ 1     2     3     4     5     6     7     8     9    10    11    12    13    14    15    16    17    18    19    20    21    22    23    24    25    26];
dF=-FFF/25;
for i=1:length(nld)
   forze(i,1)=nld(i);
   forze(i,2)=2;
   forze(i,3)=dF;
   if i==1 | i==2
      forze(i,3)=dF/2;
   end
end
nnd=length(x(:,1));                 % number of nodes
nel=length(elem(:,1));            % number of finite elements
neq=2*nnd;                          % number of nodal unknowns
%==========================================================================
% Plot the mesh
patch('Vertices',[x y],'Faces',elem(:,1:4),'Facecolor',[1 1 1],'linewidth',0.75,'edgecolor','b')
ln=length(nld);
dH=4;
for i=1:ln
    lk=dH;
    if i==1 | i==2
        lk=dH/2;
    end
    quiver(x(nld(i)),y(nld(i)),0,-5*lk,'r','linewidth',1.5)
end
for i=1:length(ndfx)
    i1=ndfx(i);
    xt=x(i1); yt=y(i1);
    fill([xt xt-dH*0.4 xt+dH*0.4],[yt yt+dH*0.75 yt+dH*0.75],'g')
end   
xt=x(74); yt=y(74);
fill([xt xt-dH*0.75 xt-dH*0.75],[yt yt+dH*0.4 yt-dH*0.4],'g')

patch('Vertices',[x y],'Faces',elem(:,1:4),'Facecolor',[1 1 1],'linewidth',0.75,'edgecolor','b')
pause(0.01)
drawnow
