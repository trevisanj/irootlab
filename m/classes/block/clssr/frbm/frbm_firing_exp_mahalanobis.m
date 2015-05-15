% function firing = frbm_firing_exp_mahalanobis(model, idx_ruleset, idx_rules, x)
function firing = frbm_firing_exp_mahalanobis(model, idx_ruleset, idx_rule, x)

no_rules = model.rulesets(idx_ruleset).no_rules;

if no_rules > 0
    rule = model.rulesets(idx_ruleset).rules(idx_rule);
    dif = x-rule.focalpoint(1:model.nf);
    dif = x-rule.mean(1:model.nf);    
% 	firing = exp(-dif*rule.CL2*dif'/2);
	firing = exp(-dif*inv(rule.CL22)*dif'/2);
else
    firing = 0;
end;
