% calcStdevCO2.m
%
% sept 13, 2019
%
% author: julia dohner
% 
% script to calculate standard deviation of dec-jan average across ensemble
% to normalize the error timeseries for getNoisyCO2

function [noisyCO2a_obs] = getNoisyCO2a(CO2a_obs)

addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/LandUseProject/necessary_data'));
addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/LU_data_big'));

ts = 12;
dt = 1/ts;
start_year = 1850;
start_yearOcean = 1800;
end_year = 2015.5; 
year = (start_year:(1/ts):end_year)';
vary = 'N';

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



co2_combine = CO2a_obs_archive;

m = find(co2_combine(:,1) >= start_year,1); % find index for start_year
m1 = find(co2_combine(:,1) >= start_yearOcean,1); % find index for start_year
n = find(co2_combine(:,1) >= end_year,1); % find index for end_year

% truncate other outputs to match start & end years
CO2a_obs = co2_combine(m:n,:); 



nEnsemble = 1000;


CO2array = zeros(length(year),1000); % rows for years, 1000 ensemble members

for i = 1:1000
    [noisyCO2a_obs] = getNoisyCO2a(CO2a_obs);
    CO2array(:,i) = noisyCO2a_obs(:,2);
end

save('1000_CO2records','CO2array');

for i = 1:1000
    for j = 1:165
        meanDJarray(j,i) = (CO2array(j,i) + CO2array(j+1,i))/2;
    end
end
% every column is one ensemble member
% every row is one date
% take stdev across one row
    
    %meanDJ(i) = (CO2array(1668,i)+CO2array(1669,i))/2;
    meanDJ2(i) = (CO2array(1884,i)+CO2array(1885,i))/2;
    

% only calculate at one point
% element 1668 and element 1669

stdMDJ = std(meanDJ);

for i = 1:165
    stdMDJ(i) = std(meanDJarray(i,:));
end
% looks like there's some variance to stdMDJ
