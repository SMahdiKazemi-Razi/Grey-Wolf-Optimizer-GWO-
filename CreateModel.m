function model=CreateModel()

pmin=[511 804 501 747 514 655 555 705];
pmax=[1516 1924 1765 1611 1981 1792 2174 1965];

a0=[8736 5849 8343 9123 6340 6833 5951 6382];
a1=[8 7 8 6 6 9 6 9];
a2=[-0.1573 -0.1430 -0.2574 -0.1128 -0.1344 -0.2375 -0.1631 -0.1784]*1e-4;

N=numel(pmin);
PL=10000;

model.N=N;
model.pmin=pmin;
model.pmax=pmax;
model.a0=a0;
model.a1=a1;
model.a2=a2;
model.PL=PL;

end
