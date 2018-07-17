% getObservedCO2_3.m
%
% july 16, 2018
% julia dohner
%
% departing from intent to match output from LR original code. using mauna
% loa through full record

% I think dt is output for the other subroutines, but probably don't need if
% they're loading runInfo.mat

function [dtdelpCO2a_obs,dpCO2a_obs,year,dt,CO2a_obs] = ...
    getObservedCO2_3(ts,start_year,end_year)

dt = 1/ts;

% load CO2 record
CO2a0 = csvread('mergedCO2_2016.csv');
year0 = (CO2a0(1,1):dt:CO2a0(end,1))';
CO2a1(:,1) = year0;
CO2a1(:,2) = (interp1(CO2a0(:,1),CO2a0(:,2),year0)).';

% Calculate change in atmospheric concentration (starting when?)
dpCO2a(:,1) = CO2a1(:,1); 
dpCO2a(:,2) = CO2a1(:,2)-CO2a1(1,2);

% Calculate CO2 increment with monthly resolution, in ppm/year
for i = ((ts/2)+1):(length(CO2a1)-(ts/2))
    dtdelpCO2a(i,1) = CO2a1(i,1);
    dtdelpCO2a(i,2) = CO2a1(i+(ts/2),2) - CO2a1(i-(ts/2),2);
end

% shorten records
i1 = find(CO2a1(:,1) >= start_year,1);
j1 = find(CO2a1(:,1) >= end_year,1);
CO2a_obs = CO2a1(i1:j1,:);

i2 = find(dpCO2a(:,1) >= start_year,1);
j2 = find(dpCO2a(:,1) >= end_year,1);
dpCO2a_obs = dpCO2a(i2:j2,:);

i3 = find(dtdelpCO2a(:,1) >= start_year,1);
j3 = find(dtdelpCO2a(:,1) >= end_year);
dtdelpCO2a_obs = dtdelpCO2a(i3:j3,:);

year = CO2a_obs(:,1);

end

% %% old code
% 
% % all this code works if you pass the co2_combine vector from the first
% % steps in the getObservedCO2_2 file and then rename it as CO2a1
% %
% % to make identical to LR code, would need to use MLOSPOmeure record joined
% % to recent Scripps CO2 record. CO2 records will be different.
% 
% dt = 1/ts;
% 
% % load CO2 record
% CO2a0 = csvread('mergedCO2_2016.csv');
% year0 = (CO2a0(1,1):dt:CO2a0(end,1))';
% CO2a1(:,1) = year0;
% CO2a1(:,2) = (interp1(CO2a0(:,1),CO2a0(:,2),year0)).';
% 
% % Calculate CO2 increment in ppm/year (since 1640)
% i2 = find(CO2a1(:,1) >= 1640,1);
% for i = (i2+(ts/2)+1):(length(CO2a1)-(ts/2))
%     dtdelpCO2a(i,1) = CO2a1(i,1);
%     dtdelpCO2a(i,2) = CO2a1(i+(ts/2),2) - CO2a1(i-(ts/2),2);
% end
% 
% % shorten CO2a record before calculating dpCO2a
% i1 = find(CO2a1(:,1) >= start_year,1);
% j1 = find(CO2a1(:,1) >= end_year,1);
% CO2a2 = CO2a1(i1:j1,:);
% 
% % Calculate change in atmospheric concentration (since 1850)
% dpCO2a(:,1) = CO2a2(:,1); 
% dpCO2a(:,2) = CO2a2(:,2)-CO2a2(1,2);
% % starts at zero - why?
% 
% % shorten records
% i1 = find(CO2a1(:,1) >= start_year,1);
% j1 = find(CO2a1(:,1) >= end_year,1);
% CO2a_obs = CO2a1(i1:j1,:);
% 
% i2 = find(dpCO2a(:,1) >= start_year,1);
% j2 = find(dpCO2a(:,1) >= end_year,1);
% dpCO2a_obs = dpCO2a(i2:j2,:);
% 
% i3 = find(dtdelpCO2a(:,1) >= start_year,1);
% j3 = find(dtdelpCO2a(:,1) >= end_year);
% dtdelpCO2a_obs = dtdelpCO2a(i3:j3,:);
% 
% year = CO2a_obs(:,1);
% 
% 
% end
% 
