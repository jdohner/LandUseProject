% fillLUensembleArray.m
%
% sept 7 2019
%
% author: julia dohner
%
% fills cell array with relevant values for LU ensemble runs

function [LUensembleArray] = fillLUensembleArray(nLU,nEnsemble,scheme)

LUensembleArray = cell(nLU+1,5);
LUensembleArray(1,:) = {'LU case','outputArray','errorArray',...
    'numCases','year'};

% for i=1:4
%     if i == 1
%         load Houghton_ensemble_500aa_2;
%         load Houghton_errors_500aa_2;
%         label = 'Houghton';
%     elseif i == 2
%         load BLUE_ensemble_500aa_2;
%         load BLUE_errors_500aa_2;
%         label = 'BLUE';
%     elseif i == 3
%         load Constant_ensemble_500aa_2;
%         load Constant_errors_500aa_2;
%         label = 'constant';
%     else
%         load CABLE_ensemble_500aa_2;
%         load CABLE_errors_500aa_2;
%         label = 'CABLE';
    %end

for i=1:nLU
    if i == 1
        if nEnsemble == 10
            if strcmp(scheme,'aa')
                load H&N_ensemble_10aa;
            elseif strcmp(scheme,'bb')
                load H&N_ensemble_10bb;
            end
        elseif nEnsemble == 500
            if strcmp(scheme,'aa')
                load H&N_ensemble_500aa;
            elseif strcmp(scheme,'bb')
                load H&N_ensemble_10aa;
            end
        elseif nEnsemble == 1000
            if strcmp(scheme,'aa')
                load H&N_ensemble_1000aa;
            elseif strcmp(scheme,'bb')
                load H&N_ensemble_1000bb;
            end
        end
        label = 'H&N';
        
    elseif i == 2
        if nEnsemble == 10
            if strcmp(scheme,'aa')
                load BLUE_ensemble_10aa;
            elseif strcmp(scheme,'bb')
                load BLUE_ensemble_10bb;
            end
        elseif nEnsemble == 500
            if strcmp(scheme,'aa')
                load BLUE_ensemble_500aa;
            elseif strcmp(scheme,'bb')
                load BLUE_ensemble_10aa;
            end
        elseif nEnsemble == 1000
            if strcmp(scheme,'aa')
                load BLUE_ensemble_1000aa;
            elseif strcmp(scheme,'bb')
                load BLUE_ensemble_1000bb;
            end
        end
        label = 'BLUE';
        
    elseif i == 3
        if nEnsemble == 10
            if strcmp(scheme,'aa')
                load Constant_ensemble_10aa;
            elseif strcmp(scheme,'bb')
                load Constant_ensemble_10bb;
            end
        elseif nEnsemble == 500
            if strcmp(scheme,'aa')
                load Constant_ensemble_500aa;
            elseif strcmp(scheme,'bb')
                load Constant_ensemble_10aa;
            end
        elseif nEnsemble == 1000
            if strcmp(scheme,'aa')
                load Constant_ensemble_1000aa;
            elseif strcmp(scheme,'bb')
                load Constant_ensemble_1000bb;
            end
        end
        label = 'constant';
    else
        if nEnsemble == 10
            if strcmp(scheme,'aa')
                load CABLE_ensemble_10aa;
            elseif strcmp(scheme,'bb')
                load CABLE_ensemble_10bb;
            end
        elseif nEnsemble == 500
            if strcmp(scheme,'aa')
                load CABLE_ensemble_500aa;
            elseif strcmp(scheme,'bb')
                load CABLE_ensemble_10aa;
            end
        elseif nEnsemble == 1000
            if strcmp(scheme,'aa')
                load CABLE_ensemble_1000aa;
            elseif strcmp(scheme,'bb')
                load CABLE_ensemble_1000bb;
            end
        end
        label = 'CABLE';
    end

    

    LUensembleArray(i+1,1) = {label};
    LUensembleArray(i+1,2) = {outputArray};
    LUensembleArray(i+1,3) = {errorArray};
    LUensembleArray(i+1,4) = {numCases};
    LUensembleArray(i+1,5) = {year};

end

end