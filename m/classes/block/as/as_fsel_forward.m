%> @brief Forward Feature Selection
%>
%> <h3>References</h3>
%>
%> ﻿[1] L. C. Molina, L. Belanche, and a. Nebot, “Feature selection algorithms: a survey and experimental evaluation,”
%> 2002 IEEE International Conference on Data Mining, 2002. Proceedings., pp. 306-313, 2002. <b>Section 2.2.2</b>
%>
%> @sa uip_as_fsel_forward.m
classdef as_fsel_forward < as_fsel
    properties
        %> Feature Subset Grader object.
        fsg = [];
        %> =10. Number of features to be selected
        nf_select = 10;
    end;
    
    methods
        function o = as_fsel_forward()
            o.classtitle = 'Forward';
            o.flag_multiin = 1;
        end;
    end;
    
    methods(Access=protected)
        function log = do_use(o, data)
            o.fsg.data = data;
            o.fsg = o.fsg.boot();
            nf = data(1).nf;

            nf_eff = min(o.nf_select, nf); % Effective number of features to be selected
            v_in = [];
            v_left = 1:nf;
            nfxgrade = zeros(1, nf_eff);
            flag_first = 1;

            flag_progress = ~isempty(o.fsg.sgs);
            if flag_progress
                ipro = progress2_open('FSEL_forward', [], 0, nf_eff);
                ii = 0;
            end;
                
            for i = 1:nf_eff
                if flag_first && ~flag_progress
                    t = tic(); % Will record time to see if the iteration is "slow" (i.e., takes more than 1 second). If so, will "activate" the progress bar
                end;
                irverbose(sprintf('Number of features: %d ...', i));
                
                % Creates candidates
                v_candidates = arrayfun(@(x) [v_in, x], v_left, 'UniformOutput', 0);

                % Evaluates candidates
                candidatesgrades = o.fsg.calculate_grades(v_candidates);
                g = candidatesgrades(:, :, 1);
                [val, idx] = max(g);
                
                % verifies whether there is more than one candidate with maximum grade
                ima = find(g == val);
                n_ima = length(ima);
                if n_ima > 1
                    idx = ima(randi([1, n_ima])); % Random decision is probably the best that could be done here!                   
                end;
              
                % Recordings
                v_in = [v_in, v_left(idx)]; % Indexes of selected features
                v_left(idx) = []; % Indexes of left features
                nfxgrade(i) = val; % Recording of (nf)x(grade) sequence

                %---> Verboses
                irverbose(['Selection so far: ', mat2str(v_in)], 1);
                if flag_first && ~flag_progress
                    if toc(t) > 1
                        ipro = progress2_open('FSEL_forward', [], 0, nf_eff);
                        flag_progress = 1;
                    end;
                end;
                if flag_progress
                    ipro = progress2_change(ipro, [], [], i);
                end;
                
                flag_first = 0;
            end;
            if flag_progress
                progress2_close(ipro);
            end;

            % Output
            log = log_as_fsel_forward();
            log.v = v_in;
            log.nfxgrade = nfxgrade;
            log.grades = zeros(1, nf);
%             log.grades(log.v) = 1;
            log.fea_x = data(1).fea_x;
            log.xname = data(1).xname;
            log.xunit = data(1).xunit;
            log.yname = o.fsg.get_yname();
            log.yunit = o.fsg.get_yunit();
        end;
    end;
end
