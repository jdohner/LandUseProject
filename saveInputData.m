% saveInputData.m
%
% July 27, 2018
% Julia Dohner
%
% Loads and saves FF, LU and T data so that driver doesn't have to load
% and process every time, can instead open pre-processed .mat file

function saveInputData

addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/LandUseProject/necessary_data'));
addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/LU_data_big'));

start_year = 1850;
end_year = 2015.5;
year = (start_year:(1/12):end_year)';
ts = 12; % timesteps per year
dt = 1/ts;

addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/LU_data_big'));

d = 1/2.31; % gigaton to ppm conversion factor
d1 = 0.001; % teragram to petagram conversion factor
   
% FF data | Boden et al. (2017) via GCP 2017 v1.3
% 1750-2016 | GtC/yr | annual
FFdata = csvread('GCPv1.3_FF2016.csv');
FFinterp = (interp1(FFdata(:,1),FFdata(:,2),year)).';
Boden2016(:,1) = year;
Boden2016(:,2) = FFinterp*d; 

% Houghton 2017
    % 1850-2016 | TgC/yr | annual
    LUdata = csvread('HoughLU_perscomm_2016.csv'); 
    LUinterp = (interp1(LUdata(:,1),LUdata(:,2),year));
    Houghton2017(:,1) = year;
    Houghton2017(:,2) = LUinterp*d*d1;
    
    clear LUdata LUinterp;

% hansis 2015 (column I in file sent by J. Pongratz)
    % 1849-2016 | GtC/yr | annual
    LUdata = csvread('Pongratz2016_GCP_meanPasture_peat.csv'); %Hansis GCP
    LUinterp = (interp1(LUdata(:,1),LUdata(:,2),year));
    Hansis2015_I = [year, LUinterp*d];
    clear LUdata LUinterp;

% hough 03 (Rafelski "high land use")
    % 1850-2016 | GtC/yr | monthly
    LUdata = csvread('Houghton03_1850-2016.csv',2); 
    startYr = find(LUdata(:,1) == year(1));
    endYr = find(LUdata(:,1) == year(end));
    Houghton2003 = [LUdata(startYr:endYr,1),LUdata(startYr:endYr,2)*d];
    clear LUdata startYr endYr;
        
% constant land use case
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
    ConstantLU = LUconst_2016mo(i2:j2,:);
    
    clear LUdata i i2 j2;

% constant*2 land use case
    LUdata = csvread('HoughLU_perscomm_2016.csv'); 
    const2 = [LUdata(1,1) LUdata(1,2)*d*d1 ; LUdata(end,1) 2*LUdata(end,2)*d*d1];
    constYr2 = (const2(1,1):1/ts:const2(2,1))';
    LUconst2_2016mo(:,1) = constYr2;

    LUconst2_2016mo(:,2) = (interp1(const2(:,1),const2(:,2),constYr2));
    i = find(LUconst2_2016mo(:,1) == 1920);
    LUconst2_2016mo(i:end,2) = LUconst2_2016mo(i,2);

    i2 = find(LUconst2_2016mo == year(1));
    j2 = find(LUconst2_2016mo == year(end));
    Constant2LU = LUconst2_2016mo(i2:j2,:);
    
    clear LUdata i i2 j2;

% gcp
    % 1850-2016 | GtC/yr | annual
    LUdata = csvread('GCPv1.3_historicalLU2016.csv');
    LUinterp = (interp1(LUdata(:,1),LUdata(:,2),year));
    GCP2017 = [year, LUinterp*d];
    clear LUdata LUinterp;

% hough 03 extratropical ("LR low")
    % 1850-2016 | GtC/yr | monthly
    LUdata = csvread('Houghton03_1850-2016_extratropOnly.csv',2); 
    startYr = find(LUdata(:,1) == year(1));
    endYr = find(LUdata(:,1) == year(end));
    Houghton2003low = [LUdata(startYr:endYr,1),LUdata(startYr:endYr,2)*d];
    clear LUdata LUinterp startYr endYr;

% 8 = CABLE (GCP)
    % 1850-2016 | GtC/yr | annual
    fid = fopen('CABLE_1860-2016.dat','r');
    datacell = textscan(fid, '%f%f%f', 'HeaderLines', 1, 'Collect', 1);
    fclose(fid);
    LUdata = datacell{1};        
    % interpolate to monthly and extend to 1850 using 1860 value
    LUinterp = (interp1([1850;LUdata(:,1)],[LUdata(1,2);LUdata(:,2)],year));
    CABLE2016 = [year, LUinterp*d];
    clear fid datacell LUdata LUinterp;

% CABLE higher, grazing & harvest (C loss)
    % 1850-2016 | GtC/yr | annual
    fid = fopen('CABLE_1860-2016.dat','r'); 
    datacell = textscan(fid, '%f%f%f', 'HeaderLines', 1, 'Collect', 1);
    fclose(fid);
    LUdata = datacell{1};
    % interpolate to monthly and extend to 1850 using 1860 value
    LUinterp = (interp1([1850;LUdata(:,1)],[LUdata(1,3);LUdata(:,3)],year));
    CABLE2016high = [year, LUinterp*d];
    clear fid datacell LUdata LUinterp;

% LPX-Bern HYDE
    % 1850-2016 | GtC/yr | annual
    LUdata = csvread('LPX-BERN_HydeLU_1860-2016.csv',1);
    LUinterp = (interp1([1850;LUdata(:,1)],[LUdata(1,2);LUdata(:,2)],year));
    LPXBern2016_HYDE = [year, LUinterp.*d];
    clear LUdata LUinterp;

% LPX-Bern LUH
    % 1850-2016 | GtC/yr | annual
    LUdata = csvread('LPX-BERN_LUH_1860-2016.csv',1);
    LUinterp = (interp1([1850;LUdata(:,1)],[LUdata(1,2);LUdata(:,2)],year));
    LPXBern2016_LUH = [year, LUinterp.*d];
    clear LUdata LUinterp;
    
% ORCHIDEE-MICT
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

    ORCHIDEEMICT2016 = [year, (S2_2016mo_0 - S3_2016mo_0)*d];
    clear fidS2 fidS3 LUdata LUinterp;

% OC-N
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

    OCN2016 = [year, (S2_2016mo_0 - S3_2016mo_0)*d];
    clear fidS2 LUdata LUinterp;
    
% CLM4.5 TODO
    %ncdisp('TRENDY2017_S3_LAND_USE_FLUX.nc')
    % see all the fill/missing values
    latData  = ncread('TRENDY2017_S3_LAND_USE_FLUX.nc','lat');
    lonData  = ncread('TRENDY2017_S3_LAND_USE_FLUX.nc','lon');
    % flux in gC/m^2/s
    % dimensions are lon (rows) x lat (columns) x time (3rd dim)
    fluxData0 = ncread('TRENDY2017_S3_LAND_USE_FLUX.nc','LAND_USE_FLUX');
    % days since 1860-01-01 00:00:00
    timeData = ncread('TRENDY2017_S3_LAND_USE_FLUX.nc','time'); % monthly

    date0 = 1860;
    d2 = 1/365; % converting days to years
    date1 = timeData*d2 + date0;
    CLM45_2016(:,1) = date1;
    
    % make sure you know what you're doing when you manipulate the time
    % stuff, and also that the x axis is incrementing evenly
    
    for i = 1:length(date1)
        a = fluxData0(:,:,i);
        fluxData1(i) = nanmean2(a);
        %CLM45_2016(i,2) = nanmean2(a);
        % do weighted average by cosine of latitude, gaussian weighting
        % check ncl documentation piece - wgt_areaave
    end
    
    % convert flux from gC/m^2/s to PgC/yr
    Aland = 1.4842895e+14; % surface area of land in meters^2
    d3 = 3.154e+7; % seconds/year   
    d4 = 1e-15; % grams/petagrams
    CLM45_2016(:,2) = fluxData1*Aland*d3*d4;
    
    clear lonData latData fluxData timeData date0 date1 LUdata LUinterp;
    
    % I'm getting something very interesting here, not sure why there's the
    % oscillations at every month
    % also deal with units - this arrives in grams C/m^2/sec
    

    
    
    

% Yue et al. (2018)
    % 1500-2005 | GtC/yr | annual
    LUdata = csvread('Yue_1500-2005.csv',1);
    LUinterp = (interp1(LUdata(:,1),LUdata(:,5),year));
    Yue2005 = [year, LUinterp*d];
    % annual 1500 to 2005
    % need first and 5th columns
    clear LUdata LUinterp;

% Yue et al. (2018) without age dynamics
    % 1500-2005 | GtC/yr | annual
    LUdata = csvread('Yue_1500-2005_noAgeDyn.csv',1);
    LUinterp = (interp1(LUdata(:,1),LUdata(:,5),year));
    Yue2005_noAge = [year, LUinterp*d];
    % annual 1500 to 2005
    % need first and 5th columns
    clear LUdata LUinterp;
    
% hansis 2015 (column B in file sent by J. Pongratz)
    % 1501-2012 | GtC/yr | annual
    % taking 1850, extending to 2015.5
    LUdata0 = csvread('BLUE_B_normalCdensities_Hansis2015.csv',349); %Hansis GCP
    LUdata1 = [LUdata0(:,1);end_year];
    LUdata2 = [LUdata0(:,2);LUdata0(length(LUdata0),2)];
    LUdata = [LUdata1 , LUdata2];
    LUinterp = (interp1(LUdata(:,1),LUdata(:,2),year));
    Hansis2015_B = [year, LUinterp*d];
    clear LUdata LUinterp;
    
% hansis 2015 (column C in file sent by J. Pongratz)
    % 1501-2012 | GtC/yr | annual
    % taking 1850, extending to 2015.5
    LUdata0 = csvread('BLUE_C_lowerCdensities_Hansis2015.csv',349); %Hansis GCP
    LUdata1 = [LUdata0(:,1);end_year];
    LUdata2 = [LUdata0(:,2);LUdata0(length(LUdata0),2)];
    LUdata = [LUdata1 , LUdata2];
    LUinterp = (interp1(LUdata(:,1),LUdata(:,2),year));
    Hansis2015_C = [year, LUinterp*d];
    clear LUdata LUinterp;
    
% hansis 2015 (column D in file sent by J. Pongratz)
    % 1849-2016 | GtC/yr | annual
    LUdata = csvread('BLUE_D_default_rangelandsAsPasture_GCP.csv'); %Hansis GCP
    LUinterp = (interp1(LUdata(:,1),LUdata(:,2),year));
    Hansis2015_D = [year, LUinterp*d];
    clear LUdata LUinterp;
    
% hansis 2015 (column E in file sent by J. Pongratz)
    % 1849-2016 | GtC/yr | annual
    LUdata = csvread('BLUE_E_default_rangelandsNotAsPasture.csv'); %Hansis GCP
    LUinterp = (interp1(LUdata(:,1),LUdata(:,2),year));
    Hansis2015_E = [year, LUinterp*d];
    clear LUdata LUinterp;
    
% hansis 2015 (column F in file sent by J. Pongratz)
    % 1849-2016 | GtC/yr | annual
    LUdata0 = csvread('BLUE_F_default_meanPasture.csv'); %Hansis GCP
    LUdata = LUdata0(1:168,:);
    LUinterp = (interp1(LUdata(:,1),LUdata(:,2),year));
    Hansis2015_F = [year, LUinterp*d];
    clear LUdata LUinterp;
    
% hansis 2015 (column G in file sent by J. Pongratz)
    % 1849-2016 | GtC/yr | annual
    LUdata = csvread('BLUE_G_defaultPlusPeat.csv'); %Hansis GCP
    LUinterp = (interp1(LUdata(:,1),LUdata(:,2),year));
    Hansis2015_G = [year, LUinterp*d];
    clear LUdata LUinterp;
    
% hansis 2015 (column H in file sent by J. Pongratz)
    % 1849-2016 | GtC/yr | annual
    LUdata = csvread('BLUE_H_defaultNotPasture_plusPeat.csv'); %Hansis GCP
    LUinterp = (interp1(LUdata(:,1),LUdata(:,2),year));
    Hansis2015_H = [year, LUinterp*d];
    clear LUdata LUinterp;
    
% % hansis 2015 (column I in file sent by J. Pongratz)
%     % 1849-2016 | GtC/yr | annual
%     LUdata = csvread('BLUE_I_meanGH_GCP.csv'); %Hansis GCP
%     LUinterp = (interp1(LUdata(:,1),LUdata(:,2),year));
%     Hansis2015_I = [year, LUinterp*d];
%     clear LUdata LUinterp;

save('inputData','Boden2016','Houghton2017','Hansis2015_I','Houghton2003',...
    'ConstantLU','Constant2LU','GCP2017','Houghton2003low','CABLE2016',...
    'CABLE2016high','LPXBern2016_HYDE','LPXBern2016_LUH',...
    'ORCHIDEEMICT2016','OCN2016','CLM45_2016','Yue2005','Yue2005_noAge',...
    'Hansis2015_B','Hansis2015_C','Hansis2015_D','Hansis2015_E',...
    'Hansis2015_F','Hansis2015_G','Hansis2015_H')        

end

