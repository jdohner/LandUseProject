% getTimeFrameVec.m
%
% july 9, 2018
% julia dohner
%
% create vectors for different fitting time frames

function [timeFrameVec] = getTimeFrame(opt_i,year);

timeFrameVec = [year,ones(length(year),0)];

%opt_i = 3;

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
    
end
