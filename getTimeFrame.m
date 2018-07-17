% getTimeFrameVec.m
%
% july 9, 2018
% julia dohner
%
% create vectors for different fitting time frames

function [timeFrameVec] = getTimeFrame(timeFrame,year);

timeFrameVec = [year,ones(length(year),0)];

if strcmp(timeFrame,'a')
    i = find(year == 1900);
    j = find(year == 2010.5);
    timeFrameVec(i:j,2) = 1;
    
elseif strcmp(timeFrame,'b')
    i = find(year == 1900);
    j = find(year == 2005.5);
    timeFrameVec(i:j,2) = 1;
    
elseif strcmp(timeFrame,'c')
    i = find(year == 1950);
    j = find(year == 1980);
    timeFrameVec(i:j,2) = 1;
    
elseif strcmp(timeFrame,'d')
    i = find(year == 1900);
    j = find(year == 2000.5);
    timeFrameVec(i:j,2) = 1;
end
