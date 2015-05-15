% frbm_update_rules3.m
%
% This one uses a minimum-distance-between-rules criterion
%
% Attempt to implement a rule updating that does not use the 1-variable membership degrees so that the ideas in
% "A Simple Fuzzy Rule-based System through Vector Membership and Kernel-based Granulation" (2010) can be implemented


if model.rulesets(i_ruleset).no_rules == 0
    model.script_add_rule();
    
else
    % Finds the index of the rule closest to z
    d_min = Inf;
    for i = 1:model.rulesets(i_ruleset).no_rules
        distance = norm(z-model.rulesets(i_ruleset).rules(i).focalpoint);
        if distance < d_min
            index_closest = i;
            d_min = distance; 
        end;
    end

%     delta_z = z-model.rule_means(index_closest, :);

    
    % distance between space extremes increases with dimension. d_extreme = k*sqrt(number_of_dimensiona)
    
    
    dim = model.len_z;
    distbetweenrules_min = 1/sqrt(6)*(1-7/(40*dim)-65/(869*dim.^2))*(2*sqrt(dim));
    
    
    if d_min < distbetweenrules_min
        model.script_support_rule();
%         model.rulesets(i_ruleset).rules(index_closest).focalpoint = model.rulesets(i_ruleset).rules(index_closest).mean;
    else
        model.script_add_rule();
    end;
end;


