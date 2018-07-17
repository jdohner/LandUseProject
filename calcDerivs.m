% calcDerivs.m
%
% july 6, 2018
% julia dohner
%
% calculate and process residual fluxes

function [ddtUnfilt,ddtFilt] = calcDerivs(obsCalcDiff)

% % smooth

d = 2.31; % ppm to PgC conversion factor (formerly 1/2.31 opp direction)
obsCalcDiff(:,2) = obsCalcDiff(:,2)*d;
resid_sm0 = [obsCalcDiff(:,1),smooth(obsCalcDiff(:,2),59)];

% shorten for fluxes
resid_sm0 = [resid_sm0(1:12:end,1),resid_sm0(1:12:end,2)];
resid_unfilt1 = [obsCalcDiff(1:12:end,1),obsCalcDiff(1:12:end,2)];

% prep unfiltered and filtered for loop
blankVec(:,1) = obsCalcDiff(1:12:end,1);
blankVec(:,2) = 0;
ddtFilt = blankVec;
ddtUnfilt = blankVec;

% take Jan-Jan fluxes
for i = 1:length(resid_sm0(:,1))-1
    ddtFilt(i,2) = resid_sm0(i+1,2)-resid_sm0(i,2);
    ddtUnfilt(i,2) = resid_unfilt1(i+1,2)-resid_unfilt1(i,2);
end

ddtFilt = ddtFilt(1:length(ddtFilt)-1,:);
ddtUnfilt = ddtUnfilt(1:length(ddtUnfilt)-1,:);

end

%% identical to old code

% d = 2.31; % ppm to PgC conversion factor (formerly 1/2.31 opp direction)
% obsCalcDiff(:,2) = obsCalcDiff(:,2)*d;
% 
% % unfiltered
% blankVec1(:,1) = obsCalcDiff(:,1);
% blankVec1(:,2) = 0;
%  
% ddtUnfilt = blankVec1;
%  
% for i = 1:length(obsCalcDiff(:,1))-12
%     ddtUnfilt(i,2) = obsCalcDiff(i+12,2)-obsCalcDiff(i,2);
% end
%  
% % filtered
% resid_sm0 = smooth(obsCalcDiff(:,2),59);
% resid_sm1 = resid_sm0(1:12:end);
% 
% load runInfo.mat % get year
% 
% year_sm = year(1:12:end); 
% blankVec2(:,1) = year_sm(1:end-1);
% blankVec2(:,2) = zeros(length(year_sm)-1,1);
% ddtFilt = blankVec2;
%  
% for i = 1:length(year_sm)-1
%      ddtFilt(i,2) = resid_sm1(i+1)-resid_sm1(i);
% end
% ddtFilt = ddtFilt(1:length(ddtFilt-1),:);
% 
% 
% 
% 
% end

%% not sure what's down here
% 
% year_sm = obsCalcDiff(1:12:end,2);
% resid_sm0 = smooth(obsCalcDiff(:,2),59);
% % smoothed residual as flux - taking annual differences (Jan - Jan)
% resid_sm1 = year_sm;
% 
% % initialize vector
% ddtFilt(:,1) = resid_sm1(:,1);
% ddtFilt(:,2) = 0;
% 
% 
% 
% ddtUnfilt(:,1) = obsCalcDiff(:,1);
% ddtUnfilt(:,2) = 0;
% 
% for i = 1:length(obsCalcDiff(:,1))-12
%     ddtUnfilt(i,2) = obsCalcDiff(i+12,2)-obsCalcDiff(i,2);
% end
% 
