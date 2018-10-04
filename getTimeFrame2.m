% getTimeFrameVec.m
%
% july 9, 2018
% julia dohner
%
% create vectors for different fitting time frames
% version for S^3 presentation (more sensible fitting T frames)

function [timeFrameVec] = getTimeFrame2(opt_i,year);

timeFrameVec = [year,ones(length(year),0)];


if opt_i == 1
    i = find(year == 1900);
    j = find(year == 2010.5);
    timeFrameVec(i:j,2) = 1;
    
elseif opt_i == 2
    i = find(year == 1900);
    j = find(year == 2005.5);
    timeFrameVec(i:j,2) = 1;
    
elseif opt_i == 3
    i = find(year == 1959);
    j = find(year == 2010.5);
    timeFrameVec(i:j,2) = 1;
    
elseif opt_i == 4
    i = find(year == 1900);
    j = find(year == 2000.5);
    timeFrameVec(i:j,2) = 1;
    
elseif opt_i == 5
    i = find(year == 1959);
    j = find(year == 1990);
    timeFrameVec(i:j,2) = 1;
    
elseif opt_i == 6
    i = find(year == 1959);
    j = find(year == 2000);
    timeFrameVec(i:j,2) = 1;
    
elseif opt_i == 7
    i = find(year == 1959);
    j = find(year == 2010);
    timeFrameVec(i:j,2) = 1;    
    
end
