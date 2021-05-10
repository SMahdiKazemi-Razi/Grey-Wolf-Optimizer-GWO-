function [z,sol]=MyCost(p,model)

global NFE;

if isempty(NFE)
    NFE=0;
end

NFE=NFE+1;

a0=model.a0;
a1=model.a1;
a2=model.a2;

PL=model.PL;

%c=zeros(size(p));
%for i=1:N
% c(i)=a0(i)+a1(i)*p(i)+a2(i)*p(i)^2;
%end
% Vectorized version of the previous loop

c=a0+a1.*p+a2.*p.^2;

v=abs(sum(p)/PL-1);

beta=2;
z=sum(c)*(1+beta*v);

sol.p=p;
sol.pTotal=sum(p);
sol.c=c;
sol.cTotal=sum(c);
sol.v=v;
sol.z=z;

end
