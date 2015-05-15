%> @brief Logistic Regression Classifier 
classdef clssr_mnr < clssr
    properties(SetAccess=private)
        mnrmodel = [];
    end;

    methods
        function o = clssr_mnr(o)
            o.classtitle = 'Logistic Regression';
        end;
    end;
    
    methods(Access=protected)

        function o = do_train(o, data)
            model.classlabels = data.classlabels;

            tic;
            model.mnrmodel = mnrfit(data.X, data.classes+1);
            model.time_train = toc;
        end;
        
        
        
        function est = do_use(o, data)
            est = estimation();
            est.classlabels = o.classlabels;
            est = est.copy_from_data(data);
            tic();

            PHAT = mnrval(o.mnrmodel, data.X);
%             [values, indexes] = max(PHAT, [], 2);
            est.X = PHAT; % classes = indexes-1;
            o.time_use = toc();

            
        end;
    end;
end