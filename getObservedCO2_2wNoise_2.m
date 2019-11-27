% getObservedCO2.m - version 2 for v3 params match
%
% Author: Julia Dohner, adapted from Lauren Rafelski
% April 17, 2018
% 
% Outputs the observed annual increase in atmospheric CO2 (dtdelpCO2a_obs),
% the observed increase each year from the preindustrial CO2 value
% (dpCO2a_obs) and the observed CO2 record (CO2a_obs). The data is from a
% merged record of the Mauna Loa CO2 record, the South Pole observatory
% record, and ice core record from Law Dome. See README.txt for more
% detailed description.
        
function [dtdelpCO2a_obs,dpCO2a_obs,year,dt,CO2a_obs,CO2a_obs_archive] = ...
    getObservedCO2_2wNoise_2(ts,start_year,start_yearOcean,end_year,vary,numCases,noiseForCO2)

dt = 1/ts;

%% load and combine CO2 records

load dataMlospo_meure2011.mat % loads mlospo_meure data vector

% processing data for CO2 up to 2011
% loads in mlospo_meure (4427x2), 1640-Feb 2010, monthly
meure_years = mlospo_meure(:,1);
mlostart = mlospo_meure(1,1);
mloend = mlospo_meure(end,1);
meure_CO2 = mlospo_meure(:,2);

% create new time array
meureInterp_years = mlostart:1/ts:mloend;

% spline interpolation
meureInterp_CO2 = interp1(meure_years,meure_CO2,meureInterp_years,'spline');

MLOSPOiceinterp(:,1) = meureInterp_years; % ends Feb 2010
MLOSPOiceinterp(:,2) = meureInterp_CO2;

%%%%%%%%

% everything past where co2_2011 ends

% starts at year 1, incremented by year
CO2_2016 = csvread('mergedCO2_2016.csv'); % to match LR, use this
%CO2_2016 = csvread('mergedCO2_2018.csv'); % to try LR code going forward
year_2016 = (CO2_2016(1,1):1/ts:CO2_2016(end,1))';
CO2_2016mo(:,1) = year_2016;
CO2_2016mo(:,2) = (interp1(CO2_2016(:,1),CO2_2016(:,2),year_2016)).';

% last point in MLOSPOiceinterp is 2010+(3/24) (i.e. Feb 2010)
% first point in CO2_2016mo is 2010 + 2/12 (i.e. March 2010)
% joinYear is 2010 + 2/12 (i.e. March 2010)
joinYear = MLOSPOiceinterp(end,1)+(1/24); 
i = find(CO2_2016mo(:,1) >= joinYear,1);
year_full(:,1) = [MLOSPOiceinterp(:,1) ; CO2_2016mo(i:end,1)];

% starts at beginning of MLOSPO, ends at end of 2016 record
co2_combine_0(:,1) = year_full; 
co2_combine_0(:,2) = [MLOSPOiceinterp(1:end,2); CO2_2016mo(i:end,2)];
% store as original CO2 record (no noise added)
CO2a_obs_archive = co2_combine_0;

%% add noise to CO2 record

if strcmp(vary,'N')
    [noisyCO2a_obs] = getNoisyCO2a(co2_combine_0);
    % year that comes out above attached to noisyCO2a_obs is the same as 
    % the year in co2_combine_0
    co2_combine = noisyCO2a_obs;
else
    co2_combine = CO2a_obs_archive;
end
    
%% calculate changes in CO2

m = find(co2_combine(:,1) >= start_year,1); % find index for start_year
m1 = find(co2_combine(:,1) >= start_yearOcean,1); % find index for start_year
n = find(co2_combine(:,1) >= end_year,1); % find index for end_year


% calculate dtdelpCO2a (CO2 increment with monthly resolution (ppm/year))
% calculating since 1640
% (ts/2) in bounds accounts for mid-month offset
for j = ((ts/2)+1):(length(co2_combine)-(ts/2))
    dtdelpCO2a(j,1) = co2_combine(j,1);
    dtdelpCO2a(j,2) = co2_combine(j+(ts/2),2) - co2_combine(j-(ts/2),2);
end

% here I'd make dpCO2a be calculated first from the ocean start year, then
% truncate it to start_year

if start_yearOcean < start_year
    % calculate dpCO2a for ocean code
    dpCO2a_obsOcean(:,1) = co2_combine(m1:n,1); 
    dpCO2a_obsOcean(:,2) = co2_combine(m1:n,2)-co2_combine(m1,2);
    
    % for regular dpCO2a, take longer dpCO2a_ocean and truncate
    j = find(dpCO2a_obsOcean(:,1) >= start_year,1); % find index for start_year
    dpCO2a_obs(:,1) = dpCO2a_obsOcean(j:end,1); 
    dpCO2a_obs(:,2) = dpCO2a_obsOcean(j:end,2);

else
    % calculate dpCO2a (change in CO2a since start_year)
    dpCO2a_obs(:,1) = co2_combine(m:n,1); 
    dpCO2a_obs(:,2) = co2_combine(m:n,2)-co2_combine(m,2);
    
    j = find(dpCO2a_obs(:,1) >= start_yearOcean,1); % find index for start_year
     % for ocean dpCO2a, take longer dpCO2a and truncate
    dpCO2a_obsOcean(:,1) = dpCO2a_obs(j:end,1); 
    dpCO2a_obsOcean(:,2) = dpCO2a_obs(j:end,2);
    
end


% truncate other outputs to match start & end years
CO2a_obs = co2_combine(m:n,:); 
dtdelpCO2a_obs = dtdelpCO2a(m:n,:); 

year = dpCO2a_obs(:,1);
yearOcean = dpCO2a_obsOcean(:,1);

save('CO2forOcean','dpCO2a_obsOcean','dt','yearOcean');

end