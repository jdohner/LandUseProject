% tempRecord3
%
% july 16, 2018
% julia dohner
%
% uses single full temperature records
% in contrast to tempRecord2 where I was trying to match output from Lauren
% Rafelski's code by appending the record she used to an updated different
% record

% I = HadCRUT4_2018_05
% II = CRUTEM4_2018_05
% III = CRUTEM4v
% IV = Nino 3.4 index
% V = tropical T
% VI = Global Historical Climate Network 
% VII = MLOST 3.5 from NOAA

function [temp_anom] = tempRecord3(Tdata_i,start_year,end_year,dt)

% start and end timepoints for all data from CRU
CRUstart = 1850;
CRUend = 2018 + (4/12);
% timepoint 2018 counts as the first month in year, thus subtract 1

%Tdata_i = 2;
    
if Tdata_i == 2
    
    % I = HadCRUT4_2018_05 (combined mean land and SST anomalies)
    % 1850-2018+4/12 | monthly
    data0 = csvread('HadCRUT4_2018_05.csv');
    year0 = (CRUstart:dt:CRUend)';
    data1 = data0(1:2:end,2:13); % every other row, cols 2-13
    data2 = reshape(data1',[],1);
    data3 = data2(1:length(year0));
    temp_anom0 = [year0,data3];
    
elseif Tdata_i == 3
    % II = CRUTEM4_2018_05 (land air T anomalies)
    % 1850-2018+4/12 | monthly
    data0 = csvread('CRUTEM4_2018_05.csv');
    year0 = (CRUstart:dt:CRUend)';
    data1 = data0(1:2:end,2:13); % every other row, cols 2-13
    data2 = reshape(data1',[],1);
    data3 = data2(1:length(year0));
    temp_anom0 = [year0,data3];
    
elseif Tdata_i == 4
    % III = CRUTEM4v (Variance adjusted version of CRUTEM4)
    % 1850-2018+4/12 | monthly
    data0 = csvread('CRUTEM4v_2018_05.csv');
    year0 = (CRUstart:dt:CRUend)';
    data1 = data0(1:2:end,2:13); % every other row, cols 2-13
    data2 = reshape(data1',[],1);
    data3 = data2(1:length(year0));
    temp_anom0 = [year0,data3];
    
elseif Tdata_i == 5
    % IV = Nino 3.4 index
    % 1870-April 2018 | monthly
    ESRLstart = 1870;
    ESRLend = 2018+(3/12);
    data0 = csvread('ESRLNOAA_Nino34_1870.csv');
    year0 = (ESRLstart:dt:ESRLend)';
    data1 = data0(:,2:13);
    data2 = reshape(data1',[],1);
    data3 = data2(1:length(year0));
    temp_anom0 = [year0,data3];
    
elseif Tdata_i == 6
    % V = tropical T
    % N/A
    
elseif Tdata_i == 7
    % VI = Global Historical Climate Network 
    % N/A
    
elseif Tdata_i == 8
    % VII = MLOST 3.5 from NOAA
    % N/A
    
elseif Tdata_i == 1
    % temp record from LR/my attempts to match LR (use for debugging)
    load landwt_T_2011.mat % 1850-2010

    CRU_data = csvread('CRUTEM4-gl.csv');

    % processing of CRUTEM4 file - comes in weird format
    % taking just rows with temp anomalies and cut off year values
    CRU_startYr = CRU_data(1,1); % starts 1850
    CRU_endYr = CRU_data(end,1) + (11/12); % ends Dec 2017
    CRU_year = (CRU_startYr:(1/12):CRU_endYr)';
    CRU_temp = CRU_data(1:2:end,2:13); % every other row for cols 2 to 13
    CRU_temp = reshape(CRU_temp',[],1); % reshape to column vector

    % temp_anom is 1850-Dec 2017 (end CRU data)
    temp_full(:,1) = 1850:dt:CRU_endYr;
    % add in landtglob, which begins at 1850.5
    i = find(temp_full(:,1) == landtglob(1,1));
    temp_full(1:i-1,2) = landtglob(1,2); % set first values
    % add landtglob up until 2009+7/12
    j = find(floor(100*temp_full(:,1)) == floor(100*(2009+(7/12))));
    k = find(floor(100*landtglob(:,1)) == floor(100*(2009+(7/12)))); 
    temp_full(i:j,2) = landtglob(1:k,2);  %%
    l = find(floor(100*CRU_year) == floor(100*landtglob(1910,1))); % find 2009+7/12
    %m = find(CRU_year == end);
    temp_full(1917:end,2) = CRU_temp(l+1:end);

    % temp_anom record spans 1850-dec 2017
    % cut short according to start and end years
    i1 = find(floor(100*temp_full(:,1)) == floor(100*start_year));
    j1 = find(floor(100*temp_full(:,1)) == floor(100*end_year));
    temp_anom0 = temp_full(i1:j1,:);

    
    
end

i = find(temp_anom0 == start_year);
j = find(temp_anom0 == end_year);
temp_anom = temp_anom0(i:j,:);

end


