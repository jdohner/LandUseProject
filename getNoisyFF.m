% getFF.m
%
% author: julia dohner
% july 10, 2019

% brief: generates FF record with added noise 
% recreating Anderegg et al. (2015) equation for error in FF


function [noisyFF] = getNoisyFF(ff)

%% Ballantyne et al. (2012) method

% create blank vector
% +1 so have starter value for the AR step (to trace back 1 before start)
noiseTimeseries = zeros(length(ff(:,1)+2),1);

% adding noise in gaussian distribution
mu = 0;
sigma = 1; 

% from Ballantyne:
% y(t) = lag1*y(t-1) + eps(t) where eps(t) is Gaussian rand noise
for i = 1:length(ff(:,1)) % in each row
    noiseTimeseries(i+1) = 0.95*noiseTimeseries(i) + normrnd(mu,sigma);
end

% normalize so that standard deviation in noiseTimeseries (y(t)) is 0.5
s2 = 0.05;
s1 = std(noiseTimeseries);
noiseTimeseries = noiseTimeseries.*(s2/s1);

noisyFF(:,1) = ff(:,1);
noisyFF(:,2) = ff(:,2).*(1+c*noiseTimeseries(t))


end
