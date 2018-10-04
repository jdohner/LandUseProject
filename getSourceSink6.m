% getSourceSink6.m
%
% July 27, 2018
% Julia Dohner
%
% Updated version of previous GSS5, but instead loads saved variables from
% saveInputData rather than loading the files each time
%
% gss version that uses most recent values for FF (Boden 2017, GCPv1.3) and 
% land use (Houghton 2015, personal comm.)
% 
% outputs are in ppm/yr

% getSourceSink5.m
%
% author: Lauren Rafelski, modified by Julia Dohner
% May 16, 2018
%
% gss version that uses most recent values for FF (Boden 2017, GCPv1.3) and 
% land use (Houghton 2015, personal comm.)
% 
% outputs are in ppm/yr

function [ff,LU] = getSourceSink6(LU_i);

load inputData.mat

ff = Boden2016;

% ff_paris = [Boden2016(:,1), Boden2016(:,2) ; 2020, 4.5 ; 2100 , 4.5];
% year_paris = 1850:(1/12):2100;
% ffParis_interp0 = (interp1(ff_paris(:,1),ff_paris(:,2),year_paris)).';
% ffParis_interp = [year_paris', ffParis_interp0];
% 
% ff = ffParis_interp;

if LU_i == 1 % Houghton 2017
    LU = Houghton2017;
    
elseif LU_i == 2 % hansis 2015
    LU = Hansis2015;

elseif LU_i == 3 % hough 03 (Rafelski "high land use")
    LU = Houghton2003;
        
elseif LU_i == 4 % constant land use case
    LU = ConstantLU;

elseif LU_i == 5 % constant*2 land use case
    LU = Constant2LU;

elseif LU_i == 6 % gcp
    % 1850-2016 | GtC/yr | annual
    LU = GCP2017;

elseif LU_i == 7 % hough 03 extratropical ("LR low")
    % 1850-2016 | GtC/yr | monthly
    LU = Houghton2003low;
    
elseif LU_i == 8 % 8 = CABLE (GCP)
    % 1850-2016 | GtC/yr | annual
    LU = CABLE2016;

elseif LU_i == 9 % CABLE higher, grazing & harvest (C loss)
    % 1850-2016 | GtC/yr | annual
    LU = CABLE2016high;

elseif LU_i == 10 % LPX-Bern HYDE
    % 1850-2016 | GtC/yr | annual
    LU = LPXBern2016_HYDE;

elseif LU_i == 11 % LPX-Bern LUH
    % 1850-2016 | GtC/yr | annual
    LU = LPXBern2016_LUH;
    
elseif LU_i == 12 % ORCHIDEE-MICT
    % 1850-2016 | GtC/yr | annual
    LU = ORCHIDEEMICT2016;

elseif LU_i == 13 % OC-N
    % 1860-2016 | GtC/yr | annual
    LU = OCN2016;
    
elseif LU_i == 14 % CLM4.5 TODO
    LU = CLM45_2016; 

elseif LU_i == 15 % Yue et al. (2018)
    % 1500-2005 | GtC/yr | annual
    LU = Yue2005;

elseif LU_i == 16 % Yue et al. (2018) without age dynamics
    % 1500-2005 | GtC/yr | annual
    LU = Yue2005_noAge;
    
        
end

end