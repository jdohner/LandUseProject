% getNoisySourceSink.m
%
% author: julia dohner
% 
% october 9, 2019

% generates vector of nEnsemble noisy source sink timeseries

function [noisyCO2a,noisyFas,noisyFF] = getNoisySourceSink(year_ocean,...
    numCases,year,ts,start_year,start_yearOcean,end_year,vary,LU_i,BLUE_i,...
    varSST_i,Tconst);


% generate noisy CO2 vector
noiseForCO2 = zeros(length(year_ocean),numCases);
AR1_CO2 = 0.244;
AR2_CO2 = 0.086;
for i1 = 1:numCases
    [noiseForCO2(:,i1)] = generateEpsNoise(AR1_CO2,AR2_CO2,year_ocean);
end

% generate noisy fas vector
noiseForFas = zeroes(length(year),numCases);
AR1_fas = 0.9;
AR2_fas = 0;
for i2 = 1:numCases
    [noiseForFas(:,i2)] = generateEpsNoise(AR1_fas,AR2_fas,year);
end

% generate noisy ff vector
noiseForFF = zeroes(length(year),numCases);
AR1_FF = 0.95;
AR2_FF = 0;
for i3 = 1:numCases
    [noiseForFF(:,i3)] = generateEpsNoise(AR1_FF,AR2_FF,year);
end

[dtdelpCO2a_obs,dpCO2a_obs,~,~,CO2a_obs,CO2a_obs_archive] = ...
getObservedCO2_2wNoise_2(ts,start_year,start_yearOcean,end_year,vary,numCases,noiseForCO2);



% calculate and store source/sink vectors
[ff, LU] = getSourceSink6_wNoise(LU_i,BLUE_i,vary,numCases,noiseForFF); % for updated FF & LU
[fas,sstAnom] = jooshildascale_wNoise(start_year,start_yearOcean,end_year,...
    varSST_i,Tconst,vary,numCases,noiseForFas);

save('ff','ff')

