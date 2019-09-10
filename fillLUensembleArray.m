% fillLUensembleArray.m
%
% sept 7 2019
%
% author: julia dohner
%
% fills cell array with relevant values for LU ensemble runs

function [LUensembleArray] = fillLUensembleArray(nLU)

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

for i=1:4
    if i == 1
        load Houghton_ensemble_10;
        load ('Houghton_errors_10');
        label = 'Houghton';
    elseif i == 2
        load BLUE_ensemble_10;
        load BLUE_errors_10;
        label = 'BLUE';
    elseif i == 3
        load Constant_ensemble_10;
        load Constant_errors_10;
        label = 'constant';
    else
        load CABLE_ensemble_10;
        load CABLE_errors_10;
        label = 'CABLE';
    end
    
    LUensembleArray(i+1,1) = {label};
    LUensembleArray(i+1,2) = {outputArray};
    LUensembleArray(i+1,3) = {errorArray};
    LUensembleArray(i+1,4) = {numCases};
    LUensembleArray(i+1,5) = {year};

    
end

end