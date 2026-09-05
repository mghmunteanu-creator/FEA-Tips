% *** geomK ***
% Sign convention: N<0 in compression; Kg is assembled from -N.
Kg=zeros(neq);
for ie=1:nel
    L=Lt(ie);
    n1=elem(ie,1);
    n2=elem(ie,2);
    ipos=[3*n1-2 3*n1-1 3*n1 3*n2-2 3*n2-1 3*n2];
    R=Rt(:,:,ie);
    c=[ 0 
       -1
        0
        0
        1
        0]/L; 
    kelg=-N(ie)*(c*c')*L;
    Kg(ipos,ipos)=Kg(ipos,ipos)+R'*kelg*R;
end
% Constraints
loc=3*(cond(:,1)-1)+cond(:,2);
ip=setdiff(1:neq,loc);

N_cr=20.187*ei/Lb^2

[ev d]=eig(K(ip,ip),Kg(ip,ip));
dd=diag(d);
is=find(isfinite(dd) & dd>0);
[ds jj]=sort(dd(is));
is=is(jj);
figure(7), clf, hold on, grid on, axis('equal')
mx=(max(x)-min(x)+max(y)-min(y))/10;
ieigv=0;
for i=1:min(8,length(is))
    ieigv=ieigv+1;
    str = ['Eigenvalue number ',num2str(ieigv),': ',num2str(dd(is(i)))];
    disp(str)
    disp(' ')
    vc=ev(:,is(i));
    vc(ip)=vc/max(abs(vc))*mx;
    vc=[vc;zeros(neq,1)];
    xc=vc(1:3:neq);
    yc=vc(2:3:neq);
    plot(x+xc,y+yc)
    pause
end
