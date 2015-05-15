%> @brief Fuzzy Rule-Based Model base class
%>
%>
%> <h3>References:</h3>
%>
%> Angelov P., D. Filev (2004) 'An Approach to On-line identification of
%> Evolving Rule-based Models', IEEE Transactions on SMC-B, v.34(1)484-498
%>
%> Angelov et.al (2004) On-line Identification of MIMO Evolving Takagi-Sugeno Fuzzy Models,
%> FUZZ-IEEE Conference, Budapest, 25-29 July 2004, pp.
%>
%> Angelov P. (2002) Evolving Rule-based Models: A Tool for Design of
%> Flexible Adaptive Systems, Springer-Verlag, Heidelberg, New York, ISBN 3-7908-1457-1
%> http://www.springeronline.com/sgw/cda/frontpage/0,10735,5-0-72-2224473-000.html 
%>
%> Angelov P. (2004) An Approach for Fuzzy Rule-base Adaptation using On-line Clustering
%> Intern. J. of Approximate Reasoning, v.35(3), 2004, 275-289 
%>
%> Angelov P., Zhou X. (2006) 'Evolving Fuzzy System for Data Streams in Real-time.
%> 2006 International Symposium on Evolving Fuzzy Systems 
classdef frbm < clssr_incr
    properties
        %> whether classes must be converter into multiple-output boolean targets.
        flag_class2mo = 1;

        %%%%%%%%%%%%
        % New rule %
        %%%%%%%%%%%%
        %
        %> = exp(-1). Affects radii at new rule formation; affects condition B
        epsilon = exp(-1); % 0.681966;
        %> affects radii at new rule formation. This one may change, but it is recommented to standardize the inputs instead.
        scale = 0.8; 


        % Takagi-Sugeno stuff
        ts_order = 0; % Takagi-Sugeno order (either 1 or 0)
        omega = 50; % Scale for initialization of inverse of covariance matrix

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Regression or classification %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
%         flag_datay = 0; % if 1, it is a regression problem. Currently I am not very interested in the regression problems. FRBM is an exception


        %%%%%%%%%%%%%%
        % Clustering %
        %%%%%%%%%%%%%%
        %
        flag_iospace = 1;
        %> Grouping is per class?
        flag_perclass = 0;


        %%%%%%%%%%%%%%%%%
        % Rule updating %
        %%%%%%%%%%%%%%%%%
        %
        s_f_update_rules = 'frbm_update_rules';
        %> affects rule radii updating "stubborness": higher the rho, less updated the radii will be
        rho = 0.5;
        %> "Consider minimum potential"? This applies to condition A:
        %> If true, condition A is (Ps > Pmax || Ps < Pmin);
        %> If false, condition a is only (Ps > Pmax).
        flag_consider_Pmin = 1;
        %> Whether to apply condition B in the "classic" way or use otherwise use the firing levels
        flag_b_classic = 1;
        flag_clone_rule_radii = 1;
        new_rule_factor = 1; % TODO still??? Only for update_function2(). Greater new_rule_factor means more rules


        %%%%%%%%%%%%%%%
        % Fuzzy Logic %
        %%%%%%%%%%%%%%%
        %
        s_f_get_firing = 'frbm_firing_exp_default';
        %> Winner Takes All ?
        flag_wta = 0;
        %> Parameter of the cosine and correlation firing functions
        zeta_sq = 0.1;
        flag_rls_global;


        %%%%%%%%%%%%%%%%%%%%%%%%%
        % Interactive behaviour %
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %> This function will be called after each iteration of a training session.
        %> Parameters: none; Must return: nothing.
        f_after_iteration = [];
        flag_verbose = 0;
        flag_store_points = 0;

        %> Observation loop-operational variables
        potential_z;
    end;




    properties %(SetAccess=protected)
        % See do_boot for descriptions
        no_rulesets;
        rulesets;
        k;
        no_rules;
        rule_map;  % TODO do I still use this??????

        CG;
        theta;
        psi;
        rule_targets;
        
        % Observation loop-operational variables
        i_ruleset;
        index_closest;
        delta_z;
        
        lambda;
        tau;
        
        x;
        z;
        x_extended;
        target;
        currentclasslabel;
        currentclass;
        

    
        % These are set at boot time
        flag_potentials;
        flag_potentials_per_rule;
        flag_rule_radii;
        flag_rule_mean;
        flag_rule_cl2;
        flag_rule_potential;

        f_update_rules;
        f_get_firing;
        
        data;
        len_z;
        
        classweights;
        classno;
        %> Provision for unbalanced data
        flag_counterbalance = 0;
    end;
    
    
    
    
    
    
    
    
    
    
    
    methods(Access=private)
        %-----------------------------------------------------------------------------------------------------------------------
        %> Automatic flag setup according to several parameters
        function o = setup_flags(o)

            names = {'flag_potentials', ... % Global potentials
                     'flag_potentials_per_rule', ... % per-rule potentials are local potentials that consider only points supported by the rule
                     'flag_rule_radii', ... % used for the default exponential membership functions
                     'flag_rule_mean', ... % used in the simple vmkg1 rule update, where the centre of the rule will be the mean among the points supported; % Whether the mean of all points of the rule is recorded and updated as points are added to the rule
                     'flag_rule_cl2', ... % currently used in the Mahalanobis distance Kernel
                     'flag_rls_global', ... % if RLS is global, o.theta is expected to be calculated by o.script_rls(); also, the way new rules are initialized will change; also, with RLS local, independent on how CL's and PI's are updated, the o.theta will be taken care of by the framework
                     'flag_rule_potential' ... % Classical way of calculating the global potentials of the rules (not to be confused with the per-rule potentials, which are local)
                    };

            oo = struct();
            for i = 1:length(names)
                % 3-element cell means:
                % {property, property value, value to be set (for oo.(names{i}))}
                % first two elements match one row of map
                oo.(names{i}) = {'', '', -1}; 
                o.(names{i}) = 0;
            end;

            % Map specifies flags that need to be turned when given property has given value.
            % Example, if oo.s_f_get_firing = 'frbm_firing_exp_default', oo.flag_rule_radii must be turned on
            map = { ...
                {'s_f_get_firing', 'frbm_firing_exp_default', {'flag_rule_radii', 1}}, ...
                {'s_f_get_firing', 'frbm_firing_exp_mahalanobis', {'flag_rule_cl2', 1, 'flag_rule_mean', 1}}, ...
                {'s_f_get_firing', 'frbm_firing_pr', {'flag_potentials_per_rule', 1}}, ...
                {'s_f_get_firing', 'frbm_firing_distmean', {'flag_rule_mean', 1, 'flag_rule_radii', 1}}, ...
                {'s_f_update_rules', 'frbm_update_rules_original', {'flag_rule_radii', 1, 'flag_potentials', 1, 'flag_rule_potential', 1}}, ...
                {'s_f_update_rules', 'frbm_update_rules_smalltweak', {'flag_rule_radii', 1, 'flag_potentials', 1}}, ...
                {'s_f_update_rules', 'frbm_update_rules_kg3', {'flag_potentials', 1, 'flag_potentials_per_rule', 1, 'flag_rule_radii', 1}}, ... % Plamen 2010
                {'s_f_update_rules', 'frbm_update_rules_kg2', {'flag_rule_mean', 1}} ... % Plamen 2010
            };

            for i = 1:length(map)
                if strcmp(o.(map{i}{1}), map{i}{2}) % if o property is set as specified in map
                    props = map{i}{3};
                    for j = 1:2:length(props)-1
                        if oo.(props{j}){3} == -1
                            % records what was the match and how to set the flag property
                            oo.(props{j}) = {map{i}{1}, map{i}{2}, props{j+1}};
                        else
                            % has previous match for same flag, checks if value to set is the same, otherwise it is a
                            % conflict
                            if ~(oo.(props{j}){3} == props{j+1})
                                irerror(sprintf('Conflicting options: (%s: ''%s'') not compatible with (%s: ''%s'')!', ...
                                    oo.(props{j}){1}, oo.(props{j}){2}, map{i}{1}, map{i}{2}));
                            end;
                        end;
                    end;
                end;
            end;

            % sets flag properties for which a match (property, value) was found
            for i = 1:length(names)
                if oo.(names{i}){3} ~= -1
                    o.(names{i}) = oo.(names{i}){3};
                end;
            end;
        end;

        %-----------------------------------------------------------------------------------------------------------------------
        %> Sets up the function (or script) pointers. What it does is to create fields into model that have similar names to the
        %> strings in fields{} below, but don't have the initial 's_'. The new field contents will be function pointers.
        function o = setup_fpointers(o)
%             fields = {'s_f_update_rules', 's_script_add_rule', 's_script_support_rule', 's_script_rls', 's_f_get_firing'};
             fields = {'s_f_update_rules', 's_f_get_firing'};

            for i = 1:length(fields)
                o.(fields{i}(3:end)) = eval(['@' o.(fields{i})]);
            end;
        end;
    end;

    
    

    
    
    
    
    
    
    methods
        function o = frbm(o)
            o.classtitle = 'Fuzzy Rule-Based Model';
            o.short = 'FRBM';
        end;
        

        
        %> This function calls the parent report and then attaches the linguistic rules at the end
        function s = get_report(o)
            s = get_report@clssr(o);


            a = {'++ Linguistic representation of the fuzzy rules ++'};
            for i = 1:o.no_rules
                a{i+1} = o.get_linguistic(i);
            end;

            if length(a) > 1
                s = strcat(s, sprintf('\n\n%s', a{:}));
            end;
        end;

    
        
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % CHECK IF NEEDED        % Converts classes to targets depending on o.flag_class2mo
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         function targets = get_targets(o, classes)
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %             if o.flag_class2mo
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %                 targets = classes2boolean(classes, o.no_outputs);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %             else
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %                 targets = classes;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %             end;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         end;        
        
        
        
        
        
        %> @brief Returns a string like "IF ... THEN"
        %> @param idx_rule Can be either a rules absolute index or a pair [i_ruleset, i_rule]
        %> @param scales See description
        %> @param shifts See description
        %> @param feanames Names of the input variables
        %>
        %> @c scales and @c shifts can be used to bring the focal point into the original scale and offset, since they were
        %> probably standardized before being inputted into the classifier.
        %>
        %> @code
        %> focalpoint_show(j) = focalpoint(j)*scales(j)+shifts(j)
        %> @endcode
        function s = get_linguistic(o, idx_rule, scales, shifts, feanames)
            if size(idx_rule) == 1
                i_set = o.rule_map(idx_rule, 1);
                i_rule = o.rule_map(idx_rule, 2);
            else
                i_set = idx_rule(1);
                i_rule = idx_rule(2);
            end;


            if ~exist('scales', 'var')
                scales = ones(1, o.nf);
            end;

            if ~exist('shifts', 'var')
                shifts = zeros(1, o.nf);
            end;

            if ~exist('feanames', 'var')
                s_l = floor(log10(o.nf))+1;
                for i = 1:o.nf
                    feanames{i} = sprintf(['x%0' int2str(s_l) 'd'], i);
                end;
            end;

            centre = o.rulesets(i_set).rules(i_rule).focalpoint;

            s = 'IF (';
            for i = 1:o.nf
                if i > 1
                    s = strcat(s, ' AND ');
                end;
                s = strcat(s, '(', feanames{i}, ' IS ', sprintf('%g', centre(i)*scales(i)+shifts(i)), ')');
            end;
            s = [s ') THEN '];

            if o.ts_order == 0
                if o.flag_class2mo
                    [val, idx] = max(o.rulesets(i_set).rules(i_rule).target);
                    class = idx-1;
                else
                    class = o.rulesets(i_set).rules(i_rule).target;
                end;
                s = [s 'CLASS IF ´' o.classlabels{class+1} '´'];
            else
                for j = 1:o.no_outputs
                    if j > 1
                        ss = ' AND';
                    else
                        ss = '';
                    end;

                    s = strcat(s, ss, sprintf(' ...\n(y%d = ', j));

                    for i = 1:o.nf+1
                        if i == 1
                            ss = '1';
                            sss = '';
                        else
                            ss = [feanames{i-1}];
                            sss = ' + ';
                        end;

                        s = strcat(s, sss, sprintf('%s*%s', num2str(o.rulesets(i_set).rules(i_rule).pi(i, j)), ss));
                    end;

                    s = strcat(s, ')');
                end;
            end;
        end;
        
        %-%-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %   %-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %-%-%-%-%-%-%-%
        %> get_potential(): returns global potential of a point 'z' belonging to the input-output space
        %>
        %> Inputs:
        %>   Z: matrix of [z1; z2; z3; ...], i.e., input-output space vectors lying horizontally
        function pp = get_potential(o, i_ruleset, Z)

            no = size(Z, 1);

            pp = zeros(no, 1);

            k_ = o.rulesets(i_ruleset).k;

            for i = 1:no
                if k_ > 0
                    z_ = Z(i, :);
                    pp(i) = k_/(k_*(z_*z_'+1)+o.rulesets(i_ruleset).Beta-2*z_*o.rulesets(i_ruleset).Xi');
                else
                    pp(i) = 1;
                end
            end;
        end;

        %-%-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %   %-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %-%-%-%-%-%-%-%
        %> Legend
        %> @arg r: number of rules
        %> @arg m: number of inputs
        %> @arg n: number of outputs or zero (depending on flag_iospace)
        %>
        %> Generally used
        %> @arg .focalpoints = [];    % {([r][m+n]); may be [x targets] or [x], the latter if .flag_iospace is 0} {membership function, calculation of scatters, radii} 
        %> @arg .supports = []; % {[r][1]} {radius updating, potential membership as well} {number of points that "belong" to the rule}
        %> @arg .targets = []; % {[r][n]} {???} {This is used for TS0 only. This information may be redundant depending on .flag_iospace}
        %> 
        %> Radii stuff
        %> @arg .scatters = []; % {[r][m+n]} {used in radius update only (frbm_support_rule.m)} {diagonal scatter matrix of the points belonging to a rule}
        %> @arg .radii = []; % {[r][m]} {frbm_firing_exp_default.m, updated in frbm_support_rule.m; frbm_add_rule.m has an issue with the initial value for this} {The purpose here is to serve as Rule radii % may also be regarded as sort of a de-coupled co-variance matrix. I am not sure why the above exists.} 
        %> 
        %> TS stuff
        %> @arg .CL = []; % {[m+1][m+1][r]} {rule_up ???} {estimative of inverse of local covariance matrix for the local RLS}
        %> @arg .pi = []; % {[m+1][n][r] or [r][????]} {???} {TS order 0/1 parameter vector (for order 0 has only a constant value)}
        %> 
        %> Membership function using the Cauchy-of-sum potential function
        %> @arg .beta = []; % {[r][m+n]} {changed in corresponding rule support; used in firing strength calculation} {this is necessary for the recursive calculation of potentials}
        %> @arg .xi = []; % {[r][1]} {changed in corresponding rule support; used in firing strength calculation} {this is necessary for the recursive calculation of potentials}
        %> 
        %> Used in the online clustering of frbm_update_rules3
        %> @arg .means = []; % {[r][m+n]} {frbm_update_rules3.m} {stores the mean of all i-o points that belong to a rule}
        function o = add_rule(o)
            
            rule = o.emptyrules();
            rule(1).focalpoint = [];
            
            if o.ts_order == 1 && ~o.flag_rls_global
                % Lambda before rules are added is needed to weight the 
                o = o.calculate_lambda();
                lambda_before = o.lambda;
            end;

            %======== Model-level stuff
            o.no_rules = o.no_rules+1;
            i_r = o.rulesets(o.i_ruleset).no_rules+1;
            o.rulesets(o.i_ruleset).no_rules = i_r;
            o.rulesets(o.i_ruleset).idxs(end+1) = o.no_rules; % I don't know if this is still needed but I guess not
            o.rule_map(o.no_rules, :) = [o.i_ruleset, i_r];

            % Just found out that the original eClass forces a new rule every time a new class is found
            % Updates rule_targets, which is used for TS0 estimation
            o.rule_targets(o.no_rules, :) = o.target;

            %======== Rule-level stuff

            % General
            rule.focalpoint = o.z;
            rule.target = o.target;
            rule.support = 1;
            rule.idx_creation = o.no_rules;
            if o.ts_order == 1
                if ~o.flag_rls_global
                    rule.pi = [];
                    rule.CL = [];
                end;
            end;
            % rule.ruleset_idxs(i_r) = i_ruleset; % This is to facilitate rule deletion


            if o.flag_rule_potential
                rule.potential = o.potential_z;
            end;

            if o.flag_rule_radii
                rule.scatter = zeros(1, o.len_z); 

                % How do decide upon radii of the new rule? (...)
                if o.rulesets(o.i_ruleset).no_rules > 1 && o.flag_clone_rule_radii
                    % (...) radii are taken from closest rule. Index_closest is resolved in
                    % the s_script_update_rules routine (e.g. frbm_update_rules.m)
                    rule.radii2 = o.rulesets(o.i_ruleset).rules(o.index_closest).radii2;
                else
                    % (...) initial radii are taken from blockscale.
                    r = o.scale;
                    rule.radii2 = ones(1, o.len_z)*r^2;
                end;

                rule.radii = sqrt(rule.radii2);
            end;


            if o.flag_potentials_per_rule
                rule.beta = sum(o.x.^2);
                rule.xi = o.x;
            end;

            if o.flag_rule_mean
                rule.mean = o.z;
            end;


            if o.flag_rule_cl2
                rule.CL2 = o.omega*eye(o.nf); 
            %     rule.CL22 = 1/o.omega*eye(o.nf);
                rule.sc22 = zeros(o.nf);
                rule.CL22 = eye(o.nf)*o.scale;
            end;


            if o.flag_store_points
                rule.Z = [];
            end;



            % TS1 stuff (both model-level and rule-level)
            if o.ts_order == 1
                if ~o.flag_rls_global

                    %======== Rule-level TS stuff

                    % When NEW RULE IS ADDED, RESETS the inverse of the covariance matrix and coefficients of the new local sub-blocks

                    % calculate PI for new rule, which will be a weighed average of all existing PI's
                    pi_add = zeros(o.nf+1, o.no_outputs);

                    for i = 1:o.no_rules-1
                        pi_add = pi_add + lambda_before(i)*o.rulesets(o.rule_map(i, 1)).rules(o.rule_map(i, 2)).pi;
                    end

                    % Coefficients of newly added rule
                    rule.pi = pi_add;   % eq. (27a)

                    % Inverse of covariance matrix of the newly added rule
                    rule.CL = o.omega*eye(o.nf+1); % eq. (32)
                else

                    %======== Model-level TS stuff

                    ne = o.nf+1;

                    % Calculates new rule's consequent parameters as an weighted average of
                    % the consequent parameters of all the existing rules. The weights are
                    % the normalized firing strenghts of the rules.
                    theta_add = zeros(ne, o.no_outputs);
                    for i = 1:o.no_rules-1
                        for j = 1:o.no_outputs
                            theta_add(:, j) = theta_add(:, j)+ lambda_before(i)*o.theta((i-1)*ne+1:i*ne, j);
                        end
                    end

                    % When a new rule is added, theta (the vector of rule consequent
                    % parameters) grows in number of rows, and CG (estimation of the covariance matrix of the
                    % psi vector) grows in both dimensions (obviously for it is square).

                    o.theta = [o.theta; theta_add];

                    % All existing elements in CG are multiplied by a number slightly
                    % greater than 1 (why)?
                    o.CG = o.CG*(o.no_rules^2+1)/o.no_rules^2;

                    % CG is expanded so it now contains a new block in the bottom right
                    % corner.
                    o.CG((o.no_rules-1)*ne+1:o.no_rules*ne, (o.no_rules-1)*ne+1:o.no_rules*ne) = eye(ne)*o.omega;
                end;
            end;
            
            o.rulesets(o.i_ruleset).rules(i_r) = rule;
        end;
        
        %-%-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %   %-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %-%-%-%-%-%-%-%
        %> SUPPORTS AN EXISTING RULE: includes current z in existing rule o.rulesets(i_ruleset).rules(index_closest)
        function o = support_rule(o)

            rule = o.rulesets(o.i_ruleset).rules(o.index_closest);

            rule.support = rule.support + 1;


            if o.flag_rule_radii
                % This is specific for radius updating
                rule.scatter = rule.scatter + o.delta_z.^2;

                % This formula in the 2006 paper cited in the main module frbm_train_ets.m
            %     rule.radii = o.rho*rule.radii + (1-o.rho)*sqrt(rule.scatter/rule.support);
                rule.radii2 = o.rho*rule.radii2 + (1-o.rho)*rule.scatter/rule.support;
                rule.radii = sqrt(rule.radii2);
            end;


            if o.flag_rule_mean
                rule.mean = ((rule.support-1)*rule.mean+o.z)/rule.support;
            %     rule.focalpoint = rule.mean;
            end;


            if o.flag_potentials_per_rule
                rule.beta = rule.beta+sum(o.x.^2);
                rule.xi = rule.xi+o.x;
            end;


            if o.flag_rule_cl2
                koeff = 1;
                rule.CL2 = rule.CL2-(koeff*rule.CL2*o.x'*o.x*rule.CL2)/(1+koeff*o.x*rule.CL2*o.x');

            %     rule.CL22 = ((rule.support-1)*rule.CL22+(x-rule.mean(1:o.nf))'*(x-rule.mean(1:o.nf)))/rule.support;
                rule.sc22 = rule.sc22+(o.x-rule.mean(1:o.nf))'*(o.x-rule.mean(1:o.nf));
                rule.CL22 = o.rho*rule.CL22+(1-o.rho)*rule.sc22/rule.support;
            end;
            % 
            % 
            % if o.flag_rule_cl3
            %     koeff = 1;
            %     rule.CL3 = rule.CL3-(koeff*rule.CL3*z'*z*rule.CL3)/(1+koeff*z*rule.CL3*z');
            % end;


            if o.flag_store_points
                rule.Z = [rule.Z; o.z];
            end;

            o.rulesets(o.i_ruleset).rules(o.index_closest) = rule;


            % RLS iteration
            if o.ts_order == 1
                if o.flag_rls_global
                    o = o.rls_global();
                else
                    o = o.rls_local();
                end;
            end;
        end;
        
        
        %> Calls the ancestor, then plots the contours for all rules firing levels = 0.5
        function draw_domain(o, params)
            %-------------
            % Converts boolean vector to class if needed
            function class = ensure_class(target)
                if length(target) > 1
                    [val, idx] = max(target);
                    class = idx-1;
                else
                    class = target;
                end;
            end;
            
            
            flag_last_point = isfield(params, 'flag_last_point') && params.flag_last_point;

            if flag_last_point
                params.ds_train = params.ds_train.map_rows(1:o.k);
            end;


            draw_domain@clssr(o, params);

            for i = 1:o.no_rules
                i_ruleset = o.rule_map(i, 1);
                i_ruleset_rule = o.rule_map(i, 2);
                rule = o.rulesets(i_ruleset).rules(i_ruleset_rule);

                if params.flag_link_points
                    fp = rule.focalpoint;
                    if o.flag_store_points
                        for j = 1:size(rule.Z, 1);
                            z = rule.Z(j, 1:o.nf);
                            plot([z(1), fp(1)], [z(2), fp(2)], 'k--', 'LineWidth', 1);
                        end;
                    end;
                end;




                % Contour or firing level

                [Q1, Q2] = meshgrid(linspace(params.x_range(1), params.x_range(2), params.x_no), ...
                                    linspace(params.y_range(1), params.y_range(2), params.y_no));
                X_map = [Q1(:) Q2(:)];
                no = size(X_map, 1);


                Y = zeros(no, 1);
                for j = 1:no
                    Y(j, :) = o.f_get_firing(o, i_ruleset, i_ruleset_rule, X_map(j, :));
                end;

                block = zeros(params.y_no, params.x_no);
                for j = 1:params.x_no
                    block(:, j) = Y((j-1)*params.y_no+1:j*params.y_no);
                end;

            %     rule = o.rulesets(o.rule_map(i_rule, 1)).rules(o.rule_map(i_rule, 2));

                if o.ts_order == 0 && ~o.flag_datay
                    color = find_color(ensure_class(rule.target)+1);
                else
                    color = [0, 0, 0];
                end;

                contour(Q1, Q2, block, [.5, .5], 'LineColor', [0, 0, 0]);
                fp = rule.focalpoint;
                plot3(fp(1), fp(2), 10, 'Marker', '*', 'MarkerSize', 15, 'Color', color);
                hold on;
            end;


            if flag_last_point
                P = params.ds_train.X(o.k, :);
                plot3(P(1), P(2), 10, 'o', 'MarkerSize', 25, 'LineWidth', 2, 'Color', [.2, .2, .2]);
            end;
            

        end;
    end;

    
    
    
    
    
    
    
    
    
        
        
    methods(Access=protected)
        function z = get_no_outputs(o)
            if ~o.flag_datay
                if o.flag_class2mo
                    z = length(o.classlabels);
                else
                    z = 1;
                end;
            else
                z = size(o.data.Y, 2);
            end;

                
        end;

        %-%-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %   %-%-%-%-%-%-% BOOT
        %  %-%-%-%-%-%-%
        %-%-%-%-%-%-%-%
        function o = do_boot(o)
            o = do_boot@clssr_incr(o);

            o = setup_flags(o);
            o = setup_fpointers(o);

            o.classlabels = {};
            o.no_rulesets = 0;
            o.rulesets = o.emptyruleset();
            % if isfield(o, 'rulesets')
            %     o = rmfield(o, 'rulesets');
            % end;

            o.k = 0; % Overall number of already processed observations
            o.no_rules = 0; % Overal number of rules
            o.rule_map = [];


            % Comments with curly brackets are probably under the following convention
            % {dimensions}{who uses}{explanation}

            % r: number of rules
            % m: number of inputs
            % n: number of outputs or zero (depending on flag_iospace)

            % TS stuff
            o.CG = []; % {[(m+1)*r][(m+1)*r] {estimative of inverse of global covariance matrix for the global RLS}
            o.theta = []; % {[(m+1)*r][n] or ???} {TS1 estimation, either local or global} {Pile of .pi}
            o.rule_targets = []; % {[r][1]} {TS0 estimation} {}
        end;
        

        
        %-%-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %   %-%-%-%-%-%-% USE
        %  %-%-%-%-%-%-%
        %-%-%-%-%-%-%-%
        function est = do_use(o, data)        
            est = estimato();
            est.classlabels = o.classlabels;
            est = est.copy_from_data(data);

            if o.no_rules == 0
                return;
            end;

            X = data.X;
            Y = zeros(data.no, o.no_outputs);

            tic();
            for i_observation = 1:data.no
                o.x = X(i_observation, :);
                o.x_extended = [1, o.x]';

                o = o.calculate_lambda();

            % This was just a test at some point and is now disabled.
            %     % JT22: use support for better Bayesian thing
            %     for i = 1:o.no_rules
            %         rule = o.rulesets(o.rule_map(i, 1)).rules(o.rule_map(i, 2));
            %         lambda(i) = lambda(i)*rule.support;
            %     end;
                if sum(o.lambda) > 0
                    sl = sum(o.lambda);
                    for i = 1:length(o.lambda)
                        o.lambda(i) = o.lambda(i)/sl;
                    end;
                end;


                if o.ts_order == 0
                    % Estimation for Takagi-Sugeno 0-th order model
                    if o.flag_wta
                        % Winner takes all: only the rule with maximum firing strength
                        % is considered
                        [firing_max, idx] = max(o.tau);
                        y = o.rule_targets(idx, :);

                    else
                        % Center of gravity
                        y = o.lambda'*o.rule_targets;
                    end;
                else
                    % Estimation for Takagi-Sugeno 1st order model
                    if o.flag_wta
                        [firing_max, idx] = max(o.tau);
                        n = o.nf;
                        y = o.x_extended'*o.theta((idx-1)*(n+1)+1:idx*(n+1), :);
                    else
                        o = o.calculate_psi();
%                         try
                            y = o.psi'*o.theta;
%                         catch ME
%                             disp('heeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
%                         end;
                    end;
                end;

                Y(i_observation, :) = y;
            end;
            o.time_use = toc();

            est.X = Y;
        end;
        
        
        %-%-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %   %-%-%-%-%-%-% TRAINING
        %  %-%-%-%-%-%-%
        %-%-%-%-%-%-%-%
        function o = do_train(o, data)
            
            o.data = data;


            % TODO move this somewhere else
            if ~o.flag_datay 
                if ~o.flag_perclass
                    o.i_ruleset = 1;
                end;
            else
                o.i_ruleset = 1;
            end;


            % Things that need initialization when the model is being trained for the first time.
            if ~o.flag_trained
                if ~o.flag_datay
                    o.classlabels = {};

                    if ~o.flag_perclass
                        o = o.add_ruleset();
                    end;
                else
                    % Regression has only one ruleset (of course, because there are no classes).
                    o = o.add_ruleset();
                end;

                if o.flag_iospace
                    o.len_z = o.nf+o.no_outputs;
                else
                    o.len_z = o.nf;
                end;
            end;
            
            % Resolves classes.
            if ~o.flag_datay
                uniqueclasses = unique(data.classes);
                existinglabels = data.classlabels(uniqueclasses+1);
                labelstoadd = setxor(existinglabels, intersect(existinglabels, o.classlabels));
                
%                if ~isempty(labelstoadd)
%                    disp('oioioioioioioioioioioioioiolha quem eh');
%                end;
                
                for i = 1:numel(labelstoadd)
                    o = o.add_class(labelstoadd{i});
                end;
                classes = renumber_classes(data.classes, data.classlabels, o.classlabels);
                
                if o.flag_counterbalance && ~o.flag_datay
                    nc = numel(o.classlabels);
                    if numel(o.classno) < nc
                        o.classno(nc) = 0;
                    end;
                    for i = 1:nc
                        o.classno(i) = o.classno(i)+sum(classes == i-1);
                    end;
                    
                    o = o.calculate_classweights();
                end;
                

                
            end;

            % Variables for the progress indicator and time counting.
            i_progress = 0;
            t_total = 0;
            t = tic;

            % Observation loop
            for i_observation = 1:data.no

                %%%%%%%%%%%%%%%
                % Preparation %
                %%%%%%%%%%%%%%%
                %


                % Resolves target. Target will be either data.Y (regression); data.class, or boolean version of
                % data.class
                if o.flag_datay
                    o.target = data.Y(i_observation, :);
                else
                    if o.flag_class2mo
                        o.target = classes2boolean(classes(i_observation), numel(o.classlabels));
                    else
                        o.target = classes(i_observation);
                    end;
                    
                    o.currentclass = classes(i_observation);
                end;

                % Resolves current observation vector, either input or input-output space
                o.x = data.X(i_observation, :);
                if o.flag_iospace
                    o.z = [o.x o.target];
                else
                    o.z = o.x;
                end;
                o.x_extended = [1, o.x]'; % TS1

                % Resolves current ruleset
                if ~o.flag_datay && o.flag_perclass
                    o.i_ruleset = classes(i_observation)+1;
                % else will be 1, already resolved above
                end;


                %%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%
                %%% Model evolving %%%
                %%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%
                %%%
                %%%
                o = o.f_update_rules(o);


                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Update of variables for recursive potential %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %
                if o.flag_potentials
                    o.rulesets(o.i_ruleset).Beta = o.rulesets(o.i_ruleset).Beta+o.z*o.z';
                    o.rulesets(o.i_ruleset).Xi = o.rulesets(o.i_ruleset).Xi+o.z;
                end;


                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Incrementation of observation counters %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %
                % Obs: avoid confusion, k is the number of observations ALREADY PROCESSED!
                o.rulesets(o.i_ruleset).k = o.rulesets(o.i_ruleset).k+1;
                o.k = o.k+1;


                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Time counting and progress indicator %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %
                i_progress = i_progress+1;
                if i_progress == 100
                    i_progress = 0;
                    perc = i_observation/data.no;
                    t_total = t_total+toc(t);
                    t = tic;

                    t_est = t_total/perc;

%                     fprintf('... %6.2f%%; %10.2fs of %10.2fs ... (R=%d)\n', perc*100, t_total, t_est, o.no_rules);
                end;

                o.flag_trained = 1; % One iteration is enough to consider the classifier trained
                
                if o.flag_rtrecord || ~isempty(o.f_after_iteration)
                    o = o.update_theta();
                end;
                
                if o.flag_rtrecord
                    o = o.record();
                end;
                
                if ~isempty(o.f_after_iteration)
                    o.f_after_iteration(o);
                end;

            end
            
            
            % this may redund in the next row, if flag_rtrecord or f_after_iteration is used, but in these cases, we don't expect to be fast
            % anyway
            o = o.update_theta();

            o.time_train = t_total+toc(t);
        end;
        

        
        
        
        
        
        
        %-%-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %   %-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %-%-%-%-%-%-%-%
        % Calculates tau: column vector of firing levels, and lambda: corresponding normalized firing levels
        function o = calculate_lambda(o)        
        
            ta = zeros(o.no_rules, 1);
            la = ta;

            for i_rule = 1:o.no_rules
                ta(i_rule) = o.f_get_firing(o, o.rule_map(i_rule, 1), o.rule_map(i_rule, 2), o.x);
            end;

            sum_tau = sum(ta);
            if sum_tau > 0
                la = ta/sum_tau;
            end;
            
            o.lambda = la;
            o.tau = ta;
        end;



        
        %-%-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %   %-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %-%-%-%-%-%-%-%
        %> psi is a vector containing multiple copies of the extended input weighted by the rules fining levels
        %>
        %> Needs o.x_extended and o.lambda calculated a priori
        function o = calculate_psi(o)
            if o.ts_order == 1
                ne = o.nf+1;
                psii = zeros(o.no_rules*ne, 1);
                for i_rule = 1:o.no_rules
                    psii((i_rule-1)*ne+1:i_rule*ne, 1) = o.lambda(i_rule)*o.x_extended;
                end;
            else
                irerror('TS0 does not have psi!');
            end;
            o.psi = psii;
        end;


        function rule = emptyrules(o)
           rule = struct('focalpoint', {}, 'target', {}, 'support', {}, 'idx_creation', {}, 'pi', {}, 'CL', {}, 'potential', {}, ...
               'scatter', {}, 'radii2', {}, 'radii', {}, 'beta', {}, 'xi', {}, 'mean', {}, 'CL2', {}, 'sc22', {}, 'CL22', {}, 'Z', {}); 
        end;


        function ruleset = emptyruleset(o)
            ruleset = struct('idxs', {}, 'no_rules', {}, 'k', {}, 'Xi', {}, 'Beta', {}, 'rules', {});
        end;


        %-%-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %   %-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %-%-%-%-%-%-%-%
        %> Adds ruleset to the model
        function o = add_ruleset(o)
            a = struct();
            a.idxs = [];
            a.no_rules = 0;

            % All needed for recursive update of potentials. See
            % frbm_calcpr_cauchy_of_sum.m
            a.k = 0;
            a.Xi = 0;
            a.Beta = 0;
            a.rules = o.emptyrules();

            o.no_rulesets = o.no_rulesets+1;
            try
                o.rulesets(o.no_rulesets) = a;
            catch ME
                throw ME;
            end;
        end;


        %-%-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %   %-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %-%-%-%-%-%-%-%
        %> Adds class to FRB model. Basically needs to expand a few variables
        %> Only one new class is contemplated at a time, ok?
        function o = add_class(o, newlabel)

            % Adds current class label to model's list of class labels
            o.classlabels = [o.classlabels newlabel];


            if o.flag_class2mo
                % Vectors only grow if the model is multiple-output

                o.no_outputs = o.no_outputs+1;

                if o.flag_iospace
                    o.len_z = o.len_z+1;

                    for i = 1:o.no_rulesets
                        if o.rulesets(i).no_rules > 0
                            o.rulesets(i).Xi(1, o.len_z) = 0;
                        else
                            % otherwise Xi will be [], so don't bother
                        end;
                    end;
                end;


                % Recorded targets need to grow
                if o.no_rules > 0
                    o.rule_targets(1, o.no_outputs) = 0;


                    for i = 1:o.no_rules
                        rule = o.rulesets(o.rule_map(i, 1)).rules(o.rule_map(i, 2));

                        % this vector has the size of the output space
                        rule.target(1, o.no_outputs) = 0;

                        if o.flag_iospace
                            % All the following vectors follow the size of the Input-Output space

                            rule.focalpoint(1, o.len_z) = 0;

                            if o.flag_rule_radii
                                rule.scatter(1, o.len_z) = 0;
                                rule.radii2(1, o.len_z) = 0;
                                rule.radii(1, o.len_z) = 0;
                            end;

                            if o.flag_rule_mean
                                rule.mean(1, o.len_z) = 0;
                            end;

                            if o.flag_store_points
                                rule.Z(1, o.len_z) = 0;
                            end;
                        end;

                        o.rulesets(o.rule_map(i, 1)).rules(o.rule_map(i, 2)) = rule;
                    end;

                    if o.ts_order == 1
                        % coefficient matrices have width (#columns) of the output space
                        if ~o.flag_rls_global
                            for i = 1:o.no_rules
                                o.rulesets(o.rule_map(i, 1)).rules(o.rule_map(i, 2)).pi(1, o.no_outputs) = 0; % adds column to pi
                            end;
                        else

                            o.theta(1, o.no_outputs) = 0; % adds column to theta
                        end;
                    end;
                end;
            end;
                            


            if o.flag_perclass
                o = o.add_ruleset();
            end;
        end;
        
        %-%-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %   %-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %-%-%-%-%-%-%-%
        %> ============================================================
        %> Global RLS for optimizing theta, the vector containing all parameters
        %> from the consequents of all rules
        %>
        %> psi: input from the RLS perspective. psi = psi(x, lambda) = [lambda1*Xe', lambda2*Xe', ...]'
        %> theta: [no_rules*(nf+1)][no_outputs] consequent parameter matrix
        %> CG: estimation of the INVERSE of the covariance matrix of psi
        %>
        %> The mapping from x to y is not linear. y = psi'*theta, and psi is not a
        %> linear function of x, because lambda_i are dependent on x.
        %>
        %> CG(k) = CG(k-1) - CG(k-1)*psi[k]*psi(k)'CG_(k-1)
        %>                   -------------------------------
        %>                     1+psi(k)'*CG_(k-1)*psi(k)
        %> 
        %> theta(k) = theta(k-1)+CG(k)*psi(k)*(t(k)-psi(k)'*theta(k-1))
        %>
        %> Note: t(k) is the [1][no_outputs] target vector
        function o = rls_global(o)

            
            % TODO can't be chained like that, needs call outside!!!
            o = o.calculate_lambda();
            o = o.calculate_psi();


            o.CG = o.CG-(o.CG*o.psi*o.psi'*o.CG)/(1+o.psi'*o.CG*psii);
            o.theta = o.theta + o.CG*o.psi*(o.target-o.psi'*o.theta);
        end;


        

        %-%-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %   %-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %-%-%-%-%-%-%-%
        function o = rls_local(o)
        
            % This optimization performed on the consequent parameters of each rule
            % separately.
            %

            % TODO can't be chained like that, needs call outside!!!
            o = o.calculate_lambda();


            % CL_i(k) = CL_i(k-1) - lambda_i*CL_i(k-1)*Xe*Xe'*CL_i(k-1)
            %                       -----------------------------------
            %                           1+lambda_i*Xe'*CL_i(k-1)*Xe
            %
            % pi_i(k) = pi_i(k-1) + CL_i(k)*Xe*lambda_i*(t(k)-Xe(k)'*pi_i(k-1))
            %
            % Note: t(k) is [1][no_outputs]

            %     tic;

            for i = 1:o.no_rules

            %            if isequalwithequalnans(o.rules(i).CL, NaN) || isequalwithequalnans(o.rules(i).CL, NaN)
            %                disp('CHECK THIS OUT, THE COVARIANCE MATRIX IS HAVING NaN''s !!!!!!!! Maybe it is because the Amide I peak!!!!!!!!!!!');
            %                keyboard;
            %            end;
            %            
            %            if isequalwithequalnans(tau(1, 1), NaN)
            %                disp('CHECK THIS OUT, THE firing levelssssssssssssssssssss IS HAVING NaN''s !!!!!!!! Maybe it is because the Amide I peak!!!!!!!!!!!');
            %                keyboard;
            %            end;

                i1 = o.rule_map(i, 1);
                i2 = o.rule_map(i, 2);

                weight = o.lambda(i);
                if o.flag_counterbalance && ~o.flag_datay
                    weight = weight*o.get_classweight();
                end;
                
                CL = o.rulesets(i1).rules(i2).CL;
                CL = CL - (weight*CL*o.x_extended*o.x_extended'*CL) / (1+weight*o.x_extended'*CL*o.x_extended);
                o.rulesets(i1).rules(i2).CL = CL;

            %         o.rulesets(i1).rules(i2).pi


                PI = o.rulesets(i1).rules(i2).pi;
                o.rulesets(i1).rules(i2).pi = PI+CL*o.x_extended*weight*(o.target-o.x_extended'*PI);

            %         o.rulesets(i1).rules(i2).pi
            %         disp('checkpoint');

            %            if isequalwithequalnans(o.rules(i).CL(1, 1), NaN) || isequalwithequalnans(o.rules(i).pi(1, 1), NaN)
            %                disp('CHECK THIS OUT, THE COVARIANCE MATRIX IS HAVING NaN''s !!!!!!!! Maybe it is because the Amide I peak!!!!!!!!!!!');
            %                keyboard;
            %            end;

            end;

            %     count_time = count_time+toc;
            %     count_updates = count_updates+o.no_rules;
            %     fprintf('*** Average CL&PI update time per rule: %g\n', count_time/count_updates);
        end;
        
    
        
    
        %-%-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %   %-%-%-%-%-%-%
        %  %-%-%-%-%-%-%
        %-%-%-%-%-%-%-%
        % Update of variables used in estimation only %
        function o = update_theta(o)
 
            if o.ts_order == 1
                if ~o.flag_rls_global
                    % If RLS is local, theta is calculated after the training session is finished.
                    % By the way, RLS global calculates theta directly.

                    %compose Theta from updated PI
                    % theta = [pi_1; pi_2; ... pi_{no_rules}]'
                    n = o.nf;
                    for i = 1:o.no_rules
                        o.theta((i-1)*(n+1)+1:i*(n+1), :) = o.rulesets(o.rule_map(i, 1)).rules(o.rule_map(i, 2)).pi;
                    end
                end;
            end;
        end;
    end;

    
    %%%%%%%%%%%%%%%
    %%% Counter weights - provision for unbalanced data
    methods
        function o = calculate_classweights(o)
            temp = 1./o.classno;
            tt = sum(temp(:));
            o.classweights = temp/tt;
        end;

        function w = get_classweight(o)
            w = o.classweights(o.currentclass+1);
        end;
    end;
end