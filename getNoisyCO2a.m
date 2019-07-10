% getNoisyCO2a.m
%
% author: julia dohner
% july 9, 2019

% brief: generates CO2a_obs record with added noise (stdv = 0.24 ppm)
% recreating Ballantyne et al. (2015) equation for error in CO2atm


function [noisyCO2a_obs] = getNoisyCO2a(CO2a_obs)

% create blank vector
% +1 so have starter value for the AR step (to trace back 1 before start)
noiseTimeseries = zeros(length(CO2a_obs(:,1)+2),1); 

% adding noise in gaussian distribution
mu = 0;
sigma = 1; 

% Q/note - want to add AR noice of values between 0 and 1
% right now adding noise between 0 and 1, then adding AR term
% how to get the sum to be between 0 and 1 if don't know AR term?
for i = 1:length(CO2a_obs(:,1)) % in each row
    noiseTimeseries(i+2) = normrnd(mu,sigma)...
        + 0.244*noiseTimeseries(i+1)... % lag 1 term (AR1 coeff)
        + 0.086*noiseTimeseries(i); % lag 2 term (AR2 coeff)
end

% remove first two values (zeros)
noiseTimeseries = noiseTimeseries(3:end,:);


% normalize to standard deviation = 0.24 ppm
s2 = 0.244;
% do I want the data centered on a specific mean?

s1 = std(noiseTimeseries);
noiseTimeseries = noiseTimeseries.*(s2/s1);

% for j = 1:length(noiseTimeseries)
%     s1 = std(noiseTimeseries(:,j));
%     noiseTimeseries(:,j) = noiseTimeseries(:,j)*(s2/s1);
% end

% add error timeseries onto CO2a timeseries

%noisyCO2a_obs = zeros(length(noiseTimeseries),2);

noisyCO2a_obs(:,1) = CO2a_obs(:,1);
noisyCO2a_obs(:,2) = CO2a_obs(:,2)+ noiseTimeseries;

% loop through columns to add noise to CO2a record, store in noisyCO2a
% vector
% for i = 1:length(noisyCO2a_obs(1,:))
%     noisyCO2a_obs(:,i) = CO2a_obs(:,2)+ noiseTimeseries;
% end


end
