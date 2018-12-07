% tempRecord3
%
% december 6, 2018
% julia dohner
%
% artificial temperatures with steps


function [temp_anom] = tempRecord4(Tstep_i,start_year,end_year,dt)

% start and end timepoints for all data from CRU
startDate = 1850;
endDate = 2018 + (4/12);
% timepoint 2018 counts as the first month in year, thus subtract 1
    
if Tstep_i == 1
    % step change in temp anomaly (0 to 1 at 1975)
    year0 = (startDate:dt:endDate)';
    data0 = zeros(length(year0),1);
    i = find(year0 == 1975);
    for j = i:length(data0)
        data0(j,1) = 1;
    end
    temp_anom0 = [year0,data0];
    
elseif Tstep_i == 2
    % step change in temp anomaly (0 to 1 at 1975, back down to 0 at 1995)
    year0 = (startDate:dt:endDate)';
    data0 = zeros(length(year0),1);
    i1 = find(year0 == 1975);
    i2 = find(year0 == 1995);
    for j = i1:i2
        data0(j,1) = 1;
    end
    temp_anom0 = [year0,data0];
    
elseif Tstep_i == 3
    % step change in temp anomaly (0 to 15 at 1975)
    year0 = (startDate:dt:endDate)';
    data0 = zeros(length(year0),1);
    i1 = find(year0 == 1975);
    for j = i1:length(data0)
        data0(j,1) = 15;
    end
    temp_anom0 = [year0,data0];
    
elseif Tstep_i == 4
    % step change in temp anomaly (0 to 15 at 1975, back down to 0 at 1995)
    year0 = (startDate:dt:endDate)';
    data0 = zeros(length(year0),1);
    i1 = find(year0 == 1975);
    i2 = find(year0 == 1995);
    for j = i1:i2
        data0(j,1) = 15;
    end
    temp_anom0 = [year0,data0];
    
end

i = find(temp_anom0 == start_year);
j = find(temp_anom0 == end_year);
temp_anom = temp_anom0(i:j,:);

end


