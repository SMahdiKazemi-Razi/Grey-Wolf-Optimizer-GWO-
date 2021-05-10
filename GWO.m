clear
clc

%% Problem Definition======================================================
global NFE
NFE=0;

model=CreateModel();
CostFunction=@(p) MyCost(p,model);     %Cost Function

nVar=model.N;                          %No. of Variables
VarSize=[1 nVar];                      %Size of Decision Variables Matrix

% VarMin=-10;                          % Lower Bound of Variables
% VarMax=10;                           % Upper Bound of Variables

VarMin=model.pmin;                     % Lower Bound of Variables
VarMax=model.pmax;                     % Upper Bound of Variables
%% Algorithm Settings======================================================
MaxIt=4000;                       % Maximum Number of Iterations
nPop=20;                          % Population Size (Swarm Size)

% initialize alpha, beta, and delta_pos
Alpha_pos=zeros(1,nVar);
Alpha_score=inf; %change this to -inf for maximization problems

Beta_pos=zeros(1,nVar);
Beta_score=inf; %change this to -inf for maximization problems

Delta_pos=zeros(1,nVar);
Delta_score=inf; %change this to -inf for maximization problems

BestCost=zeros(MaxIt,1);
nfe=zeros(MaxIt,1);

%% Initialization==========================================================
empty_particle.Position=[];
empty_particle.Cost=[];
empty_particle.Sol=[];
% empty_particle.Velocity=[];
% empty_particle.Best.Position=[];
% empty_particle.Best.Cost=[];
% empty_particle.Best.Sol=[];

particle=repmat(empty_particle,nPop,1);
% GlobalBest.Cost=inf;

for i=1:nPop
    % Initialize Position
    particle(i).Position=CreateRandomSolution(model);
end

%% Main Loop===============================================================
l=0;% Loop counter

while l<MaxIt
    for i=1:nPop
        % Apply Position Limits
        particle(i).Position = max(particle(i).Position,VarMin);
        particle(i).Position = min(particle(i).Position,VarMax);
        % Evaluation
        [particle(i).Cost,particle(i).Sol] = CostFunction(particle(i).Position);
        % Update Alpha, Beta, and Delta
        if particle(i).Cost<Alpha_score 
            Alpha_score=particle(i).Cost; % Update alpha
            Alpha_Sol=particle(i).Sol;    %Storing the results
            Alpha_pos=particle(i).Position;
        end
        
        if particle(i).Cost>Alpha_score && particle(i).Cost<Beta_score 
            Beta_score=particle(i).Cost; % Update beta
            Beta_pos=particle(i).Position;
        end
        
        if particle(i).Cost>Alpha_score && particle(i).Cost>Beta_score && particle(i).Cost<Delta_score 
            Delta_score=particle(i).Cost; % Update delta
            Delta_pos=particle(i).Position;
        end
    end
    
    a=2-l*((2)/MaxIt); % a decreases linearly fron 2 to 0
    
    % Update the Position of search agents including omegas
    for i=1:nPop
        for j=1:nVar     
                       
            r1=rand(); % r1 is a random number in [0,1]
            r2=rand(); % r2 is a random number in [0,1]
            
            A1=2*a*r1-a;
            C1=2*r2;
            
            D_alpha=abs(C1*Alpha_pos(j)-particle(i).Position(1,j));
            X1=Alpha_pos(j)-A1*D_alpha;
                       
            r1=rand();
            r2=rand();
            
            A2=2*a*r1-a;
            C2=2*r2;
            
            D_beta=abs(C2*Beta_pos(j)-particle(i).Position(1,j));
            X2=Beta_pos(j)-A2*D_beta;     
            
            r1=rand();
            r2=rand();
            
            A3=2*a*r1-a;
            C3=2*r2;
            
            D_delta=abs(C3*Delta_pos(j)-particle(i).Position(1,j));
            X3=Delta_pos(j)-A3*D_delta;
            
            particle(i).Position(1,j)=(X1+X2+X3)/3;
            
        end
    end
    
    l=l+1;
    BestCost(l)=Alpha_score;
    
    nfe(l)=NFE;
    
    disp(['Iteration' num2str(l) ': NFE =' num2str(nfe(l)) ', Best Cost ='...
    num2str(BestCost(l))]);
    
end

%% Result==================================================================
figure;
plot(nfe,BestCost,'LineWidth',2);
%semilogy(nfe,BestCost,'LineWidth',2);
xlabel('NFE');
ylabel('Best Cost');
