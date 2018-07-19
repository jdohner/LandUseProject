% getSourceSink5.m
%
% author: Lauren Rafelski, modified by Julia Dohner
% May 16, 2018
%
% gss version that uses most recent values for FF (Boden 2015, GCP) and 
% land use (Houghton 2015, personal comm.)

function [ff,LU] = getSourceSink5(year, ts,LU_i);

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
    %if using Houghton:
    LU_2016 = csvread('HoughLU_perscomm_2016.csv'); 
    luYear = LU_2016(1,1):(1/ts):LU_2016(end,1);
    LU_2016mo_0 = (interp1(LU_2016(:,1),LU_2016(:,2),luYear)).';
    LU_2016mo(:,1) = luYear;
    %TgC to ppm (d1) only for Houghton
    LU_2016mo(:,2) = LU_2016mo_0*d*d1; %convert from TgC to PgC to ppm
    
    if LU_i == 4
        const = [LU_2016mo(1,1) LU_2016mo(1,2) ; LU_2016mo(end,1) LU_2016mo(end,2)];
        LU_2016mo(:,2) = (interp1(const(:,1),const(:,2),luYear)).';
        i = find(LU_2016mo(:,1) == 1920);
        LU_2016mo(i:end,2) = LU_2016mo(i,2);
    elseif LU_i == 5
        const2 = [LU_2016mo(1,1) LU_2016mo(1,2) ; LU_2016mo(end,1) 2*LU_2016mo(end,2)];
        LU_2016mo(:,2) = (interp1(const2(:,1),const2(:,2),luYear)).';
        i = find(LU_2016mo(:,1) == 1920);
        LU_2016mo(i:end,2) = LU_2016mo(i,2);
        
    end
    
    
    
else
    if LU_i == 2 % hansis
        LU_2016 = csvread('Pongratz2016_GCP_meanPasture_peat.csv'); %Hansis GCP
      
    elseif LU_i == 3 % hough 03
        LU_2016 = csvread('LR_LU.csv'); %Rafelski 2009 high land use
        
    elseif LU_i == 5 % hough 03 extratropical ("LR low")
        LU_2016 = csvread('LR_LUex.csv'); %Rafelski 2009 low land use
    
    elseif LU_i == 6 % gcp
        LU_2016 = csvread('GCPv1.3_historicalLU2016.csv');
        
    elseif LU_i == 7 %hough03 extratrop
        
    elseif LU_i == 8 % 8 = CABLE (GCP)
        fid = fopen('CABLE_LUC.dat','r'); % open for reading (r) permission
        datacell = textscan(fid, '%f%f%f', 'HeaderLines', 1, 'Collect', 1);
        fclose(fid);
        data = datacell{1};
        LU_2016(:,1) = data(:,1);
        LU_2016(:,2) = data(:,2);
        % annual, need to put into monthly
        % PgC/yr

    elseif LU_i == 9 % CABLE higher, grazing & harvest (C loss)
        fid = fopen('CABLE_LUC.dat','r'); % open for reading (r) permission
        datacell = textscan(fid, '%f%f%f', 'HeaderLines', 1, 'Collect', 1);
        fclose(fid);
        data = datacell{1};
        LU_2016(:,1) = data(:,1);
        LU_2016(:,2) = data(:,3);
        % annual, need to put into monthly
        % PgC/yr
        
    elseif LU_i == 10 % LPX-Bern HYDE
        LU_2016 = csvread('ELUC_HydeLU_GCP2017_LPX-BERN.csv',1);
        % annual 1850-2016
        % PgC/yr
        
    elseif LU_i == 11 % LPX-Bern LUH
        LU_2016 = csvread('ELUC_LUH_GCP2017_LPX-BERN.csv',1);
        % annual 1850-2016
        % PgC/yr
        
    elseif LU_i == 12 % Yue et al. (2018)
        LU_2016 = csvread('Yue_Globe_ELUC.csv',1);
        % annual 1500 to 2005
        % PgC/yr
        % need first and 5th columns
        
    elseif LU_i == 13 % Yue et al. (2018) without age dynamics
        LU_2016 = csvread('Yue_Globe_ELUC_noAgeDyn.csv',1);
        % annual 1500 to 2005
        % PgC/yr
        % need first and 5th columns
        
    elseif LU_i == 14 % CLM4.5
        %ncdisp('TRENDY2017_S3_LAND_USE_FLUX.nc')
        % see all the fill/missing values
        latData  = ncread('TRENDY2017_S3_LAND_USE_FLUX.nc','lat');
        lonData  = ncread('TRENDY2017_S3_LAND_USE_FLUX.nc','lon');
        % flux in gC/m^2/s
        fluxData = ncread('TRENDY2017_S3_LAND_USE_FLUX.nc','LAND_USE_FLUX');
        % days since 1860-01-01 00:00:00
        timeData = ncread('TRENDY2017_S3_LAND_USE_FLUX.nc','time');
        
    elseif LU_i == 15 % ORCHIDEE-MICT
        % get S2
        fidS2 = fopen('ORCHIDEE-MICT_S2_zonalNBP.txt','r'); % open for reading (r) permission
        datacell = textscan(fidS2, '%f%f%f', 'HeaderLines', 1, 'Collect', 1);
        fclose(fidS2);
        data = datacell{1};
        LU_2016(:,1) = data(:,1);
        LU_2016(:,2) = data(:,3);
        % second column is global
        
        % get S3
        fidS3 = fopen('ORCHIDEE-MICT_S3_zonalNBP.txt','r'); % open for reading (r) permission
        datacell = textscan(fidS3, '%f%f%f', 'HeaderLines', 1, 'Collect', 1);
        fclose(fidS3);
        data = datacell{1};
        LU_2016(:,1) = data(:,1);
        LU_2016(:,2) = data(:,3);   
        % second column is global
        
    elseif LU_i == 16 % OC-N
        % get S2
        fidS2 = fopen('OCN_S2_nbp_by_lat.txt','r'); % open for reading (r) permission
        datacell = textscan(fidS2, '%f%f%f', 'HeaderLines', 1, 'Collect', 1);
        fclose(fidS2);
        data = datacell{1};
        LU_2016(:,1) = data(:,1);
        LU_2016(:,2) = data(:,3);
        % second column is global
        
        % get S3
        fidS3 = fopen('OCN_S3_nbp_by_lat.txt','r'); % open for reading (r) permission
        datacell = textscan(fidS3, '%f%f%f', 'HeaderLines', 1, 'Collect', 1);
        fclose(fidS3);
        data = datacell{1};
        LU_2016(:,1) = data(:,1);
        LU_2016(:,2) = data(:,3);   
        % second column is global
        
    end

    
    
    luYear = LU_2016(1,1):(1/ts):LU_2016(end,1);
    LU_2016mo_0 = (interp1(LU_2016(:,1),LU_2016(:,2),luYear)).';
    LU_2016mo(:,1) = luYear;
    LU_2016mo(:,2) = LU_2016mo_0*d; % convert from PgC to ppm

end

% shorten datasets to match time frame of year vector
FF_start = find(FF_2016mo(:,1) == year(1));
FF_end = find(FF_2016mo(:,1) == year(end));
ff = FF_2016mo(FF_start:FF_end,:);
LU_start = find(LU_2016mo(:,1) == year(1));
LU_end = find(LU_2016mo(:,1) == year(end));
LU = LU_2016mo(LU_start:LU_end,:);

end