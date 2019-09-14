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

% add noise for CO2 record, 
for i = 1:length(CO2a_obs(:,1)) % in each row
    noiseTimeseries(i+2) = normrnd(mu,sigma)...
        +0.244*noiseTimeseries(i+1)... % lag 1 term (AR1 coeff)
        +0.086*noiseTimeseries(i); % lag 2 term (AR2 coeff)
end

% remove first two values (zeros)
noiseTimeseries = noiseTimeseries(3:end,:);

% apply 12-month moving filter to noise
noiseTimeseries = smoothdata(noiseTimeseries,'movmean',12);

% calculated mean std of MDJ values across ensemble as 0.4099
% standardize to match 0.24 ppm error
% normalize to standard deviation = 0.24 ppm
s2 = 0.24;
s1 = 0.4099;
%s1 = std(noiseTimeseries);
noiseTimeseries = noiseTimeseries.*(s2/s1);



noisyCO2a_obs(:,1) = CO2a_obs(:,1);
noisyCO2a_obs(:,2) = CO2a_obs(:,2)+ noiseTimeseries;

end
