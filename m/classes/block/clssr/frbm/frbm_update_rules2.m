% % % % Alternative rule updating. Uses firing strenght and a threshold (model.new_rule_factor)
% % % % TODO Obsolete
% % % 
% % % flag_new = 0;
% % % if model.rulesets(i_ruleset).no_rules == 0
% % %     flag_new = 1;
% % % else
% % %     [max_level, index_closest_] = max(tau(model.rulesets(i_ruleset).idxs));
% % %     index_closest = model.rulesets(i_ruleset).idxs(index_closest_);  % Absolute index of the rule
% % % end;
% % % 
% % % 
% % % 
% % % if flag_new || max_level < model.new_rule_factor
% % % %      subplot(2, 1, 1);
% % % %      hold off;
% % % %      plot(o.rule_focalpoints');
% % % %      hold on;
% % % %      plot(Z, 'r', 'LineWidth', 2);
% % % %      subplot(2, 1, 2);
% % % %      plot(o.memberships');
% % % %     keyboard;
% % %     
% % %     
% % %     % New rule
% % %     if model.flag_verbose
% % %         fprintf('(max_level < threshold) --> new rule centred at new sample\n');
% % %     end;
% % % 
% % %     eval(model.s_script_add_rule);
% % % 
% % %    
% % %     
% % % 
% % % else
% % %     % Rule support
% % % 
% % % 
% % %     k = model.rulesets(i_ruleset).k;
% % % 
% % %     % Infeasible???
% % %     model.rule_focalpoints(index_closest, :) = ((k-1)*model.rule_focalpoints(index_closest, :)+z)/k;
% % %     delta_z = z-model.rule_focalpoints(index_closest, :);
% % % 
% % %     eval(model.s_script_support_rule);
% % % end;
