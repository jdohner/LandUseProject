% calcStdevEpsNoise.m
%
% sept 16, 2019
% 
% author: julia dohner
% brief: generates noise timeseries epsilon 


noiseTimeseries1000 = zeros(length(year),1000);
% every column is a timeseries of noise
% each row corresponds to a time point
for i = 1:1000
    noiseTimeseries1000(:,i) = generateEpsNoise(AR1,AR2,year);
end

stdevNoise = zeros(length(year),1);

for i = 1:length(year)
    stdevNoise(i) = std(noiseTimeseries1000(i,:));
end

s1 = std(stdevNoise);
