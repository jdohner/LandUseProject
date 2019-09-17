% generateEpsNoise.m
%
% sept 16, 2019
% 
% author: julia dohner
% brief: generates noise timeseries epsilon 

function [noiseTimeseries] = generateEpsNoise(AR1,AR2,year)

mu = 0;
sigma = 1; 

gaussNoise = zeros(length(year),1);

for i = 1:length(year) % in each row
    gaussNoise(i) = normrnd(mu,sigma);
end

gaussNoiseSm = smoothdata(gaussNoise,'movmean',12);

noiseTimeseries = zeros(length(year+12),1);

% create blank vector
% +24 so have starter value for the AR step 
% (to trace back 24mos before start)
noiseTimeseries = zeros(length(year)+24,1);

epsWeight = 1-AR1-AR2;

for i = 1:length(year) % in each row
    noiseTimeseries(i+24) = epsWeight*gaussNoiseSm(i)...
        +AR1*noiseTimeseries(i+12)... % lag 1 term (AR1 coeff)
        +AR2*noiseTimeseries(i); % lag 2 term (AR2 coeff)
end

% remove 0's at start
noiseTimeseries = noiseTimeseries(25:end);

end