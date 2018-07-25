% getSourceSink5.m
%
% author: Lauren Rafelski, modified by Julia Dohner
% May 16, 2018
%
% gss version that uses most recent values for FF (Boden 2017, GCPv1.3) and 
% land use (Houghton 2015, personal comm.)
% 
% outputs are in ppm/yr

function [ff,LU] = getSourceSink5(year, ts, LU_i);

addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/JLDedits_Rafelski_LandOceanModel/v3_params_match/necessary_data'));

d = 1/2.31; % gigaton to ppm conversion factor
d1 = 0.001; % teragram to petagram conversion factor
   
% FF data | Boden et al. (2017) via GCP 2017 v1.3
% 1750-2016 | GtC/yr | annual
FFdata = csvread('GCPv1.3_FF2016.csv');
FFinterp = (interp1(FFdata(:,1),FFdata(:,2),year)).';
ff(:,1) = year;
ff(:,2) = FFinterp*d; 

if LU_i == 1 % Houghton 2017
    % 1850-2016 | TgC/yr | annual
    LUdata = csvread('HoughLU_perscomm_2016.csv'); 
    LUinterp = (interp1(LUdata(:,1),LUdata(:,2),year));
    LU(:,1) = year;
    LU(:,2) = LUinterp*d*d1; 

elseif LU_i == 2 % hansis 2015
    % 1849-2016 | GtC/yr | annual
    LUdata = csvread('Pongratz2016_GCP_meanPasture_peat.csv'); %Hansis GCP
    LUinterp = (interp1(LUdata(:,1),LUdata(:,2),year));
    LU = [year, LUinterp*d];

elseif LU_i == 3 % hough 03 (Rafelski "high land use")
    % 1850-2016 | GtC/yr | monthly
    LUdata = csvread('Houghton03_1850-2016.csv',2); 
    startYr = find(LUdata(:,1) == year(1));
    endYr = find(LUdata(:,1) == year(end));
    LU = [LUdata(startYr:endYr,1),LUdata(startYr:endYr,2)*d];
        
elseif LU_i == 4 % constant land use case
    % complicated because houghton above is interpolated to start and
    % end years dictated by driver code, but want a linear
    % interpolation between the first and last datapoints in the
    % original houghton record
    LUdata = csvread('HoughLU_perscomm_2016.csv'); 
    const = [LUdata(1,1) LUdata(1,2)*d*d1 ; LUdata(end,1) LUdata(end,2)*d*d1];
    constYr = (const(1,1):1/ts:const(2,1))';
    LUconst_2016mo(:,1) = constYr;
    LUconst_2016mo(:,2) = (interp1(const(:,1),const(:,2),constYr));
    i = find(LUconst_2016mo(:,1) == 1920);

    LUconst_2016mo(i:end,2) = LUconst_2016mo(i,2);

    i2 = find(LUconst_2016mo == year(1));
    j2 = find(LUconst_2016mo == year(end));
    LU = LUconst_2016mo(i2:j2,:);

elseif LU_i == 5 % constant*2 land use case
    LUdata = csvread('HoughLU_perscomm_2016.csv'); 
    const2 = [LUdata(1,1) LUdata(1,2)*d*d1 ; LUdata(end,1) 2*LUdata(end,2)*d*d1];
    constYr2 = (const2(1,1):1/ts:const2(2,1))';
    LUconst2_2016mo(:,1) = constYr2;

    LUconst2_2016mo(:,2) = (interp1(const2(:,1),const2(:,2),constYr2));
    i = find(LUconst2_2016mo(:,1) == 1920);
    LUconst2_2016mo(i:end,2) = LUconst2_2016mo(i,2);

    i2 = find(LUconst2_2016mo == year(1));
    j2 = find(LUconst2_2016mo == year(end));
    LU = LUconst2_2016mo(i2:j2,:);

elseif LU_i == 6 % gcp
    % 1850-2016 | GtC/yr | annual
    LUdata = csvread('GCPv1.3_historicalLU2016.csv');
    LUinterp = (interp1(LUdata(:,1),LUdata(:,2),year));
    LU = [year, LUinterp*d];

elseif LU_i == 7 % hough 03 extratropical ("LR low")
    % 1850-2016 | GtC/yr | monthly
    LUdata = csvread('Houghton03_1850-2016_extratropOnly.csv',2); 
    startYr = find(LUdata(:,1) == year(1));
    endYr = find(LUdata(:,1) == year(end));
    LU = [LUdata(startYr:endYr,1),LUdata(startYr:endYr,2)*d];

elseif LU_i == 8 % 8 = CABLE (GCP)
    % 1850-2016 | GtC/yr | annual
    fid = fopen('CABLE_1860-2016.dat','r');
    datacell = textscan(fid, '%f%f%f', 'HeaderLines', 1, 'Collect', 1);
    fclose(fid);
    LUdata = datacell{1};        
    % interpolate to monthly and extend to 1850 using 1860 value
    LUinterp = (interp1([1850;LUdata(:,1)],[LUdata(1,2);LUdata(:,2)],year));
    LU = [year, LUinterp*d];

elseif LU_i == 9 % CABLE higher, grazing & harvest (C loss)
    % 1850-2016 | GtC/yr | annual
    fid = fopen('CABLE_1860-2016.dat','r'); 
    datacell = textscan(fid, '%f%f%f', 'HeaderLines', 1, 'Collect', 1);
    fclose(fid);
    LUdata = datacell{1};
    % interpolate to monthly and extend to 1850 using 1860 value
    LUinterp = (interp1([1850;LUdata(:,1)],[LUdata(1,3);LUdata(:,3)],year));
    LU = [year, LUinterp*d];

elseif LU_i == 10 % LPX-Bern HYDE
    % 1850-2016 | GtC/yr | annual
    LUdata = csvread('LPX-BERN_HydeLU_1860-2016.csv',1);
    LUinterp = (interp1([1850;LUdata(:,1)],[LUdata(1,2);LUdata(:,2)],year));
    LU = [year, LUinterp.*d];

elseif LU_i == 11 % LPX-Bern LUH
    % 1850-2016 | GtC/yr | annual
    LUdata = csvread('LPX-BERN_LUH_1860-2016.csv',1);
    LUinterp = (interp1([1850;LUdata(:,1)],[LUdata(1,2);LUdata(:,2)],year));
    LU = [year, LUinterp.*d];
    
elseif LU_i == 12 % ORCHIDEE-MICT
    % 1850-2016 | GtC/yr | annual
    % global LULCC flux is S2 - S3

    % get S2
    % 5 cols: year, global, north, tropics, south
    fidS2 = fopen('ORCHIDEE-MICT_S2_1860-2016.txt','r'); 
    datacell = textscan(fidS2, '%f%f%f%f%f', 'HeaderLines', 1, 'Collect', 1);
    fclose(fidS2);
    LUdata = datacell{1};
    S2_2016mo_0 = (interp1([1850;LUdata(:,1)],[LUdata(1,2);LUdata(:,2)],year));

    % get S3
    % 5 cols: year, global, north, tropics, south
    fidS2 = fopen('ORCHIDEE-MICT_S3_1860-2016.txt','r'); 
    datacell = textscan(fidS2, '%f%f%f%f%f', 'HeaderLines', 1, 'Collect', 1);
    fclose(fidS2);
    LUdata = datacell{1};
    S3_2016mo_0 = (interp1([1850;LUdata(:,1)],[LUdata(1,2);LUdata(:,2)],year));

    LU = [year, (S2_2016mo_0 - S3_2016mo_0)*d];

elseif LU_i == 13 % OC-N
    % 1860-2016 | GtC/yr | annual
    % global LULCC flux is S2 - S3

    % get S2
    % 5 cols: year, global, north, tropics, south
    fidS2 = fopen('OCN_S2_1860-2016.txt','r');
    datacell = textscan(fidS2, '%f%f%f%f%f', 'HeaderLines', 1, 'Collect', 1);
    fclose(fidS2);
    LUdata = datacell{1};
    S2_2016mo_0 = (interp1([1850;LUdata(:,1)],[LUdata(1,2);LUdata(:,2)],year));

    % get S3
    % 5 cols: year, global, north, tropics, south
    fidS2 = fopen('OCN_S3_1860-2016.txt','r');
    datacell = textscan(fidS2, '%f%f%f%f%f', 'HeaderLines', 1, 'Collect', 1);
    fclose(fidS2);
    LUdata = datacell{1};
    S3_2016mo_0 = (interp1([1850;LUdata(:,1)],[LUdata(1,2);LUdata(:,2)],year));

    LU = [year, (S2_2016mo_0 - S3_2016mo_0)*d];
    
elseif LU_i == 14 % CLM4.5 TODO
    %ncdisp('TRENDY2017_S3_LAND_USE_FLUX.nc')
    % see all the fill/missing values
    latData  = ncread('TRENDY2017_S3_LAND_USE_FLUX.nc','lat');
    lonData  = ncread('TRENDY2017_S3_LAND_USE_FLUX.nc','lon');
    % flux in gC/m^2/s
    % dimensions are lon (rows) x lat (columns) x time (3rd dim)
    fluxData = ncread('TRENDY2017_S3_LAND_USE_FLUX.nc','LAND_USE_FLUX');
    % days since 1860-01-01 00:00:00
    timeData = ncread('TRENDY2017_S3_LAND_USE_FLUX.nc','time');

    date0 = 1860;
    d2 = 1/365; % converting days to years
    date1 = timeData*d2 + date0;
    LU(:,1) = date1;
    
    for i = 1:length(date1)
        a = fluxData(:,:,i);
        LU(i,2) = nanmean2(a);
    end
    
    % I'm getting something very interesting here, not sure why there's the
    % oscillations at every month
    % also deal with units - this arrives in grams C/m^2/sec
    

    
    
    

elseif LU_i == 15 % Yue et al. (2018)
    % 1500-2005 | GtC/yr | annual
    LUdata = csvread('Yue_1500-2005.csv',1);
    LUinterp = (interp1(LUdata(:,1),LUdata(:,5),year));
    LU = [year, LUinterp*d];
    % annual 1500 to 2005
    % need first and 5th columns

elseif LU_i == 16 % Yue et al. (2018) without age dynamics
    % 1500-2005 | GtC/yr | annual
    LUdata = csvread('Yue_1500-2005_noAgeDyn.csv',1);
    LUinterp = (interp1(LUdata(:,1),LUdata(:,5),year));
    LU = [year, LUinterp*d];
    % annual 1500 to 2005
    % need first and 5th columns


        
end

end