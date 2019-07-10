% getSourceSink6_wNoise.m
%
% July 10,2019
% Julia Dohner
%
% Updated version of previous GSS5, but instead loads saved variables from
% saveInputData rather than loading the files each time
%
% gss version that uses most recent values for FF (Boden 2017, GCPv1.3) and 
% land use (Houghton 2015, personal comm.)
% 
% outputs are in ppm/yr
%
% July 10, 2019:
% Same as GSS6, but including functionality for adding noise to FF record
% as in Anderegg et al. (2015)



function [ff,LU] = getSourceSink6_wNoise(LU_i,BLUE_i,vary)

load inputData.mat

% option to generate noisy FF record
if strcmp(vary,'N')
    [ff] = getNoisyCO2a(Boden2016);
else 
    ff = Boden2016;
end



if strcmp(vary,'M') == 0

    if LU_i == 1 % Houghton 2017
        LU = Houghton2017;

    elseif LU_i == 2 % hansis 2015
        LU = Hansis2015_I;

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
    
elseif strcmp(vary,'M') == 1
    
    if BLUE_i == 1
        LU = Houghton2017;
        
    elseif BLUE_i == 2
        LU = Hansis2015_B;
        
    elseif BLUE_i == 3
        LU = Hansis2015_C;
        
    elseif BLUE_i == 4
        LU = Hansis2015_D;
        
    elseif BLUE_i == 5
        LU = Hansis2015_E;

    elseif BLUE_i == 6
        LU = Hansis2015_F;
        
    elseif BLUE_i == 7
        LU = Hansis2015_G;
        
    elseif BLUE_i == 8
        LU = Hansis2015_H;
        
    elseif BLUE_i == 9
        LU = Hansis2015_I;
        
    end

end

end