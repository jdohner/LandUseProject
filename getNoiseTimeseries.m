% getNoiseTimeseries.m
%
% author: julia dohner
% july 7, 2019

% brief: recreating Ballantyne et al. (2015) equation for error in CO2atm

% note - maybe put this in getObservedCO2_2 so that the dtdelpCO2a_obs and
% dpCO2a_obs are both generated there with the associated error?

function [noiseTimeseries] = getNoiseTimeseries(nTimeseries,mu, sigma);

Tconst = 18.2; % surface temperature, deg C, from Joos 1996
ts = 12; % timesteps per year
dt = 1/ts;
start_year = 1850;
end_year = 2015.5; 
year = (start_year:(1/ts):end_year)';
Aoc = 3.62E14; % surface area of ocean, m^2, from Joos 1996
co2_preind = 600/2.12; % around 283 ppm (preindustrial)

nTimeseries = 100;

[dtdelpCO2a_obs,dpCO2a_obs,~,~,CO2a_obs] = getObservedCO2_2(ts,start_year,end_year);

% generate random numbers in Gaussian distribution
% create nTimeseries number timeseries

noiseTimeseries = zeros(length(dpCO2a_obs(:,1)),nTimeseries);
mu = 0.5;
sigma = 0.1; % chose this sigma to get only values between 0 and 1

for j = 1:nTimeseries % in each column
    for i = 1:length(dpCO2a_obs(:,1)) % in each row
        noiseTimeseries(i,j) = normrnd(mu,sigma);
    end
end

% atmospheric growth calculated as change in mean Dec&Jan CO2_a values
%
% error in mean Dec/Jan = AR1 error + random error in current year
% eps_MDJ_(t) = 0.244*eps_MDJ_(t-1) + eps(t)

