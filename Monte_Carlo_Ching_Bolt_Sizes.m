% MEGN200: Monte Carlo Project
% Section - ?
% Brandon Ching
% 10/23/2021 and Version 1

clc; clear; close all;

D1 = 0.203; %Diameter of hole 1 (inches)
D2 = D1; %Diameter of hole 2 (inches)
Nom_Bolt = 0.190; %Nominal diameter of bolt (inches)
bolt_size = [0.01:0.01:D1]';
Dev_Bolt(1:length(bolt_size)) = 0.006; %Standard deviation of bolt (inches)
Nom_L1 = 1.724/2; %Nominal spacing of hole 1 from centerline (inches)
Dev_L1 = 0.055/2; %Standard deviation of hole 1 from centerline (inches)
Nom_L2 = 1.721/2; %Nominal spacing of hole 2 from centerline (inches)
Dev_L2 = 0; %Standard deviation of hole 2 from centerline (inches)
Num_Sims= 1e7; %Number of simulations you are running for this assembly


Bolt = mvnrnd(bolt_size,Dev_Bolt.^2,Num_Sims)';
%Bolt = normrnd(Nom_Bolt,Dev_Bolt,1,Num_Sims);
%Bolt = [Bolt; normrnd(0.1,Dev_Bolt,1,Num_Sims)];
L1 = normrnd(Nom_L1,Dev_L1,1,Num_Sims);
L2 = normrnd(Nom_L2,Dev_L2,1,Num_Sims);

%Calculate A1,B1,A2,B2 for this simulation loop (see previous slides for equations)
A1 = L1 + D1/2;
B1 = L1 - D1/2;
A2 = L2 + D2/2;
B2 = L2 - D2/2;

%If the failure criteria is met then increment the ‘Failed’ variable by +1. (|| is ‘or’)
Failed = ((A2-B1)<Bolt) | ((A1-B2)<Bolt);
Percent_Failed = (cumsum(Failed,2)./(1:Num_Sims)).*100;
Variation = [zeros(length(bolt_size),1), diff(Percent_Failed,1,2)];
percent_change=diff(Percent_Failed,1,2)./Percent_Failed(:,1:end-1).*100;

%test = abs(percent_change) >= 0.01;
%test1 = percent_change(test);
%disp(length(test1))

disp(Percent_Failed(19,end))
%%
tiledlayout(2,2)

% Precentage
nexttile
plot(1:Num_Sims, Percent_Failed)
title('Precentage of Failed Assemblies')
xlabel('Assembly Number')
ylabel('Precent Failed (%)')
xlim([Num_Sims/10 Num_Sims])
ylim auto
legend('0.01','0.02','0.03','0.04','0.05','0.06','0.07','0.08','0.09','0.10','0.11','0.12','0.13','0.14','0.15','0.16','0.17','0.18','0.19', '0.20')

% Variation 
nexttile
plot(1:Num_Sims, Variation)
title('Variation in Failed Precentage')
xlabel('Assembly Number')
ylabel('Variation')
xlim([Num_Sims/10 Num_Sims])
ylim auto
legend('0.01','0.02','0.03','0.04','0.05','0.06','0.07','0.08','0.09','0.10','0.11','0.12','0.13','0.14','0.15','0.16','0.17','0.18','0.19', '0.20')

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

%
nexttile
plot(bolt_size, Percent_Failed(:,end), 'bo-')
title('Bolt Size vs Precent Failed')
xlabel('Bolt Size')
ylabel('Precent Failed (%)')
