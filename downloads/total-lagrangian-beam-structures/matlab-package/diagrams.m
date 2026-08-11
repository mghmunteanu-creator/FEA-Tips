%*** diagrams ***
dx=x(2:nnd)-x(1:nnd-1); dy=y(2:nnd)-y(1:nnd-1); ds=sqrt(dx.^2+dy.^2);
s=[0; cumsum(ds)];
strs=interp1([1.5:(nnd-0.5)],stress(:,:,ist+1),[1:nnd],'PCHIP','extrap');
figure(7), clf, hold on, grid on
plot(s,strs(:,1),'linewidth',2)
xlabel('s [mm]')
ylabel('N [N]') 

figure(8), clf, hold on, grid on
plot(s,strs(:,3),'linewidth',2)
xlabel('s [mm]')
ylabel('T [N]')

figure(9), clf, hold on, grid on
plot(s,strs(:,2),'linewidth',2)
xlabel('s [mm]')
ylabel('M [Nmm]') 
 
