% Rule updating code. It currently implements conditions A and B, but not
% condition C.



% % Tweak 2: use of a single formula (and function!) to calculate potentials. Therefore this code is retired (see same
% % tweak below)
% %
% % Result (as expected) does not change the average rate significantly. It seems to stay the same, but the results don't
% % match anymore
% %
% % Ps is calculated in the original way. Pc was originally a function that at the same time takes and does not take into
% % account the new z to calculate the potential of the rule centres.
%
% potential_z = frbm_get_potential(model, i_ruleset, z);
% 
% 
% ruleset = model.rulesets(i_ruleset);
% for i = 1:ruleset.no_rules
%     % Calculation of the distance to the centers, eq. (21)
%     dist = norm(z-ruleset.rules(i).focalpoint)^2;
% 
%     model.rulesets(i_ruleset).rules(i).potential = ruleset.k*ruleset.rules(i).potential/ (ruleset.k-1+ruleset.rules(i).potential*(1+dist));
% end;
% 

if model.rulesets(i_ruleset).no_rules == 0
    model.script_add_rule();
else

% % % % % % % % TWEAK 3: I did not find in any paper something saying that a nwe fule should be enforced when of the first point of a
% % % % % % % % certain class

    if ~model.flag_datay
        flag_add = 1;
        for i_target = 1:size(model.rule_targets, 1)
            if all(eq(target, model.rule_targets(i_target, :)))
                flag_add = 0;
                break;
            end;
        end;
    else
        flag_add = 0;
    end;
    
    if flag_add
        model.script_add_rule();
    else
        
        ruleset = model.rulesets(i_ruleset);

        
        % TWEAK 2, part 2
        potential_z = frbm_get_potential(model, i_ruleset, z);

        potentials = zeros(ruleset.no_rules, 1);

        % Finds the index of the rule closest to z and calculates potentials of focal points
        d_min = Inf;
        for i = 1:ruleset.no_rules
            focalpoint = ruleset.rules(i).focalpoint;
            
            potentials(i, 1) = frbm_get_potential(model, i_ruleset, focalpoint);

            distance = norm(z-focalpoint);
            if distance < d_min
                index_closest = i;
                d_min = distance;
            end;
        end


        potential_max = max(potentials);
        potential_min = min(potentials);

        
        %Records the distance between z and the closest rule
        delta_z = z-ruleset.rules(index_closest).focalpoint;


        % Condition flag_a: 'Does the new sample have the biggest potential?'
        roundfact = 1e8;
        flag_a_max = round(potential_z*roundfact) > round(potential_max*roundfact);
        flag_a_min = ~flag_a_max && model.flag_consider_Pmin && round(potential_z*roundfact) < round(potential_min*roundfact);

        flag_support = 0;
        if flag_a_min || flag_a_max
            [firing, mu] = model.f_get_firing(model, i_ruleset, index_closest, x);
                
            % flag_b: all memberships above epsilon? If yes, rule is "replaced". A bit weird to replace it in the flag_a_min case
            flag_b = true; 
            for j = 1:model.nf
                if mu(j) < model.epsilon
                    flag_b = false;
                    break;
                end;
            end;

            if flag_b
                %----------------
                % REPLACES A RULE
                %----------------

                
% % % % % %                 % TWEAK 1: only if condition A was triggered by a P > Pmax the rule can be migrated. Otherwise supports
% % % % % %                 % only. A quick test (test_cervical2.m) detected no difference, maybe because condition B may be not
% % % % % %                 % triggered if the new point is in a very low potential area
                
                if flag_a_max || flag_a_min
                    if ruleset.no_rules > 1 % TODO discover why this
                        model.rulesets(i_ruleset).rules(index_closest).focalpoint = z;
                        model.rulesets(i_ruleset).rules(index_closest).target = target;
                    end;
                else
                end;

                flag_support = 1;
            else
                %----------------
                % ADDS A NEW RULE
                %----------------
                model.script_add_rule();
            end;
        else
            flag_support = 1;
        end


        if flag_support
            model.script_support_rule();
        end;
        
    end;
end;

