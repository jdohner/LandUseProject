% getNoisyCO2a.m
%
% author: julia dohner
% july 9, 2019

% brief: generates CO2a_obs record with added noise (stdv = 0.24 ppm)
% recreating Ballantyne et al. (2015) equation for error in CO2atm


function [noisyCO2a_obs] = getNoisyCO2a(CO2a_obs)

year = CO2a_obs(:,1);

AR1 = 0.244;
AR2 = 0.086;

[noiseTimeseries] = generateEpsNoise(AR1,AR2,year);

s2 = 0.24; % normalize to standard deviation = 0.24 ppm
s1 = 0.2009;
c = s2/s1;

noisyCO2a_obs(:,1) = CO2a_obs(:,1);
noisyCO2a_obs(:,2) = CO2a_obs(:,2)+ (c*noiseTimeseries);

end
