% Calculates the firing level using recursive potential
%
% .xi and .beta are updated in frbm_support_rule.m
%
% This function is a multivariate membership function only (no per-variable memberships), following the new Kernel
% Granulation concept.
function firing = frbm_firing_pr(model, idx_ruleset, idx_rule, x)

rule = model.rulesets(idx_ruleset).rules(idx_rule);

A = 1; % Scaling factor for the potential formula like 1/(1+A*sum(...))

k = rule.support;
firing = k/(k*(A*x*x'+1)+A*rule.beta-2*A*x*rule.xi');
