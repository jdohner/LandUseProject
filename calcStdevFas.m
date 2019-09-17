% calcStdevFas.m
%
% sept 13, 2019
%
% author: julia dohner
% 
% script to calculate standard deviation across ensemble
% to normalize the error timeseries for getNoisyFas

%% new method (sept 16 2019)

for i = 1:1000
end




%% old method 

Tconst = 18.2; % surface temperature, deg C, from Joos 1996
start_year = 1850;
start_yearOcean = 1800;
end_year = 2015.5; 
varSST_i = 1;
vary = 'N';


for i = 1:1000
    
    [fas,~] = jooshildascale_wNoise(start_year,start_yearOcean,end_year,varSST_i,Tconst,vary);
    fasArray(:,i) = fas(:,2);
end

save('1000_fasrecords','fasArray');

for i = 1:1000
    stdevFasArray = stdev(fasArray(i,:));
end

stdevFas = mean(stdevFasArray);





