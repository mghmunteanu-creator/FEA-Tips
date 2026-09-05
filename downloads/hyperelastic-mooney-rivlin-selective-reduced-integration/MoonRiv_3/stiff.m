%*** stiff ***
% Gauss points
st=[1  -1  -1   1
    1   1  -1  -1]*sqrt(3)/3;
F=zeros(neq,1);
K=zeros(neq);
stiff_distortion
stiff_bulk
% Constraints
loc=2*(cond(:,1)-1)+cond(:,2);
K(loc,:  )=0; K(:  ,loc)=0; F(loc,:  )=0;                    
K(loc,loc)=eye(length(loc)); 
% Concentrated force
loc=2*(forze(:,1)-1)+forze(:,2);
F(loc)=F(loc)-forze(:,3)*istep/nstep;               

