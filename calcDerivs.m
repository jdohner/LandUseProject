% calcDerivs.m
%
% july 6, 2018
% julia dohner
%
% calculate and process residual fluxes

function [ddtUnfilt,ddtFilt] = calcDerivs(obsCalcDiff)

% smooth
resid_sm0 = [obsCalcDiff(:,1),smooth(obsCalcDiff(:,2),59)];

% shorten for fluxes
resid_sm1 = [resid_sm0(1:12:end,1),resid_sm0(1:12:end,2)];
resid_unfilt1 = [obsCalcDiff(1:12:end,1),obsCalcDiff(1:12:end,2)];

blankVec(:,1) = obsCalcDiff(1:12:end,1);
blankVec(:,2) = 0;
ddtFilt = blankVec;
ddtUnfilt = blankVec;

% take Jan-Jan fluxes
for i = 1:length(resid_sm1(:,1))-1
    ddtFilt(i,2) = resid_sm1(i+1,2)-resid_sm1(i,2);
    ddtUnfilt(i,2) = resid_unfilt1(i+1,2)-resid_unfilt1(i,2);
end

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
