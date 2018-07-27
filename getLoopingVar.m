% getLoopingVar.m
%
% July 26, 2018
% Julia Dohner
% 
% Sets indicdes of variables to be looped and vars to be held constant

function [LU_i,opt_i,Tdata_i,tempDep_i,varSST_i,timeConst_i,filtDecon_i,...
    fert_i,oceanUp_i,rowLabels] = getLoopingVar(vary,j);


    % which variable to loop through?
    % A = land use (13 cases)
    % B = optimization time frame (10 cases)
    % C = temperature record (4 cases)
    % D = fixed vs var T (2 cases)
    % E = fixed vs var SST (2 cases)
    % F = values for fast box time constant (6 cases)
    % G = filtering of residual from deconvolution (3 cases)

    if strcmp(vary,'A') % loop LU
        LU_i = j;
        opt_i = 1;
        Tdata_i = 8; % old temp record for debugging
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filtDecon_i = 1;
        fert_i = 1;
        oceanUp_i = 1;
        rowLabels = {'Houghton 2017';'Hansis 2015';'Houghton 2003';'Constant';...
        'Constant*2';'GCP';'Houghton 2003 low';...
        'CABLE';'CABLE high';'LPX HYDE';'LPX LUH';'ORCHIDEE-MICT';'OC-N'}; %;...
        %'CLM45';'Yue 2018';'Yue 2018 noAge'};
    elseif strcmp(vary,'B') % loop opt time frame
        LU_i = 1;
        opt_i = j;
        Tdata_i = 1;
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filtDecon_i = 1;
        fert_i = 1;
        oceanUp_i = 1;
    elseif strcmp(vary,'C') % loop temp record
        LU_i = 1;
        opt_i = 1;
        Tdata_i = j;
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filtDecon_i = 1;
        fert_i = 1;
        oceanUp_i = 1;
    elseif strcmp(vary, 'D') % loop fixed vs variable T
        LU_i = 1;
        opt_i = 1;
        Tdata_i = 1;
        tempDep_i = j;
        varSST_i = 1;
        timeConst_i = 1;
        filtDecon_i = 1;
        fert_i = 1;
        oceanUp_i = 1;
    elseif strcmp(vary,'E') % loop fixed vs variable SST 
        LU_i = 1;
        opt_i = 1;
        Tdata_i = 1;
        tempDep_i = 1;
        varSST_i = j;
        timeConst_i = 1;
        filtDecon_i = 1;
        fert_i = 1;
        oceanUp_i = 1;
    elseif strcmp(vary,'F') % loop time constant values
        LU_i = 1;
        opt_i = 1;
        Tdata_i = 1;
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = j;
        filtDecon_i = 1;
        fert_i = 1;
        oceanUp_i = 1;
    elseif strcmp(vary,'G') % loop filtering of deconvolution residual
        LU_i = 1;
        opt_i = 1;
        Tdata_i = 1;
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filtDecon_i = j;
        fert_i = 1;
        oceanUp_i = 1;
    elseif strcmp(vary,'H') % loop ocean uptake
        LU_i = 1;
        opt_i = 1;
        Tdata_i = 1;
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filtDecon_i = 1;
        fert_i = j;
        oceanUp_i = 1;
    elseif strcmp(vary,'I') % loop co2 vs N fert
        LU_i = 1;
        opt_i = 1;
        Tdata_i = 1;
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filtDecon_i = 1;
        fert_i = 1;
        oceanUp_i = j;
    end

end
