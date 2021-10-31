% MEGN200: Monte Carlo Project
% Section - ?
% Brandon Ching
% 10/23/2021 and Version 1

clc; clear; close all;

D1 = 0.203; %Diameter of hole 1 (inches)
D2 = D1; %Diameter of hole 2 (inches)
Nom_Bolt = 0.190; %Nominal diameter of bolt (inches)
Dev_Bolt = 0.006; %Standard deviation of bolt (inches)
Nom_L1 = 1.724/2; %Nominal spacing of hole 1 from centerline (inches)
Dev_L1 = [0:0.0005:0.055/2]; %Standard deviation of hole 1 from centerline (inches)
Nom_L1(1:length(Dev_L1)) = 1.724/2; %Nominal spacing of hole 1 from centerline (inches)
Nom_L2 = Nom_L1; %Nominal spacing of hole 2 from centerline (inches)
Dev_L2 = Dev_L1; %Standard deviation of hole 2 from centerline (inches)
Num_Sims= 1e7; %Number of simulations you are running for this assembly


Bolt = mvnrnd(Nom_Bolt,Dev_Bolt.^2,Num_Sims)';
%Bolt = normrnd(Nom_Bolt,Dev_Bolt,1,Num_Sims);
%Bolt = [Bolt; normrnd(0.1,Dev_Bolt,1,Num_Sims)];
L1 = mvnrnd(Nom_L1,Dev_L1.^2,Num_Sims)';
L2 = mvnrnd(Nom_L2,Dev_L2.^2,Num_Sims)';

%Calculate A1,B1,A2,B2 for this simulation loop (see previous slides for equations)
A1 = L1 + D1/2;
B1 = L1 - D1/2;
A2 = L2 + D2/2;
B2 = L2 - D2/2;

%If the failure criteria is met then increment the ‘Failed’ variable by +1. (|| is ‘or’)
Failed = ((A2-B1)<Bolt) | ((A1-B2)<Bolt);
Percent_Failed = (cumsum(Failed,2)./(1:Num_Sims)).*100;
percent_change=diff(Percent_Failed,1,2)./Percent_Failed(:,1:end-1).*100;

disp(Percent_Failed(end))
%%
plot(Dev_L1.*2, Percent_Failed(:,end), 'bo-')
title('Standard Deviation vs Precent Failed')
xlabel('Standard Deviation')
ylabel('Precent Failed (%)')
