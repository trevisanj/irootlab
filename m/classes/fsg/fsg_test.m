%> @brief Feature subset grader that uses a statistical test
classdef fsg_test < fsg
    methods(Access=protected)
    	% Abstract
        function z = test(o, dd, idxs)
        end;
        
        %> If @c sgs is set, performs cross-validation loop based on @c subddd, otherwise used @c datasets to test.
        function z = do_calculate_pairgrades(o, idxs)
            if ~o.flag_sgs
                if ~o.pvt_flag_pairwise
                    z = o.test(o.datasets, idxs);
                else
                    for i = size(o.datasets, 1):-1:1
                        z(i, :) = o.test(o.datasets(i, :), idxs);
                    end;
                end;
            else
                nd = numel(o.subddd);
                ni = numel(idxs);
                z = zeros(nd, ni);
                for i = 1:nd % Pairwise LOOP
                    dd = o.subddd{i};
                    nreps = size(dd, 1);

                    ztemp = zeros(1, ni);
                    for j = nreps:-1:1 % Cross-validation loop.
                        ztemp(1, :) = o.test(dd(j, :), idxs);
                    end;
                    z(i, :) = ztemp/nreps; % Cross-validation average
                end;
            end;
        end;

    end;
    
    methods
        function o = fsg_test(o)
            o.classtitle = 'Test';
        end;
    end;
end
