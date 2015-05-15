%> @brief Firing level calculator - default
%> @return [firing] or [firing, memberships]
%> @todo Reference?
function varargout = frbm_firing_exp_default(model, idx_ruleset, idx_rule, x)

no_rules = model.rulesets(idx_ruleset).no_rules;
if  no_rules > 0
    rule = model.rulesets(idx_ruleset).rules(idx_rule);
    memberships = exp(-(x-rule.focalpoint(1:model.nf)).^2./(2*rule.radii(1:model.nf).^2));
    firing = prod(memberships);
    
    % NaN prevention
    isn = isnan(firing);
    if sum(isn) > 0
        error('Firing level is NaN!');
        disp('*** Warning: NaN prevention took place!!! (FIRING LEVEL CALCULATION)');
        memberships = zeros(1, model.nf);
        firing = 0;
    end;
else
  memberships = zeros(1, model.nf);
  firing = 0;
end;

if nargout == 1
    varargout = {firing};
else
    varargout = {firing, memberships};
end;
