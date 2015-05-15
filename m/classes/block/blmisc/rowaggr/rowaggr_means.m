%> @file
%> @ingroup groupgroup classlabelsgroup
%> @brief Outputs a dataset of class means
classdef rowaggr_means < rowaggr
    methods
        function o = rowaggr_means()
            o.classtitle = 'Class means';
            o.flag_trainable = 0;
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, data)
            
            ucl = unique(data.classes);
            ncl = numel(ucl);

            out = data.copy_emptyrows();
            out.groupcodes = out.classlabels(ucl+1)'; % Makes group codes as class labels themselves (but only the ones that have spectra)
            out.classes = ucl;
            out.X = zeros(ncl, data.nf);
            
            for i = 1:ncl
                out.X(i, :) = mean(data.X(data.classes == ucl(i), :), 1);
            end;

            out = out.assert_fix();
        end;
    end;
end