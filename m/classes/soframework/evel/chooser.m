%> Model chooser based on times and rates matrices
%>
%> Determines the best compromise between accuracy and times
%>
%>
classdef chooser < chooser_base
    % Setup
    properties
        %> =0.01. Maximum percent performance degradation to allow for searching for a faster model
        rate_maxloss = .01;
        
        %> Statistical significance level to consider one average time lower than another
        time_pvalue = 0.05;
        
        %> =.2. Minimum time gain to consider when searching for a less well-performing model
        time_mingain = .25;
        
        %> Vectorcomp object for the p-values
        vectorcomp;
    end;
    
    methods
        %> Both @c ratess and @c timess are [k]x[number of cases] matrices
        %> @param ratess
        %> @param timess
        function idx = do_use(o, ratess, timess)
            vc = o.vectorcomp;
            
            if isempty(vc)
                vc = vectorcomp_ttest_right();
                vc.flag_logtake = 0;
            end;
            
            rates = mean(ratess, 1);
            stds = std(ratess, 1);
            rates = rates-stds/100000; % Just to solve ties: if the rate is the same, chooses one with lower standard deviation
            [dummy, ii] = sort(rates, 'descend');
            times = mean(timess, 1);
            n = numel(rates);
            best_rate = rates(ii(1));
            best_time = times(ii(1));
            
            idx = ii(1); % So far, this is it
            time_temp = best_time;
            for i = 2:n
                if rates(ii(i))/best_rate < 1-o.rate_maxloss
                    break; % Search is over
                end;
                
                t = times(ii(i));
                if t <= best_time*(1-o.time_mingain) && t < time_temp
                    z = vc.test(timess(:, ii(1)), timess(:, ii(i)));
                    % z(1): "probability of the observed values given that mean(time_max_rate - time_current) < 0"
                    %
                    % It this probability is really low (low p-value), we reject that the random variable (time_max_rate-time_current) has a
                    % negative mean
                    %
                    % In colloquial terms, it means that it is likely that time_current is lower 
                    if z(1) < o.time_pvalue
                        time_temp = t;
                        idx = ii(i);
                    end;
                end;
            end;
        end;       
    end;
end
