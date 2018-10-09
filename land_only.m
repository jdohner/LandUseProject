% land_only.m
%
% julia dohner
% october 8, 2018
%
% code for only the land component extracted, fit to T record with set Q10
% to investigate the role of the changing box size term

% suggested inputs:
% Q1 = 0.8890
% epsilon = 0.1999

clear all

Q1 = 2.2256;
epsilon = 0.3349;
Q2 = 1;
ts = 12;
dt = 1/ts;
start_year = 1850;
end_year = 2015.5;
year = (start_year:dt:end_year)';
load dpCO2a_obs.mat dpCO2a_obs;
gamma = 0; % no N fertilization
photResp_i = 1; % looping temp-dep photosynthesis or respiration
timeConst_i = 1; % looping scaling time constant in fast land box
numCases = 4; 
rowLabels = {'Baseline','Epsilon = 0','\DeltaC_i = 0','Epsilon & \DeltaC_i = 0'};
Tdata_i = 1; % 1 is match LR, 2 if want more legit record
[temp_anom] = tempRecord3(Tdata_i,start_year,end_year,dt);
vary = 'K';
landFluxArray = cell(numCases,4);
landFluxArray(1,:) = {'Run Version','C1dt','C2dt','delCdt'};


for j = 1:numCases
    
zeroBio_i = j; % looping zeroing out terms in biobox

[C1dt,C2dt,delCdt,delC1,delC2] = bioboxtwo(epsilon,Q1,Q2,ts,year,...
    dpCO2a_obs,temp_anom,gamma,photResp_i,timeConst_i,zeroBio_i);

delCdt(:,2) = -delCdt(:,2); % change sign of land uptake

% leaving out the calculation of CO2atm, so won't include error

C1dt = [C1dt(:,1), C1dt(:,2)*-1];
C2dt = [C2dt(:,1), C2dt(:,2)*-1];

[landFluxArray] = fillLandFluxArray(landFluxArray,j,C1dt,C2dt,delCdt);

end

plotBioboxes(landFluxArray,numCases,vary);

% looking at difference between with and without params

% fast box baseline - fast box eps = 0
% with - without
epsDiff_wCi = landFluxArray{2,2} - landFluxArray{3,2};
epsDiff_woCi = landFluxArray{4,2} - landFluxArray{5,2};
ciDiff_wEps = landFluxArray{2,2} - landFluxArray{4,2};
ciDiff_woEps = landFluxArray{3,2} - landFluxArray{5,2};

figure('Name','Diffs with and without params')

subplot(4,1,1)
plot(year,epsDiff_wCi(:,2))
title('With - without epsilon (\DeltaC_i included)','FontSize', 18)
set(gca,'Ylim',[-3 3]) 
%xlabel('year','FontSize', 18)
ylabel('PgC / year','FontSize', 18)
grid
subplot(4,1,2)
plot(year,epsDiff_woCi(:,2))
title('With - without epsilon (\DeltaC_i = 0)','FontSize', 18)
set(gca,'Ylim',[-3 3]) 
%xlabel('year','FontSize', 18)
ylabel('PgC / year','FontSize', 18)
grid
subplot(4,1,3)
plot(year,ciDiff_wEps(:,2))
title('With - without \DeltaC_i (epsilon included)','FontSize', 18)
set(gca,'Ylim',[-3 3]) 
%xlabel('year','FontSize', 18)
ylabel('PgC / year','FontSize', 18)
grid
subplot(4,1,4)
plot(year,ciDiff_woEps(:,2))
title('With - without \DeltaC_i (epsilon = 0)','FontSize', 18)
set(gca,'Ylim',[-3 3]) 
%xlabel('year','FontSize', 18)
ylabel('PgC / year','FontSize', 18)
grid



