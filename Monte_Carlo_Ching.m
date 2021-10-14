% MEGN200: Monte Carlo Project
% Section - ?
% Brandon Ching
% 10/13/2021 and Version 1

clc; clear; close all;

D1 = 0.203; %Diameter of hole 1 (inches)
D2 = D1; %Diameter of hole 2 (inches)
Nom_Bolt= 0.190; %Nominal diameter of bolt (inches)
Dev_Bolt= 0.006; %Standard deviation of bolt (inches)
Nom_L1 = 1.724/2; %Nominal spacing of hole 1 from centerline (inches)
Dev_L1 = 0.055/2; %Standard deviation of hole 1 from centerline (inches)
Nom_L2 = Nom_L1; %Nominal spacing of hole 2 from centerline (inches)
Dev_L2 = Dev_L1; %Standard deviation of hole 2 from centerline (inches)
Num_Sims= 1e6; %Number of simulations you are running for this assembly
Failed = 0;


for loop=1:Num_Sims
    Bolt = normrnd(Nom_Bolt,Dev_Bolt);
    L1 = normrnd(Nom_L1,Dev_L1);
    L2 = normrnd(Nom_L2,Dev_L2);
    
    %Calculate A1,B1,A2,B2 for this simulation loop (see previous slides for equations)
    A1 = L1 + D1/2;
    B1 = L1 - D1/2;
    A2 = L2 + D2/2;
    B2 = L2 - D2/2;
    
    %If the failure criteria is met then increment the ‘Failed’ variable by +1. (|| is ‘or’)
    if(A2-B1<Bolt || A1-B2<Bolt)
        Failed = Failed + 1;
    end
end