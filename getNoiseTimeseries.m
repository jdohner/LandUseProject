% getNoiseTimeseries.m
%
% author: julia dohner
% july 7, 2019

% brief: recreating Ballantyne et al. (2015) equation for error in CO2atm

% note - maybe put this in getObservedCO2_2 so that the dtdelpCO2a_obs and
% dpCO2a_obs are both generated there with the associated error?

%function [noiseTimeseries] = getNoiseTimeseries(nTimeseries, mu, sigma);

%% acquire CO2 record

addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/LandUseProject/necessary_data'));

ts = 12; % timesteps per year
start_year = 1850;
end_year = 2015.5; 
year = (start_year:(1/ts):end_year)';

[dtdelpCO2a_obs,dpCO2a_obs,~,~,CO2a_obs] = getObservedCO2_2(ts,start_year,end_year);

%% generate error timeseries

nTimeseries = 100; % number of error timeseries

% create blank vector
% +1 so have starter value for the AR step (to trace back 1 before start)
noiseTimeseries = zeros(length(dpCO2a_obs(:,1)+1),nTimeseries); 

    %%%%%

% MATLAB function method
%
% AR1coeff = 0.244;
% stdevOverlap = 0.24;
% varianceOverlap = stdevOverlap^2;
% 
% model = arima('constant',0,'AR',AR1coeff,'Distribution','Gaussian',...
%     'Variance',0.0576);

    %%%%%

% homemade method

mu = 0.5;
sigma = 0.5/3; % want numbers to fall between 0 and 1 (99.7% of data w/in 3 standard deviations)

for j = 1:nTimeseries % in each column
    for i = 1:length(dpCO2a_obs(:,1)) % in each row %note: change dpco2a_obs to co2a_obs in all instances
        noiseTimeseries(i+1,j) = normrnd(mu,sigma)...
            + 0.244*noiseTimeseries(i,j);
    end
end

% remove first value from every column
noiseTimeseries = noiseTimeseries(2:end,:);

% check on statistics
%m = ar(noiseTimeseries(1,:),1);

% normalize to standard deviation = 0.24 ppm

s2 = 0.244;
% do I want the data centered on a specific mean?

for j = 1:length(noiseTimeseries(1,:));
    s1 = std(noiseTimeseries(:,j));
    noiseTimeseries(:,j) = noiseTimeseries(:,j)*(s2/s1);
end

% add error timeseries onto CO2a timeseries

noisyCO2a = zeros(size(noiseTimeseries));

% loop through columns to add noise to CO2a record, store in noisyCO2a
% vector
for i = 1:length(noisyCO2a(1,:))
    noisyCO2a(:,i) = CO2a_obs(:,2)+ noiseTimeseries(:,i);
end

% now have nTimeseries of CO2a_obs with noise added!
% time to feed it into forward driver...

    
    






% atmospheric growth calculated as change in mean Dec&Jan CO2_a values
%
% error in mean Dec/Jan = AR1 error + random error in current year
% eps_MDJ_(t) = 0.244*eps_MDJ_(t-1) + eps(t)


