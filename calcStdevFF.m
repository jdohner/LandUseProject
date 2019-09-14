% calcStdevFF.m
%
% sept 13, 2019
%
% author: julia dohner
% 
% script to calculate standard deviation across ensemble
% to normalize the error timeseries for getNoisyFF

Tconst = 18.2; % surface temperature, deg C, from Joos 1996
start_year = 1850;
start_yearOcean = 1800;
end_year = 2015.5; 
varSST_i = 1;
vary = 'N';

load inputData.mat

for i = 1:1000
    
    [ff] = getNoisyFF(Boden2016);
    ffArray(:,i) = ff(:,2);
end

save('1000_ffrecords','ffArray');

for i = 1:1000
    stdevFFArray(:,i) = std(ffArray(i,:));
end

stdevFF = mean(stdevFFArray);





