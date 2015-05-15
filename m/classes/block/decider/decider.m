%> @brief Block that resolves @ref estimato posterior probabilities into classes.
%>
%> This is an abstraction of class decisions based on the posterior probabilities calculated by a classifier. Classifiers generate an estimato
%> dataset which is later processed by a decider. If the highest per-class posterior probability is below the decider decisionthreshold property,
%> it will “refuse to decide”, registering a class of -1 instead of a valid one.
%>
%> <h3>Reference</h3>
%> L. I. Kuncheva, Combining pattern classifiers. Wiley, 2004.
%> @sa 
classdef decider < block
    properties
        %> =0. Minimum maximum probability. If not reached, assigned class will be -1, which means "refuse-to-decide". Assigning the threshold may require optimization or use of some theoretic formula.
        decisionthreshold = 0;
    end;
    
    methods
        function o = decider(o)
            o.classtitle = 'Decider';
            o.inputclass = 'estimato';
            o.flag_trainable = 0;
        end;
    end;
    
    methods(Access=protected)    
        function est = do_use(o, est)
            [val, idx] = max(est.X, [], 2);
            no = est.no;
            est.classes = -1*ones(no, 1);
            map_in = val >= o.decisionthreshold;
            est.classes(map_in) = idx(map_in)-1;
            est.X = val;
            est.fea_x = 1;
            est.fea_names = {'Support'};
        end;
    end;
end
