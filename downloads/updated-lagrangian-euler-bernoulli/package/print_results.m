%*** print_results ***
% results: nodal displacements and efforts:
ist=input('Number of the load step (default nstep): ');
if length(ist)==0; ist=nstep; end
disp(' ')
disp(['Step number: ',num2str(ist)]);
S=St(:,ist+1);

Nc=stress(:,1,ist+1); 
Nc=(Nc(1:2:2*nel)+Nc(2:2:2*nel))/2;
Mc=stress(:,2,ist+1); 
Mc=(Mc(1:2:2*nel)+Mc(2:2:2*nel))/2;

disp(' ')
disp('Node   u            v            phi')
disp(num2str([[1:nnd]' S(1:3:neq) S(2:3:neq) S(3:3:neq)],'%-5.0f %-12.5g %-12.5g %-12.5g\n'));

disp(' ')
disp('Elem         N             M')
disp(num2str([[1:nel]' Nc  Mc],'%-12.5g %-12.5g %-12.5g\n'));
