NEVER TESTED

% Removes the rule indicated by index_delete
%
% This function is presumably ready to use, however not tested yet
% I don't think this works

model.rule_focalpoints(index_delete, :) = [];
model.rule_supports(index_delete) = [];
model.rule_scatters(index_delete, :) = [];
model.rule_radii(index_delete, :)= [];

% Now the trick is to shift down by 1 all indexes greater than index_delete
% in model.ruleset(:).idxs
for i = 1:model.no_rulesets
    idx_idx = bsearch(model.rulesets(i).idxs, index_delete);
    
    if i == model.rule_ruleset_idxs(index_delete)
        % It means that the rule being deleted is inside ruleset i
        model.rulesets(i).idxs(idx_idx) = [];
        model.rulesets(i).no_rules = model.rulesets(i).no_rules-1;
        
        idx_idx = idx_idx+1; % This is necessary because the found index has just been deleted from rulesets(i).idxs (see later)
        if idx_idx > model.rulesets(i).no_rules
            % idx_idx increment above may cause trouble if the rule being
            % deleted is the last of a set
            continue;
        end;
    end;
    
    % finally the shift
    model.rulesets(i).idxs(idx_idx:end) = model.rulesets(i).idxs(idx_idx:end)-1;
end;
