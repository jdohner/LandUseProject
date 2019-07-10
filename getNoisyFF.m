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



c = 0.285; % normalizing factor to normalize the 2 sigma errors to 5%
% if you use 2-sigma, this means that approximately 95% of your
% measurements will fall in that range
% sigma = standard deviation
% want 95% of data to fall within +/- 5% of mean value

% normalize to 2*standard deviation = 5% (?)
% normalize so that error can be 5% (+/- 5% of each value)

% normalize to standard deviation = 0.24 ppm
s2 = 0.244;
% do I want the data centered on a specific mean?

s1 = std(noiseTimeseries);
noiseTimeseries = noiseTimeseries.*(s2/s1);

noisyFF(:,1) = ff(:,1);
noisyFF(:,2) = ff(:,2).*(1+c*noiseTimeseries(t))
% y(t) = 
% c = normalizing factor to normalize the 2sigma errors to 5 or 10%


% %% old code
% 
% % create blank vector
% % +1 so have starter value for the AR step (to trace back 1 before start)
% noiseTimeseries = zeros(length(ff(:,1)+2),1); 
% 
% % adding noise in gaussian distribution
% mu = 0;
% sigma = 1; 
% 
% for i = 1:length(ff(:,1)) % in each row
%     noiseTimeseries(i+1) = normrnd(mu,sigma)...
%         0.05 + 0.95*noiseTimeseries(i); % lag 1 term (AR1 coeff)
% end
% 
% % TODO: ^how to make this reflect 5% potential error? how to introduce 
% % random error?
% 
% % remove first value (zero)
% noiseTimeseries = noiseTimeseries(2:end,:);
% 
% % % normalize to standard deviation = 0.24 ppm
% % s2 = 0.244;
% % 
% % s1 = std(noiseTimeseries);
% % noiseTimeseries = noiseTimeseries.*(s2/s1);
% 
% noisyFF(:,1) = ff(:,1);
% noisyFF(:,2) = ff(:,2)+ noiseTimeseries;


end
