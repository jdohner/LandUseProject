% calcErrors.m
%
% july 6, 2018
% julia dohner
%
% calculate RMSE for each run

% NOTE: errors calculated 1900-2014

function [RMSEunfilt,RMSEfilt] = calcErrors(ddtUnfilt,ddtFilt);

% unfilt - calculate error for 1958-end
i = find(ddtUnfilt(:,1) == 1900); % 1900 for debugging purposes %1958);
RMSEunfilt = sqrt(mean(ddtUnfilt(i:end,2).^2));

% filt - calculate error for 1900-end (optimization period)
j = find(ddtFilt(:,1) == 1900);
RMSEfilt = sqrt(mean(ddtFilt(j:end,2).^2));

end

% % identical to old code
% 
% load runInfo.mat % get year
% 
% d = 2.31; % ppm to PgC conversion factor (formerly 1/2.31 opp direction)
% obsCalcDiff2(:,2) = obsCalcDiff2(:,2)*d;
% resid_sm0_2 = smooth(obsCalcDiff2(:,2),59);
% 
% % shorten for fluxes
% year_sm_2 = year(1:12:end); % shorten filtered
% resid_sm1_2 = resid_sm0_2(1:12:end);
% 
% % prep unfiltered for loop
% blankVec1_2(:,1) = obsCalcDiff2(:,1); % going thru whole record
% blankVec1_2(:,2) = 0;
% ddtUnfilt_2 = blankVec1_2;
% 
% % prep filtered for loop
% blankVec2_2(:,1) = year_sm_2(1:end-1);
% blankVec2_2(:,2) = zeros(length(year_sm_2)-1,1);
% ddtFilt_2 = blankVec2_2;
% 
% % take monthly subtractions for unfiltered
% for i = 1:length(obsCalcDiff2(:,1))-12
%     ddtUnfilt_2(i,2) = obsCalcDiff2(i+12,2)-obsCalcDiff2(i,2);
% end
% 
% % take Jan-Jan fluxes
% for i = 1:length(year_sm_2)-1
%      ddtFilt_2(i,2) = resid_sm1_2(i+1)-resid_sm1_2(i);
% end
% 
% % cut off last value from filtered
% ddtFilt_2 = ddtFilt_2(1:length(ddtFilt_2-1),:);
%
% end
