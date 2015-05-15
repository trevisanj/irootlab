% Calculates the firing level using recursive potential
%
% .xi and .beta are updated in frbm_support_rule.m
%
% This function is a multivariate membership function only (no per-variable memberships), following the new Kernel
% Granulation concept.
function firing = frbm_firing_distmean(model, idx_ruleset, idx_rule, x)


rule = model.rulesets(idx_ruleset).rules(idx_rule);

memberships = exp(-(x-rule.mean(1:model.nf)).^2./(2*rule.radii(1:model.nf).^2));
firing = prod(memberships);

