%> @brief K-Fold Cross-Validation
%>
%> Cross-validation only produces two bites: usually corresponding to training and test data
%>
%> @sa uip_sgs_crossval.m
classdef sgs_crossval < sgs
    properties
        %> =10. Stands for the "K". Ignored if flag_loo is TRUE.
        no_reps = 10;
        %> =0. Whether leave-one-out or K-fold.
        flag_loo = 0;
        %> =0. Whether to automatically reduce the number of folds if no_reps is
        %> too big for the dataset.
        flag_autoreduce = 0;
    end;
    
    properties(Access=private)
        pvt_no_reps;
    end;

    methods(Access=protected)
        %> Overwritten
        function o = do_assert(o)
            if o.flag_loo && o.flag_perclass
                irerror('Cannot perform leave-one-out cross-validation per class!');
            end;
        end;
        
        %> Overwritten
        function o = do_setup(o)
            if o.flag_loo
                o.pvt_no_reps = o.no_unitss;
            else
                if any(o.no_reps > o.no_unitss)
                    min_value = min(o.no_unitss);
                    if o.flag_autoreduce
                        o.pvt_no_reps = min_value;
                        irverbose(sprintf('INFO: Cross-validation k reduced from %d to %d', o.no_reps, min_value));
                    else
                        irerror(sprintf('Cross-validation k=%d is bigger than the number of units=%d in dataset!', o.no_reps, min(o.no_unitss)));
                    end;
                else
                    o.pvt_no_reps = o.no_reps;
                end;
            end;
        end;
        
        %> Overwritten
        function idxs = get_repidxs(o)
            idxs = cell(1, o.pvt_no_reps);
            for j = 1:o.no_pieces
                idxs_cross = crossvalind('kfold', o.no_unitss(j), o.pvt_no_reps);
                idxs_seq = 1:o.no_unitss(j);
                for i = 1:o.pvt_no_reps
                    if j == 1
                        idxs{i} = cell(o.no_pieces, 2);
                    end;
                    idxs{i}(j, [1, 2]) = {idxs_seq(idxs_cross ~= i), idxs_seq(idxs_cross == i)};
                end;
            end;
        end;
    end;
    
    methods
        function o = sgs_crossval(o)
            o.classtitle = 'K-Fold Cross-Validation';
        end;
    end;
end