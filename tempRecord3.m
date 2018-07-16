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

function [temp_anom] = tempRecord3(tempRecord,start_year,end_year,dt)

% start and end timepoints for all data from CRU
CRUstart = 1850;
CRUend = 2018 + (4/12);
% timepoint 2018 counts as the first month in year, thus subtract 1
    
if strcmp(tempRecord,'I')
    
    % I = HadCRUT4_2018_05
    data0 = csvread('HadCRUT4_2018_05.csv');
    year0 = (CRUstart:dt:CRUend)';
    data1 = data0(1:2:end,2:13); % every other row, cols 2-13
    data2 = reshape(data1',[],1);
    data3 = data2(1:length(year0));
    temp_anom = [year0,data3];
    
elseif strcmp(tempRecord,'II')
    % II = CRUTEM4_2018_05
    data0 = csvread('CRUTEM4_2018_05.csv');
    year0 = (CRUstart:dt:CRUend)';
    data1 = data0(1:2:end,2:13); % every other row, cols 2-13
    data2 = reshape(data1',[],1);
    data3 = data2(1:length(year0));
    temp_anom = [year0,data3];
    
elseif strcmp(tempRecord,'III')
    % III = CRUTEM4v
    data0 = csvread('CRUTEM4v_2018_05.csv');
    year0 = (CRUstart:dt:CRUend)';
    data1 = data0(1:2:end,2:13); % every other row, cols 2-13
    data2 = reshape(data1',[],1);
    data3 = data2(1:length(year0));
    temp_anom = [year0,data3];
    
elseif strcmp(tempRecord,'IV')
    % IV = Nino 3.4 index
    % 1870-April 2018
    ESRLstart = 1870;
    ESRLend = 2018+(3/12);
    data0 = csvread('ESRLNOAA_Nino34_1870.csv');
    year0 = (ESRLstart:dt:ESRLend)';
    data1 = data0(:,2:13);
    data2 = reshape(data1',[],1);
    data3 = data2(1:length(year0));
    temp_anom = [year0,data3];
    
elseif strcmp(tempRecord,'V')
    % V = tropical T
    % N/A
    
elseif strcmp(tempRecord,'VI')
    % VI = Global Historical Climate Network 
    % N/A
    
elseif strcmp(tempRecord,'VII')
    % VII = MLOST 3.5 from NOAA
    % N/A
    

    
end

    



end


