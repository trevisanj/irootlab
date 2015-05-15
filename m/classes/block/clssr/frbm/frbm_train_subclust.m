% TODO THIS IS ANOTHER CLASS
% 
% 
% % Trains MISO eClass0
% %
% % Needs global variable model (see eclass0_new.m)
% function class0_train_subclust(data)
% 
% pieces = data_split_classes(data);
% 
% 
% nf = data_get_nf(data);
% ones_ = ones(1, nf);
% 
% 
% for cl = 1:length(pieces)
%     o = model.rule_groups{cl};
% 
%     no_observations = size(pieces(cl).X, 1);
% % 
% %     X = data_normalize(pieces(cl).X, 's'); % standardization so 95% of points fall between -2 and 2
%     X = pieces(cl).X;
% 
%     [C, S] = subclust(X, model.scale*sqrt(-1/2/log(model.epsilon))*ones_, [min(X); max(X)]);
% %     [C, S] = subclust(X, model.scale*ones_, [min(X); max(X)]);
%     
%     o.rule_focalpoints = C;
%     o.no_rules = size(C, 1);
%     o.rule_radii = zeros(o.no_rules, nf);
%     for iii = 1:o.no_rules
%         o.rule_radii(iii, :) = S;
%     end;
% 
%     
%     model.rule_groups{cl} = o;
% end;
