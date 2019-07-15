% getNoisyFas.m
%
% author: julia dohner
% july 12, 2019

% brief: adds noise to air-sea flux (fas) record calculated from Joos pulse
% response model 
% recreating Anderegg et al. (2015) representation of error in air-sea flux


function [noisyFas] = getNoisyFas(fas)

% create blank vector
% +1 so have starter value for the AR step (to trace back 1 before start)
noiseTimeseries = zeros(length(fas(:,1)+2),1);

% adding noise in gaussian distribution
mu = 0;
sigma = 1; 

% from Ballantyne:
% y(t) = lag1*y(t-1) + eps(t) where eps(t) is Gaussian rand noise
for i = 1:length(fas(:,1)) % in each row
    noiseTimeseries(i+1) = 0.9*noiseTimeseries(i) + normrnd(mu,sigma);
end

% normalize so that 1-sigma standard deviation in noiseTimeseries (y(t)) is 0.5
s2 = 0.05;
s1 = std(noiseTimeseries);
c = s2/s1;
%noiseTimeseries = noiseTimeseries.*(s2/s1);

noisyFas(:,1) = fas(:,1);
noisyFas(:,2) = fas(:,2)+(c*noiseTimeseries(2:end));


end
