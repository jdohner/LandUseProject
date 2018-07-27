% bioboxtwo.m
%
% functionality of bioboxtwo_sub10 & subN combined into one script
%
% July 26, 2018
% Julia Dohner
%
% TODO: add in FF for the N fertilization - would need to save and load FF
% from driver code

function [C1dt,C2dt,delCdt,delC1,delC2] = bioboxtwo(eps,Q1a,Q2a,...
    ts,year,dpCO2a,T,ff)

T0 = T(1,2);
dt = 1/ts;

% Define box sizes in ppm

Catm = 600/2.12; % around 283 ppm (preindustrial)
C1 = 110/2.12; % fast biosphere box, from old model
C2 = 1477/2.12; % slow biosphere box, changed to be same as 1 box

% Rate constants
K1a = 1/2.5; 
Ka1 = K1a*C1/Catm;
K2a = 1/60; % slow box to atmosphere
Ka2 = K2a*C2/Catm;

% set up arrays
% delC1 = [year(:,1) zeros(size(year))];
% delC2 = [year(:,1) zeros(size(year))];
% delCdt = year;
% C1dt = year;
% C2dt = year;
% delC1 = year(length(year),1)+dt;
% delC2 = year(length(year),1)+dt;

% set up arrays

delC1 = [year(:,1) zeros(size(year))];
delC2 = [year(:,1) zeros(size(year))];
delCdt(:,1) = year;
C1dt(:,1) = year;
C2dt(:,1) = year;
delC1(length(year)+1,1) = year(length(year),1)+dt;
delC2(length(year)+1,1) = year(length(year),1)+dt;



if fert_i == 1
% this loop is the same as in oceanpulseresponse- need to be the same as in
% ocean pulse response in higher level code, then call next what's below
    
    for ii = 1:length(year)
        % fast box (equation (3) in Rafelski 2009
        % calculate land uptake by fast box

        % nonlinear
        % need log of current co2 / preindustrial - load co2a and co2_preind as
        % vars

        % T-dependent respiration
        % fast box
        C1dt(ii,2) = Ka1*(Catm + eps*dpCO2a(ii,2)) - ...
            K1a*Q1a^((T(ii,2)-T0)/10)*(C1 + delC1(ii,2)); 

        % slow box (equation (3) in Rafelski 2009
        C2dt(ii,2) = Ka2*(Catm + eps*dpCO2a(ii,2)) - ...
            K2a*Q2a^((T(ii,2)-T0)/10)*(C2 + delC2(ii,2)); 

        % T-dependent photosynthesis
        % C1dt(i,2) = Ka1*(Catm + eps*dpCO2a(i,2))*(1 + Q1a*(T(i,2)-T0)) - ...
        %   K1a*(C1 + delC1(i,2)); % temperature-dependent photosynthesis
        % C2dt(i,2) = Ka2*(Catm + eps*dpCO2a(i,2))*(1 + Q2a*(T(i,2)-T0)) - ...
        %   K2a*(C2 + delC2(i,2)); % temperature dependent photosynthesis   

        % box total change in concentrations (of fast, slow box, respectively)
        delC1(ii+1,2) = sum(C1dt(:,2))*dt;
        delC2(ii+1,2) = sum(C2dt(:,2))*dt;

        % total flux into land    
        delCdt(ii,2) = C2dt(ii,2) + C1dt(ii,2);

    end

elseif fert_i == 2
    
    a = find(ff1(:,1) == year(1));
    
    for m = 1:length(year)-1
        % T-dependent respiration

        % fast box - equation (2) in Rafelski 2009
        C1dt(m,2) = Ka1*Catm*(1 + eps*dpCO2a(m,2)/Catm + ...
            gamma*ff1(m+a-1,2)) - K1a*Q1a^((T(m,2)-T0)/10)*(C1 + delC1(m,2));    
        % slow box - equation (2) in Rafelski 2009  
        C2dt(m,2) = Ka2*Catm*(1 + eps*dpCO2a(m,2)/Catm + ...
            gamma*ff1(m+a-1,2)) - K2a*Q2a^((T(m,2)-T0)/10)*(C2 + delC2(m,2));


        % T-dependent photosynthesis
        % fast box 
        % C1dt(m,2) = Ka1*Catm*(1 + eps*dpCO2a(m,2)/Catm + ...
        % gamma*ff1(m+a-1,2))*(1 + Q1a*(T(m,2)-T0)) - K1a*(C1 + delC1(m,2)); 
        % slow box
        % C2dt(m,2) = Ka2*Catm*(1 + eps*dpCO2a(m,2)/Catm + ...
        % gamma*ff1(m+a-1,2))*(1 + Q2a*(T(m,2)-T0)) - K2a*(C2 + delC2(m,2));

        % box total change in concentrations    
        delC1(m+1,2) = sum(C1dt(:,2))*dt;
        delC2(m+1,2) = sum(C2dt(:,2))*dt;

        % total flux into land    
        delCdt(m,2) = C2dt(m,2) + C1dt(m,2);

    end 
    
    
end


