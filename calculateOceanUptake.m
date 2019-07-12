% calculateOceanUptake.m
%
% july 12, 2019
%
% author: julia dohner
%
% brief: script to calculate ocean uptake between set years

function [uptakePPM, uptakePgC] = calculateOceanUptake(startYear,endYear,fas)

Aoc = 3.62E14; % surface area of ocean, m^2, from Joos 1996
d = 2.31; % ppm to PgC conversion factor

m = find(fas(:,1) >= startYear,1);
n = find(fas(:,1) >= endYear,1);

uptakePPM =  Aoc*sum(fas(m:n,2))/12;
uptakePgC = uptakePPM*d;

end

