% getNoisyFF.m
%
% author: julia dohner
% july 10, 2019

% brief: generates FF record with added noise 
% recreating Anderegg et al. (2015), Ballantyne et al. (2012) equation for 
% error in FF


function [noisyFF] = getNoisyFF(ff)

year = ff(:,1);

AR1 = 0.95;
AR2 = 0;

[noiseTimeseries] = generateEpsNoise(AR1,AR2,year);

% normalize so that 2*standard deviation in noiseTimeseries (y(t)) is 5%
s2 = 0.05/2;
s1 = 0.0667;
c = s2/s1;

noisyFF(:,1) = ff(:,1);
noisyFF(:,2) = ff(:,2).*(1+c*noiseTimeseries); % remove 0 at start of noise

end
