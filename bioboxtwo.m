% bioboxtwo.m
%
% functionality of bioboxtwo_sub10 & subN combined into one script
%
% July 26, 2018
% Julia Dohner


function [C1dt,C2dt,delCdt,delC1,delC2] = bioboxtwo(epsilon,Q1,Q2,ts,year,...
    dpCO2a,T,gamma,photResp_i,timeConst_i)

load ff;

T0 = T(1,2);
dt = 1/ts;

multiplier = 1;
% cutting rate constants for fast box
if timeConst_i == 2
   multiplier = 2;
elseif timeConst_i == 3
    multiplier = 4;
elseif timeConst_i == 4
    multiplier = 8;
elseif timeConst_i == 5
    multiplier = 100;
end


% Define box sizes in ppm

Catm = 600/2.12; % around 283 ppm (preindustrial)
C1 = (110/2.12)*multiplier; % fast biosphere box, from old model
C2 = 1477/2.12; % slow biosphere box, changed to be same as 1 box

% Rate constants

K1a = 1/(2.5*multiplier); 
Ka1 = K1a*C1/Catm; 

% % cutting rate constants for fast box
% if timeConst_i == 2
%     K1a = K1a*(1/2);
%     %Ka1 = Ka1*(1/2);
% elseif timeConst_i == 3
%     K1a = K1a*(1/4);
%     %Ka1 = Ka1*(1/4);
% elseif timeConst_i == 4
%     K1a = K1a*(1/8);
%     %Ka1 = Ka1*(1/8);
% elseif timeConst_i == 5
%     K1a = K1a*(1/16);
%     %Ka1 = Ka1*(1/16);
% % elseif timeConst_i == 6
% %     K1a = K1a*(1);
% %     Ka1 = Ka1*(1);
% end

K2a = 1/60; % slow box to atmosphere
Ka2 = K2a*C2/Catm;

% set up arrays
delC1 = [year(:,1) zeros(size(year))];
delC2 = [year(:,1) zeros(size(year))];
delCdt(:,1) = year;
C1dt(:,1) = year;
C2dt(:,1) = year;
delC1(length(year)+1,1) = year(length(year),1)+dt;
delC2(length(year)+1,1) = year(length(year),1)+dt;

a = find(ff(:,1) == year(1));

for ii = 1:length(year)
    % fast box (equation (3) in Rafelski 2009
    % calculate land uptake by fast box

    % nonlinear
    % need log of current co2 / preindustrial - load co2a and co2_preind as
    % vars

    % T-dependent respiration
    if photResp_i == 1
        % fast box
        C1dt(ii,2) = Ka1*(Catm + 0*epsilon*dpCO2a(ii,2) + gamma*ff(ii+a-1,2)*Catm) - ...
        K1a*Q1^((T(ii,2)-T0)/10)*(C1 + delC1(ii,2)); 

        % slow box (equation (3) in Rafelski 2009
        C2dt(ii,2) = Ka2*(Catm + epsilon*dpCO2a(ii,2)+ gamma*ff(ii+a-1,2)*Catm) - ...
        K2a*Q2^((T(ii,2)-T0)/10)*(C2 + delC2(ii,2)); 

    elseif photResp_i == 2
        %T-dependent photosynthesis
        C1dt(ii,2) = Ka1*(Catm + epsilon*dpCO2a(ii,2)+ gamma*ff(ii+a-1,2)*Catm)...
            *(1 + Q1*(T(ii,2)-T0)) - K1a*(C1 + delC1(ii,2));
        % - K1a*Q1a^((T(ii,2)-T0)/10)*(C1 + delC1(ii,2)); 

      
        C2dt(ii,2) = Ka2*(Catm + epsilon*dpCO2a(ii,2)+ gamma*ff(ii+a-1,2)*Catm)...
            *(1 + Q2*(T(ii,2)-T0)) -  K2a*(C2 + delC2(ii,2)); 
        % - K2a*Q2a^((T(ii,2)-T0)/10)*(C2 + delC2(ii,2)); 

    end
    
    % box total change in concentrations (of fast, slow box, respectively)
    delC1(ii+1,2) = sum(C1dt(:,2))*dt;
    delC2(ii+1,2) = sum(C2dt(:,2))*dt;

    % total flux into land    
    delCdt(ii,2) = C2dt(ii,2) + C1dt(ii,2);

end


    
end


