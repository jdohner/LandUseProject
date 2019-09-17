% getNoisyFas.m
%
% author: julia dohner
% july 12, 2019

% brief: adds noise to air-sea flux (fas) record calculated from Joos pulse
% response model 
% recreating Anderegg et al. (2015) representation of error in air-sea flux


function [noisyFas] = getNoisyFas(fas,Aoc)

year = fas(:,1);

AR1 = 0.9;
AR2 = 0;

[noiseTimeseries] = generateEpsNoise(AR1,AR2,year);

d = 1/2.124; % PgC to ppm conversion factor

% normalize to published 1-sigma standard deviation
s2 = (0.5*d/Aoc); % 0.5 PgC/year uncertainty converted to ppm*yr^-1*m^-2
s1 = 0.0658; % mean of stabilized std of 1,000 instances of noise timeseries
c = s2/s1;

noisyFas(:,1) = fas(:,1);
noisyFas(:,2) = fas(:,2)+(c*noiseTimeseries);


end
