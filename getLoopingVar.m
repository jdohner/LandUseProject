% getLoopingVar.m
%
% July 26, 2018
% Julia Dohner
% 
% Sets indicdes of variables to be looped and vars to be held constant

function [LU_i,opt_i,Tdata_i,tempDep_i,varSST_i,timeConst_i,filt_i,...
    fert_i,oceanUp_i,photResp_i,zeroBio_i,Tstep_i,BLUE_i,ensemble_i,...
    rowLabels] = getLoopingVar(vary,j,scheme);


    % which variable to loop through?
    % A = land use (13 cases)
    % B = optimization time frame (10 cases)
    % C = temperature record (4 cases)
    % D = fixed vs var T (2 cases)
    % E = fixed vs var SST (2 cases)
    % F = values for fast box time constant (6 cases)
    % G = filtering of residual from deconvolution (3 cases)
    % H = high medium or low ocean uptake (3 cases)
    % I = co2 vs N fert (2 cases)
    % J = t-dependent photosynthesis or respiration (2 cases)
    % K = cancel out eps, delcdt, both
    % L = loop temperature step records
    % M = loop Houghton, BLUE cases
    % N = generate new ensemble member (randomly pick from CO2a,FF,ocean)

    if strcmp(vary,'A') % loop LU
        LU_i = j;
        opt_i = 1;
        Tdata_i = 1; % old temp record for debugging
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filt_i = 1;
        fert_i = 1;
        oceanUp_i = 1;
        photResp_i = 1;
        zeroBio_i = 1;
        Tstep_i = 1;
        BLUE_i = 1;
        ensemble_i = 1;
        rowLabels = {'H&N 2017';'Hansis 2015';'Constant';'H&N 2003';...
        'Constant*2';'GCP';'H&N 2003 low';...
        'CABLE';'CABLE high';'LPX HYDE';'LPX LUH';'ORCHIDEE-MICT';'OC-N'}; %;...
        %'CLM45';'Yue 2018';'Yue 2018 noAge'};
    elseif strcmp(vary,'B') % loop opt time frame
        LU_i = 1;
        opt_i = j;
        Tdata_i = 2;
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filt_i = 1;
        fert_i = 1;
        oceanUp_i = 1;
        photResp_i = 1;
        zeroBio_i = 1;
        Tstep_i = 1;
        BLUE_i = 1;
        ensemble_i = 1;
        rowLabels = {'1900-2010.5','1900-2005.5','1959-2010.5','1959-2000.5'};
    elseif strcmp(vary,'C') % loop temp record
        LU_i = 1;
        opt_i = 1;
        Tdata_i = j;
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filt_i = 1;
        fert_i = 1;
        oceanUp_i = 1;
        photResp_i = 1;
        zeroBio_i = 1;
        Tstep_i = 1;
        BLUE_i = 1;
        ensemble_i = 1;
        rowLabels = {'LR debug','HadCRUT4','CRUTEM4','CRUTEM4v','Nino 3.4'};
        % 'Tropical T','Global Historical Climate Network','MLOST 3.5',..
        % '
    elseif strcmp(vary, 'D') % loop fixed vs variable T
        LU_i = 2; % 2 for Hansis BLUE
        opt_i = 1; % 1 for 1900-2010.5, 3 for 1959-2010.5
        Tdata_i = 1; % 1 for simliar to LR, 3 for updated land temps
        tempDep_i = j;
        varSST_i = 1;
        timeConst_i = 1;
        filt_i = 1; % 1 for 10yr filt, 2 for 1-yr filt, 3 for unfilt
        fert_i = 1;
        oceanUp_i = 1;
        photResp_i = 1;
        zeroBio_i = 1;
        Tstep_i = 1;
        BLUE_i = 1;
        ensemble_i = 1;
        rowLabels = {'Variable T','Fixed T'};
    elseif strcmp(vary,'E') % loop fixed vs variable SST 
        LU_i = 1;
        opt_i = 1;
        Tdata_i = 1;
        tempDep_i = 1;
        varSST_i = j;
        timeConst_i = 1;
        filt_i = 1;
        fert_i = 1;
        oceanUp_i = 1;
        photResp_i = 1;
        zeroBio_i = 1;
        Tstep_i = 1;
        BLUE_i = 1;
        ensemble_i = 1;
        rowLabels = {'Fixed SST','Variable SST'};
    elseif strcmp(vary,'F') % loop time constant values
        LU_i = 1;
        opt_i = 1;
        Tdata_i = 1;
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = j;
        filt_i = 1;
        fert_i = 1;
        oceanUp_i = 1;
        photResp_i = 1;
        zeroBio_i = 1;
        Tstep_i = 1;
        BLUE_i = 1;
        ensemble_i = 1;
        rowLabels = {'Tconst/1','Tconst/2','Tconst/4','Tconst/8',...
            'Tconst/100'};
    elseif strcmp(vary,'G') % loop filtering of deconvolution residual
        LU_i = 1;
        opt_i = 3; % 1 for 1900-2010.5, 3 for 1959-2010.5
        Tdata_i = 1;
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filt_i = j; % 1 for 10yr filt, 2 for 1-yr filt, 3 for unfilt
        fert_i = 1;
        oceanUp_i = 1;
        photResp_i = 1;
        zeroBio_i = 1;
        Tstep_i = 1;
        BLUE_i = 1;
        ensemble_i = 1;
        rowLabels = {'10-year Filter','1-year Filter','Unfiltered',...
            'Unfilt-filt 10-year','Unfilt-filt 1-year'};
    elseif strcmp(vary,'H') % loop ocean uptake
        LU_i = 1;
        opt_i = 1;
        Tdata_i = 1;
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filt_i = 1;
        fert_i = 1;
        oceanUp_i = j;
        photResp_i = 1;
        zeroBio_i = 1;
        Tstep_i = 1;
        BLUE_i = 1;
        ensemble_i = 1;
        rowLabels = {'Med Ocean Uptake','Low Ocean Uptake','High Ocean Uptake'};
    elseif strcmp(vary,'I') % loop co2 vs N fert
        LU_i = 1;
        opt_i = 3;
        Tdata_i = 1;
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filt_i = 1;
        fert_i = j;
        oceanUp_i = 1;
        photResp_i = 1;
        zeroBio_i = 1;
        Tstep_i = 1;
        BLUE_i = 1;
        ensemble_i = 1;
        rowLabels = {'CO2-fert','N-fert'};
    elseif strcmp(vary,'J') % loop temp-dependent photosynthesis or respiration
        LU_i = 1;
        opt_i = 1;
        Tdata_i = 1;
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filt_i = 1;
        fert_i = 1;
        oceanUp_i = 1;
        photResp_i = j;
        zeroBio_i = 1;
        Tstep_i = 1;
        BLUE_i = 1;
        ensemble_i = 1;
        rowLabels = {'T-dep Respiration','T-dep Photosynthesis'};
    
    elseif strcmp(vary,'K') % loop zeroing out eps, ?Ci, both
        LU_i = 1;
        opt_i = 1; % 1 for 1900-2010.5, 3 for 1959-2010.5
        Tdata_i = 1; % 1 for simliar to LR, 3 for updated land temps
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filt_i = 1; % 1 for 10yr filt, 2 for 1-yr filt, 3 for unfilt
        fert_i = 1;
        oceanUp_i = 1;
        photResp_i = 1;
        zeroBio_i = j;
        Tstep_i = 1;
        BLUE_i = 1;
        ensemble_i = 1;
        rowLabels = {'Baseline','Epsilon = 0','\DeltaC_i = 0','Q_1_0 = 1'};
    
        
    elseif strcmp(vary,'L') % loop temperature step records
        LU_i = 1;
        opt_i = 1; % 1 for 1900-2010.5, 3 for 1959-2010.5
        Tdata_i = 1; % 1 for simliar to LR, 3 for updated land temps
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filt_i = 1; % 1 for 10yr filt, 2 for 1-yr filt, 3 for unfilt
        fert_i = 1;
        oceanUp_i = 1;
        photResp_i = 1;
        zeroBio_i = 1;
        Tstep_i = j;
        BLUE_i = 1;
        ensemble_i = 1;
        rowLabels = {'1 at 1975-','1 from 1975-1995','15 at 1975-','15 from 1975-1995'};
    
    
    elseif strcmp(vary,'M') % loop BLUE LULCC emissions records
        LU_i = 1;
        opt_i = 1; % 1 for 1900-2010.5, 3 for 1959-2010.5
        Tdata_i = 1; % 1 for simliar to LR, 3 for updated land temps
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filt_i = 1; % 1 for 10yr filt, 2 for 1-yr filt, 3 for unfilt
        fert_i = 1;
        oceanUp_i = 1;
        photResp_i = 1;
        zeroBio_i = 1;
        Tstep_i = 1;
        BLUE_i = j;
        ensemble_i = 1;
        rowLabels = {'H&N 2017','B','C','D','E','F','G','H','I'};
        
    elseif strcmp(vary,'N') % loop to generate ensemble members
        LU_i = 2;
        if strcmp(scheme,'aa')
            opt_i = 1;
        elseif strcmp(scheme,'bb')
            opt_i = 3;
        end
        %opt_i = 3; % 1 for 1900-2010.5, 3 for 1958-2010.5
        Tdata_i = 3; % 1 for simliar to LR, 3 for updated land temps
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filt_i = 1; % 1 for 10yr filt, 2 for 1-yr filt, 3 for unfilt
        fert_i = 1;
        oceanUp_i = 1;
        photResp_i = 1;
        zeroBio_i = 1;
        Tstep_i = 1;
        BLUE_i = 1;
        ensemble_i = j;
        rowLabels = {'Member 1','Member 2','Member 3','Member 4',...
            'Member 5','Member 6','Member 7','Member 8','Member 9',...
            'Member 10'};
    
    end
    
    

end
