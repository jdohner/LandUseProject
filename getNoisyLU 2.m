% getNoisyLU.m
%
% author: julia dohner
% july 15, 2019

% brief: generates LU record with added noise 
% recreating Ballantyne et al. (2015), Ballantyne et al. (2012) equation for 
% error in LU


function [noisyLU] = getNoisyLU(LU)

year = LU(:,1);

AR1 = 0.05;
AR2 = 0;

[noiseTimeseries] = generateEpsNoise(AR1,AR2,year);


% % Ballantyne et al. (2012) method
% 
% % create blank vector
% % +1 so have starter value for the AR step (to trace back 1 before start)
% %noiseTimeseries = zeros(length(LU(:,1)+2),1);
% noiseTimeseries = zeros(length(LU(:,1)+12),1);
% 
% % creating noise in gaussian distribution
% mu = 0;
% sigma = 1; 
% 
% % from Ballantyne (2012, 2015):
% % y(t) = lag1*y(t-1) + eps(t) where eps(t) is Gaussian rand noise
% for i = 1:length(LU(:,1)) % in each row
%     noiseTimeseries(i+12) = 0.05*noiseTimeseries(i) + normrnd(mu,sigma);
% end
% 
% % remove 0 values at beginning
% noiseTimeseries = noiseTimeseries(13:end);
% 
% % apply 12-month moving filter to noise
% noiseTimeseries = smoothdata(noiseTimeseries,'movmean',12);

% normalize so that 2*standard deviation in noiseTimeseries (y(t)) is 50%
s2 = 0.5/2;
s1 = std(noiseTimeseries);
c = s2/s1;
%noiseTimeseries = noiseTimeseries.*(s2/s1);

noisyLU(:,1) = LU(:,1);
noisyLU(:,2) = LU(:,2).*(1+c*noiseTimeseries); % remove 0 at start of noise


end
