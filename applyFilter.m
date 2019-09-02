% applyFilter.m
%
% july 16, 2019
% 
% author: julia dohner

function [decon_resid] = applyFilter(filt_i, decon_resid0, end_year,scheme)

if filt_i == 1 % 10-year filter
    % using filtered data for everything after 1957
    i = find(decon_resid0(:,1) == 1952);
    k = find(decon_resid0(:,1) >= (1956+(11/12)),1);

    [decon_filt0] = l_boxcar(decon_resid0,10,12,i,length(decon_resid0),1,2);
    decon_resid(1:k,:) = decon_resid0(1:k,:);
    decon_resid((k+1):(length(decon_filt0)),:) = decon_filt0((k+1):end,:);
    
elseif filt_i == 2 % 1-year filter
    i = find(decon_resid0(:,1) == 1952);
    k = find(decon_resid0(:,1) >= (1956+(11/12)),1);

    [decon_filt0] = l_boxcar(decon_resid0,1,12,i,length(decon_resid0),1,2);
    decon_resid(1:k,:) = decon_resid0(1:k,:);
    decon_resid((k+1):(length(decon_filt0)),:) = decon_filt0((k+1):end,:);   

elseif  filt_i == 3 % unfiltered
    % shorten unfiltered record
    k = find(decon_resid0(:,1) == end_year-5);
    decon_resid = decon_resid0(1:k,:);    

elseif filt_i == 4 % unfilt - filt 10-year
    
    % using filtered data for everything after 
    i = find(decon_resid0(:,1) == 1952);
    k = find(decon_resid0(:,1) >= (1956+(11/12)),1);

    [decon_filt0] = l_boxcar(decon_resid0,10,12,i,length(decon_resid0),1,2);
    decon_residFilt(1:k,:) = decon_resid0(1:k,:);
    decon_residFilt((k+1):(length(decon_filt0)),:) = decon_filt0((k+1):end,:);

    % shorten unfiltered record
    k = find(decon_resid0(:,1) == end_year-5);
    decon_residUnfilt = decon_resid0(1:k,:);  
    
    % difference (only the high-freq noise)
    decon_resid = [decon_residUnfilt(:,1) , ...
        decon_residUnfilt(:,2)-decon_residFilt(:,2)];
    
elseif filt_i == 5 % unfilt - filt 1-year
    
    % using filtered data for everything after 
    i = find(decon_resid0(:,1) == 1952);
    k = find(decon_resid0(:,1) >= (1956+(11/12)),1);

    [decon_filt0] = l_boxcar(decon_resid0,1,12,i,length(decon_resid0),1,2);
    decon_residFilt(1:k,:) = decon_resid0(1:k,:);
    decon_residFilt((k+1):(length(decon_filt0)),:) = decon_filt0((k+1):end,:);

    % shorten unfiltered record
    k = find(decon_resid0(:,1) == end_year-5);
    decon_residUnfilt = decon_resid0(1:k,:);  
    decon_residFilt = decon_residFilt(1:k,:);
    
    % difference (only the high-freq noise)
    decon_resid = [decon_residUnfilt(:,1) , ...
        decon_residUnfilt(:,2)-decon_residFilt(:,2)];
    
    

end

if strcmp(scheme,'aa') % 10-year filter after 1900
    i = find(decon_resid0(:,1) == 1895);
    k = find(decon_resid0(:,1) >= 1900,1);

    [decon_filt0] = l_boxcar(decon_resid0,10,12,i,length(decon_resid0),1,2);
    decon_resid(1:k,:) = decon_resid0(1:k,:);
    decon_resid((k+1):(length(decon_filt0)),:) = decon_filt0((k+1):end,:);

elseif strcmp(scheme,'bb') % 10-year filter after 1957
    % using filtered data for everything after 1957
    i = find(decon_resid0(:,1) == 1952); 
    k = find(decon_resid0(:,1) >= (1956+(11/12)),1);

    [decon_filt0] = l_boxcar(decon_resid0,10,12,i,length(decon_resid0),1,2);
    decon_resid(1:k,:) = decon_resid0(1:k,:);
    decon_resid((k+1):(length(decon_filt0)),:) = decon_filt0((k+1):end,:);
    
end


% decon_resid is 5 years shorter than full record
save('decon_resid','decon_resid');


