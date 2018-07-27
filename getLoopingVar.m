% getLoopingVar.m
%
% July 26, 2018
% Julia Dohner
% 
% Sets indicdes of variables to be looped and vars to be held constant

function [LU_i,opt_i,Tdata_i,tempDep_i,varSST_i,timeConst_i,filtDecon_i]...
    = getLoopingVar(vary,j);


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
    elseif strcmp(vary,'B') % loop opt time frame
        LU_i = 1;
        opt_i = j;
        Tdata_i = 1;
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filtDecon_i = 1;
    elseif strcmp(vary,'C') % loop temp record
        LU_i = 1;
        opt_i = 1;
        Tdata_i = j;
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filtDecon_i = 1;
    elseif strcmp(vary, 'D') % loop fixed vs variable T
        LU_i = 1;
        opt_i = 1;
        Tdata_i = 1;
        tempDep_i = j;
        varSST_i = 1;
        timeConst_i = 1;
        filtDecon_i = 1;
    elseif strcmp(vary,'E') % loop fixed vs variable SST 
        LU_i = 1;
        opt_i = 1;
        Tdata_i = 1;
        tempDep_i = 1;
        varSST_i = j;
        timeConst_i = 1;
        filtDecon_i = 1;
    elseif strcmp(vary,'F') % loop time constant values
        LU_i = 1;
        opt_i = 1;
        Tdata_i = 1;
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = j;
        filtDecon_i = 1;
    elseif strcmp(vary,'G') % loop filtering of deconvolution residual
        LU_i = 1;
        opt_i = 1;
        Tdata_i = 1;
        tempDep_i = 1;
        varSST_i = 1;
        timeConst_i = 1;
        filtDecon_i = j;
    end

end
