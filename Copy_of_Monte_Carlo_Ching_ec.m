% MEGN200: Monte Carlo Project
% Section - ?
% Brandon Ching
% 10/23/2021 and Version 1

clc; clear; close all;

D1 = 0.203; %Diameter of hole 1 (inches)
D2 = D1; %Diameter of hole 2 (inches)
Nom_Bolt= 0.190; %Nominal diameter of bolt (inches)
Dev_Bolt= 0.006; %Standard deviation of bolt (inches)
Nom_L1 = 1.724/2; %Nominal spacing of hole 1 from centerline (inches)
Dev_L1 = 0.055/2; %Standard deviation of hole 1 from centerline (inches)
Nom_L2 = Nom_L1; %Nominal spacing of hole 2 from centerline (inches)
Dev_L2 = Dev_L1; %Standard deviation of hole 2 from centerline (inches)
Num_Sims= 1e7; %Number of simulations you are running for this assembly

Bolt = normrnd(Nom_Bolt,Dev_Bolt,1,Num_Sims);
L1 = normrnd(Nom_L1,Dev_L1,1,Num_Sims);
L2 = normrnd(Nom_L2,Dev_L2,1,Num_Sims);

%Calculate A1,B1,A2,B2 for this simulation loop (see previous slides for equations)
A1 = L1 + D1/2;
B1 = L1 - D1/2;
A2 = L2 + D2/2;
B2 = L2 - D2/2;

%If the failure criteria is met then increment the ‘Failed’ variable by +1. (|| is ‘or’)
Failed = ((A2-B1)<Bolt) + ((A1-B2)<Bolt);
Precent_Failed = (cumsum(Failed)./(1:Num_Sims)).*100;
Variation = [0 diff(Precent_Failed)];

%%
disp(Precent_Failed(end))
tiledlayout(1,3)

% Precentage
nexttile
plot(100000:Num_Sims, Precent_Failed(100000:Num_Sims))
title('Precentage of Failed Assemblies')
xlabel('Assembly Number')
ylabel('Precent (%)')

% Variation 
nexttile
plot(100000:Num_Sims, Variation(100000:Num_Sims))
title('Variation in Failed Precentage')
xlabel('Assembly Number')
ylabel('Precent Change')

% Bolt Space
Clearance = (sort(A2-B1-Nom_Bolt) + sort(A1-B2-Nom_Bolt))/2;
Clearance_Fail = Clearance<0;
Clearance_Pass = Clearance>=0;
nexttile
plot(1:sum(Clearance_Fail), Clearance(Clearance_Fail), 'r', 'LineWidth', 2); hold
plot(sum(Clearance_Fail)+1:Num_Sims, Clearance(Clearance_Pass), 'g', 'LineWidth', 2); hold off
title('Space Between Bolt and Hole')
xlabel('Assembly Number')
ylabel('Hole-Bolt Clearance(in)')
legend('Fail', 'Pass')