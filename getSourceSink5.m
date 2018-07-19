% getSourceSink5.m
%
% author: Lauren Rafelski, modified by Julia Dohner
% May 16, 2018
%
% gss version that uses most recent values for FF (Boden 2015, GCP) and 
% land use (Houghton 2015, personal comm.)
% 
% outputs are in ppm/yr

function [ff,LU] = getSourceSink5(year, ts, LU_i);

addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/JLDedits_Rafelski_LandOceanModel/v3_params_match/necessary_data'));

d = 1/2.31; % gigaton to ppm conversion factor
d1 = 0.001; % teragram to petagram conversion factor
    
% ff data 1750-2016, GtC/yr
FF_2016 = csvread('GCPv1.3_FF2016.csv');
ffYear = FF_2016(1,1):(1/ts):FF_2016(end,1);
FF_2016mo_0 = (interp1(FF_2016(:,1),FF_2016(:,2),ffYear)).';
FF_2016mo(:,1) = ffYear;
FF_2016mo(:,2) = FF_2016mo_0*d; %convert to pp

% 1 = hough
% 2 = hansis
% 3 = hough03
% 4 = const
% 5 = const2
% 6 = gcp
% 7 = hough03 extratrop
% 8 = CABLE

% houghton, const, const2
if LU_i == 1 || LU_i == 4 || LU_i == 5
    
    data = csvread('HoughLU_perscomm_2016.csv'); 
    dataInterp = (interp1(data(:,1),data(:,2),year));
    LU_2016mo(:,1) = year;
    LU_2016mo(:,2) = dataInterp*d*d1; %convert from TgC to PgC to ppm
    % same to here
    
    if LU_i == 4
        clear LU_2016mo;
        % constant land use case
        % complicated because houghton above is interpolated to start and
        % end years dictated by driver code, but want a linear
        % interpolation between the first and last datapoints in the
        % original houghton record
        const = [data(1,1) data(1,2)*d*d1 ; data(end,1) data(end,2)*d*d1];
        constYr = (const(1,1):1/ts:const(2,1))';
        LUconst_2016mo(:,1) = constYr;
        LUconst_2016mo(:,2) = (interp1(const(:,1),const(:,2),constYr));
        i = find(LUconst_2016mo(:,1) == 1920);
        
        LUconst_2016mo(i:end,2) = LUconst_2016mo(i,2);
        
        i2 = find(LUconst_2016mo == year(1));
        j2 = find(LUconst_2016mo == year(end));
        LU_2016mo = LUconst_2016mo(i2:j2,:);
       
   
    elseif LU_i == 5
        
        clear LU_2016mo;
        % constant*2 land use case
        const2 = [data(1,1) data(1,2)*d*d1 ; data(end,1) 2*data(end,2)*d*d1];
        constYr2 = (const2(1,1):1/ts:const2(2,1))';
        LUconst2_2016mo(:,1) = constYr2;
        
        LUconst2_2016mo(:,2) = (interp1(const2(:,1),const2(:,2),constYr2));
        i = find(LUconst2_2016mo(:,1) == 1920);
        LUconst2_2016mo(i:end,2) = LUconst2_2016mo(i,2);
        
        i2 = find(LUconst2_2016mo == year(1));
        j2 = find(LUconst2_2016mo == year(end));
        LU_2016mo = LUconst2_2016mo(i2:j2,:);
        
    end
    
else
    if LU_i == 2 % hansis
        % 1849-2016 | GtC/yr | annual
        data = csvread('Pongratz2016_GCP_meanPasture_peat.csv'); %Hansis GCP
        dataInterp = (interp1(data(:,1),data(:,2),year));
        LU_2016mo = [year, dataInterp*d];
      
    elseif LU_i == 3 % hough 03
        % 1850-2016 | GtC/yr | monthly
        data = csvread('LR_LU.csv'); %Rafelski 2009 high land use
        startYr = find(data(:,1) == year(1));
        endYr = find(data(:,1) == year(end));
        LU_2016mo = [data(startYr:endYr,1),data(startYr:endYr,2)*d];
        
        
%         LU_2016mo_0 = (interp1(data(:,1),data(:,2),year));
%         LU_2016mo = [year, LU_2016mo_0*d];
        
    % 4 = const
    % 5 = const*2
    
    elseif LU_i == 6 % gcp
        % 1850-2016 | GtC/yr | annual
        data = csvread('GCPv1.3_historicalLU2016.csv');
        dataInterp = (interp1(data(:,1),data(:,2),year));
        LU_2016mo = [year, dataInterp*d];
        
    elseif LU_i == 7 % hough 03 extratropical ("LR low")
        % 1850-2016 | GtC/yr | monthly
        data = csvread('LR_LUex.csv'); %Rafelski 2009 low land use
        startYr = find(data(:,1) == year(1));
        endYr = find(data(:,1) == year(end));
        LU_2016mo = [data(startYr:endYr,1),data(startYr:endYr,2)*d];
        
    elseif LU_i == 8 % 8 = CABLE (GCP)
        % 1850-2016 | GtC/yr | annual
        fid = fopen('CABLE_1860-2016.dat','r');
        datacell = textscan(fid, '%f%f%f', 'HeaderLines', 1, 'Collect', 1);
        fclose(fid);
        data = datacell{1};        
        % interpolate to monthly and extend to 1850 using 1860 value
        dataInterp = (interp1([1850;data(:,1)],[data(1,2);data(:,2)],year));
        LU_2016mo = [year, dataInterp*d];

    elseif LU_i == 9 % CABLE higher, grazing & harvest (C loss)
        % 1850-2016 | GtC/yr | annual
        fid = fopen('CABLE_1860-2016.dat','r'); % open for reading (r) permission
        datacell = textscan(fid, '%f%f%f', 'HeaderLines', 1, 'Collect', 1);
        fclose(fid);
        data = datacell{1};
        % interpolate to monthly and extend to 1850 using 1860 value
        dataInterp = (interp1([1850;data(:,1)],[data(1,3);data(:,3)],year));
        LU_2016mo = [year, dataInterp*d];
        
    elseif LU_i == 10 % LPX-Bern HYDE
        % 1850-2016 | GtC/yr | annual
        data = csvread('LPX-BERN_HydeLU_1860-2016.csv',1);
        dataInterp = (interp1([1850;data(:,1)],[data(1,2);data(:,2)],year));
        LU_2016mo = [year, dataInterp.*d];
        
    elseif LU_i == 11 % LPX-Bern LUH
        % 1850-2016 | GtC/yr | annual
        data = csvread('LPX-BERN_LUH_1860-2016.csv',1);
        dataInterp = (interp1([1850;data(:,1)],[data(1,2);data(:,2)],year));
        LU_2016mo = [year, dataInterp.*d];
        
    elseif LU_i == 12 % Yue et al. (2018)
        % 1500-2005 | GtC/yr | annual
        data = csvread('Yue_1500-2005.csv',1);
        dataInterp = (interp1(data(:,1),data(:,5),year));
        LU_2016mo = [year, dataInterp*d];
        % annual 1500 to 2005
        % need first and 5th columns
        
    elseif LU_i == 13 % Yue et al. (2018) without age dynamics
        % 1500-2005 | GtC/yr | annual
        data = csvread('Yue_1500-2005_noAgeDyn.csv',1);
        dataInterp = (interp1(data(:,1),data(:,5),year));
        LU_2016mo = [year, dataInterp*d];
        % annual 1500 to 2005
        % need first and 5th columns
        
    elseif LU_i == 14 % CLM4.5 TODO
        %ncdisp('TRENDY2017_S3_LAND_USE_FLUX.nc')
        % see all the fill/missing values
        latData  = ncread('TRENDY2017_S3_LAND_USE_FLUX.nc','lat');
        lonData  = ncread('TRENDY2017_S3_LAND_USE_FLUX.nc','lon');
        % flux in gC/m^2/s
        fluxData = ncread('TRENDY2017_S3_LAND_USE_FLUX.nc','LAND_USE_FLUX');
        % days since 1860-01-01 00:00:00
        timeData = ncread('TRENDY2017_S3_LAND_USE_FLUX.nc','time');
        
    elseif LU_i == 15 % ORCHIDEE-MICT
        % 1850-2016 | GtC/yr | annual
        % global LULCC flux is S2 - S3
        
        % get S2
        % 5 cols: year, global, north, tropics, south
        fidS2 = fopen('ORCHIDEE-MICT_S2_1860-2016.txt','r'); 
        datacell = textscan(fidS2, '%f%f%f%f%f', 'HeaderLines', 1, 'Collect', 1);
        fclose(fidS2);
        data = datacell{1};
        S2_2016mo_0 = (interp1([1850;data(:,1)],[data(1,2);data(:,2)],year));
        
        % get S3
        % 5 cols: year, global, north, tropics, south
        fidS2 = fopen('ORCHIDEE-MICT_S3_1860-2016.txt','r'); 
        datacell = textscan(fidS2, '%f%f%f%f%f', 'HeaderLines', 1, 'Collect', 1);
        fclose(fidS2);
        data = datacell{1};
        S3_2016mo_0 = (interp1([1850;data(:,1)],[data(1,2);data(:,2)],year));
        
        LU_2016mo = [year, (S2_2016mo_0 - S3_2016mo_0)*d];
        
    elseif LU_i == 16 % OC-N
        % 1860-2016 | GtC/yr | annual
        % global LULCC flux is S2 - S3
        
        % get S2
        % 5 cols: year, global, north, tropics, south
        fidS2 = fopen('OCN_S2_1860-2016.txt','r');
        datacell = textscan(fidS2, '%f%f%f%f%f', 'HeaderLines', 1, 'Collect', 1);
        fclose(fidS2);
        data = datacell{1};
        S2_2016mo_0 = (interp1([1850;data(:,1)],[data(1,2);data(:,2)],year));
        
        % get S3
        % 5 cols: year, global, north, tropics, south
        fidS2 = fopen('OCN_S3_1860-2016.txt','r');
        datacell = textscan(fidS2, '%f%f%f%f%f', 'HeaderLines', 1, 'Collect', 1);
        fclose(fidS2);
        data = datacell{1};
        S3_2016mo_0 = (interp1([1850;data(:,1)],[data(1,2);data(:,2)],year));
        
        LU_2016mo = [year, (S2_2016mo_0 - S3_2016mo_0)*d];
        
    end
    
%     luYear = LU_2016(1,1):(1/ts):LU_2016(end,1);
%     LU_2016mo_0 = (interp1(LU_2016(:,1),LU_2016(:,2),luYear)).';
%     LU_2016mo(:,1) = luYear;
%     LU_2016mo(:,2) = LU_2016mo_0*d; % convert from PgC to ppm

end

% shorten datasets to match time frame of year vector
FF_start = find(FF_2016mo(:,1) == year(1));
FF_end = find(FF_2016mo(:,1) == year(end));
ff = FF_2016mo(FF_start:FF_end,:);
% LU_start = find(LU_2016mo(:,1) == year(1));
% LU_end = find(LU_2016mo(:,1) == year(end));
% LU = LU_2016mo(LU_start:LU_end,:);

LU = LU_2016mo;

end