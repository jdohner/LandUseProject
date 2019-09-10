% getNoisyCO2a.m
%
% author: julia dohner
% july 9, 2019

% brief: generates CO2a_obs record with added noise (stdv = 0.24 ppm)
% recreating Ballantyne et al. (2015) equation for error in CO2atm


function [noisyCO2a_obs] = getNoisyCO2a(CO2a_obs)

% create blank vector
% +3 so have starter value for the AR step (to trace back 3 before start)
noiseTimeseries = zeros(length(CO2a_obs(:,1)+3),1); 

% adding noise in gaussian distribution
mu = 0; sigma = 1; 

for i = 1:length(CO2a_obs(:,1)) % in each row
    noiseTimeseries(i+3) = normrnd(mu,sigma)...
        -0.413*noiseTimeseries(i+2)... % lag 1 term (AR1 coeff)
        -0.166*noiseTimeseries(i+1)... % lag 2 term (AR2 coeff)
        -0.085*noiseTimeseries(i); % lag 3 term (AR3 coeff)
end

% remove first three values (zeros)
noiseTimeseries = noiseTimeseries(4:end,:);

% normalize to standard deviation = 0.38 PgC/yr
d = 1/2.124; % PgC to ppm conversion factor
s2 = 0.38*d;

s1 = std(noiseTimeseries);
noiseTimeseries = noiseTimeseries.*(s2/s1);

noisyCO2a_obs(:,1) = CO2a_obs(:,1);
noisyCO2a_obs(:,2) = CO2a_obs(:,2)+ noiseTimeseries;

end
