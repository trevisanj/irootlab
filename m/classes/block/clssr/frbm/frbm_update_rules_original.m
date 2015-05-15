%> @brief Rule updater
%> Rule updating code. It currently implements conditions A and B, but not
%> condition C.
%>
%> This code retains the original algorithm completely
function o = frbm_update_rules_original(o)


o.potential_z = o.get_potential(o.i_ruleset, o.z);

ruleset = o.rulesets(o.i_ruleset);
for i = 1:ruleset.no_rules
    % Calculation of the distance to the centers, eq. (21)
    dist = norm(o.z-ruleset.rules(i).focalpoint)^2;
    P = ruleset.rules(i).potential;
    o.rulesets(o.i_ruleset).rules(i).potential = ruleset.k*P/(ruleset.k-1+P*(1+dist));
end;

ruleset = o.rulesets(o.i_ruleset);

if ruleset.no_rules > 0
    potentials = [ruleset.rules.potential];
else
    potentials = [];
end;

% potential_z
% potentials

if o.rulesets(o.i_ruleset).no_rules == 0
    o = o.add_rule();
    
else
    ruleset = o.rulesets(o.i_ruleset);

    % Finds the index of the rule closest to z
    d_min = Inf;
    for i = 1:ruleset.no_rules
        focalpoint = ruleset.rules(i).focalpoint;

        distance = norm(o.z-focalpoint);
        if distance < d_min
            o.index_closest = i;
            d_min = distance;
        end;
    end;
    
    % Checking that forces rule to be added if z is the first point seen of z's class
    if ~o.flag_datay
        flag_add = 1;
        for i_target = 1:size(o.rule_targets, 1)
            if all(eq(o.target, o.rule_targets(i_target, :)))
                flag_add = 0;
                break;
            end;
        end;
    else
        flag_add = 0;
    end;
    
    if flag_add
        o = o.add_rule();
    else
        potential_max = max(potentials);
        potential_min = min(potentials);
        
        %Records the distance between z and the closest rule
        o.delta_z = o.z-ruleset.rules(o.index_closest).focalpoint;

        % Condition flag_a: 'Does the new sample have the biggest potential?'
        roundfact = 1e8;
        
        flag_a_max = round(o.potential_z*roundfact) > round(potential_max*roundfact);
        flag_a_min = ~flag_a_max && o.flag_consider_Pmin && round(o.potential_z*roundfact) < round(potential_min*roundfact);

        flag_support = 0;
        if flag_a_min || flag_a_max
            [firing, mu] = o.f_get_firing(o, o.i_ruleset, o.index_closest, o.x);
                
            % flag_b: all memberships above epsilon? If yes, rule is "replaced". A bit weird to replace it in the flag_a_min case
            flag_b = true; 
            for j = 1:o.nf
                if abs(o.delta_z(j)) > ruleset.rules(o.index_closest).radii(j)*sqrt(2) % mu(j) < o.epsilon
                    flag_b = false;
                    break;
                end;
            end;

            if flag_b
                %----------------
                % REPLACES A RULE
                %----------------

                if flag_a_max || flag_a_min
%                     fprintf('#A&B\n');
                    if ruleset.no_rules > 1 % TODO discover why this

                        o.rulesets(o.i_ruleset).rules(o.index_closest).focalpoint = o.z;
                        o.rulesets(o.i_ruleset).rules(o.index_closest).target = o.target;
                        o.rulesets(o.i_ruleset).rules(o.index_closest).potential = o.potential_z;
                        
                    end;
                else
%                     fprintf('#SUPPORT\n');
                end;

                flag_support = 1;
            else
%                 fprintf('#A\n');
                %----------------
                % ADDS A NEW RULE
                %----------------
                o = o.add_rule();
                
            end;
        else
%             fprintf('#SUPPORT\n');
            flag_support = 1;
        end


        if flag_support
            o = o.support_rule();
        end;
    end;
end;
