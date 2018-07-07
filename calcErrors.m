% calcErrors.m
%
% july 6, 2018
% julia dohner
%
% calculate RMSE for each run

function [RMSEunfilt,RMSEfilt] = calcErrors(ddtUnfilt,ddtFilt);

% unfilt - calculate error for 1958-end
i = find(ddtUnfilt(:,1) == 1958);
RMSEunfilt = sqrt(mean(ddtUnfilt(i:end,2).^2));

% filt - calculate error for 1900-end (optimization period)
j = find(ddtFilt(:,1) == 1900);
RMSEfilt = sqrt(mean(ddtFilt(j:end,2).^2));

end
