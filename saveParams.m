% saveParams.m
%
% june 29, 2018
%
% script to package and output parameters from forwardDriver fitting 
% (epsilon and Q10)

function saveParams(tempDep,end_year,end_year_plot,landusedata,atmcalc2,obsCalcDiff,Q1,epsilon,year)


if end_year == 2015.5 && end_year_plot == 2015.5 && strcmp(landusedata,'const2')
    if tempDep == 1 
            Vpresent_constant2_co2 = atmcalc2;
            Vpresent_constant2_resid = obsCalcDiff;
            Vpresent_constant2_q10 = Q1;
            Vpresent_constant2_eps = epsilon;
            Vpresent_constant2_year = year;
            save('timeframe_constant2_presentV','Vpresent_constant2_co2','Vpresent_constant2_resid',...
                'Vpresent_constant2_q10','Vpresent_constant2_eps','Vpresent_constant2_year')
    elseif tempDep == 0
            Cpresent_constant2_co2 = atmcalc2;
            Cpresent_constant2_resid = obsCalcDiff;
            Cpresent_constant2_q10 = Q1;
            Cpresent_constant2_eps = epsilon;
            Cpresent_constant2_year = year;
            save('timeframe_constant2_presentC','Cpresent_constant2_co2','Cpresent_constant2_resid',...
                'Cpresent_constant2_q10','Cpresent_constant2_eps','Cpresent_constant2_year')
    end

end
        %%
        


if end_year == 2005.5 && end_year_plot == 2015.5
    if tempDep == 1
        
        if strcmp(landusedata,'hough')
            V2005_hough_co2 = atmcalc2;
            V2005_hough_resid = obsCalcDiff;
            V2005_hough_q10 = Q1;
            V2005_hough_eps = epsilon;
            V2005_hough_year = year;
            save('timeframe_hough_2005V','V2005_hough_co2','V2005_hough_resid',...
                'V2005_hough_q10','V2005_hough_eps','V2005_hough_year')
            
        elseif strcmp(landusedata,'hansis')
            V2005_hansis_co2 = atmcalc2;
            V2005_hansis_resid = obsCalcDiff;
            V2005_hansis_q10 = Q1;
            V2005_hansis_eps = epsilon;
            V2005_hansis_year = year;
            save('timeframe_hansis_2005V','V2005_hansis_co2','V2005_hansis_resid',...
                'V2005_hansis_q10','V2005_hansis_eps','V2005_hansis_year')

        elseif strcmp(landusedata,'hough03')
            V2005_hough03_co2 = atmcalc2;
            V2005_hough03_resid = obsCalcDiff;
            V2005_hough03_q10 = Q1;
            V2005_hough03_eps = epsilon;
            V2005_hough03_year = year;
            save('timeframe_hough03_2005V','V2005_hough03_co2','V2005_hough03_resid',...
                'V2005_hough03_q10','V2005_hough03_eps','V2005_hough03_year')
      
        elseif strcmp(landusedata,'const')
            V2005_constant_co2 = atmcalc2;
            V2005_constant_resid = obsCalcDiff;
            V2005_constant_q10 = Q1;
            V2005_constant_eps = epsilon;
            V2005_constant_year = year;
            save('timeframe_constant_2005V','V2005_constant_co2','V2005_constant_resid',...
                'V2005_constant_q10','V2005_constant_eps','V2005_constant_year')
        
        elseif strcmp(landusedata,'const2')
            V2005_constant2_co2 = atmcalc2;
            V2005_constant2_resid = obsCalcDiff;
            V2005_constant2_q10 = Q1;
            V2005_constant2_eps = epsilon;
            V2005_constant2_year = year;
            save('timeframe_constant2_2005V','V2005_constant2_co2','V2005_constant2_resid',...
                'V2005_constant2_q10','V2005_constant2_eps','V2005_constant2_year')
   
        
        end
    elseif tempDep == 0
               
        if strcmp(landusedata,'hough')
            C2005_hough_co2 = atmcalc2;
            C2005_hough_resid = obsCalcDiff;
            C2005_hough_q10 = Q1;
            C2005_hough_eps = epsilon;
            C2005_hough_year = year;
            save('timeframe_hough_2005C','C2005_hough_co2','C2005_hough_resid',...
                'C2005_hough_q10','C2005_hough_eps','C2005_hough_year')
            
        elseif strcmp(landusedata,'hansis')
            C2005_hansis_co2 = atmcalc2;
            C2005_hansis_resid = obsCalcDiff;
            C2005_hansis_q10 = Q1;
            C2005_hansis_eps = epsilon;
            C2005_hansis_year = year;
            save('timeframe_hansis_2005C','C2005_hansis_co2','C2005_hansis_resid',...
                'C2005_hansis_q10','C2005_hansis_eps','C2005_hansis_year')
 
        elseif strcmp(landusedata,'hough03')
            C2005_hough03_co2 = atmcalc2;
            C2005_hough03_resid = obsCalcDiff;
            C2005_hough03_q10 = Q1;
            C2005_hough03_eps = epsilon;
            C2005_hough03_year = year;
            save('timeframe_hough03_2005C','C2005_hough03_co2','C2005_hough03_resid',...
                'C2005_hough03_q10','C2005_hough03_eps','C2005_hough03_year')
      
        elseif strcmp(landusedata,'const')
            C2005_constant_co2 = atmcalc2;
            C2005_constant_resid = obsCalcDiff;
            C2005_constant_q10 = Q1;
            C2005_constant_eps = epsilon;
            C2005_constant_year = year;
            save('timeframe_constant_2005C','C2005_constant_co2','C2005_constant_resid',...
                'C2005_constant_q10','C2005_constant_eps','C2005_constant_year')
            
        elseif strcmp(landusedata,'const2')
            C2005_constant2_co2 = atmcalc2;
            C2005_constant2_resid = obsCalcDiff;
            C2005_constant2_q10 = Q1;
            C2005_constant2_eps = epsilon;
            C2005_constant2_year = year;
            save('timeframe_constant2_2005C','C2005_constant2_co2','C2005_constant2_resid',...
                'C2005_constant2_q10','C2005_constant2_eps','C2005_constant2_year')
        end

    end
end

% 
% 
% if strcmp(landusedata,'hough')
%     if tempDep == 1
%         %if end_year == 2015.5
%         %    save('timeframe_presentV','obsCalcDiff','atmcalc2','Q1','epsilon','year')
%         if end_year == 2005.5
%             V2005_hough_co2 = atmcalc2;
%             V2005_hough_resid = obsCalcDiff;
%             V2005_hough_q10 = Q1;
%             V2005_hough_eps = epsilon;
%             V2005_hough_year = year;
%             save('timeframe_hough_2005V','obsCalcDiff','atmcalc2','Q1','epsilon','year')
% %         elseif end_year == 1995.5
% %             save('timeframe_1995V','obsCalcDiff','atmcalc2','Q1','epsilon','year')
% %         elseif end_year == 1975.5
% %             save('timeframe_1975V','obsCalcDiff','atmcalc2','Q1','epsilon','year')
%         end
%     elseif tempDep == 0
%         if end_year == 2015.5
%             save('timeframe_presentC','obsCalcDiff','atmcalc2','Q1','epsilon','year')
%         elseif end_year == 2005.5
%             save('timeframe_2005C','obsCalcDiff','atmcalc2','Q1','epsilon','year')
%         elseif end_year == 1995.5
%             save('timeframe_1995C','obsCalcDiff','atmcalc2','Q1','epsilon','year')
%         elseif end_year == 1975.5
%             save('timeframe_1975C','obsCalcDiff','atmcalc2','Q1','epsilon','year')
%         end
%     end
%         
% end

    
