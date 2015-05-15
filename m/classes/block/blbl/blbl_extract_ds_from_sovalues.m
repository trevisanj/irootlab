%> @brief Extracts dataset from sovalues
classdef blbl_extract_ds_from_sovalues < blbl
    properties
        %> ={[Inf, 0, 0], [1, 2]}
        %> @sa sovalues.m
        dimspec = {[Inf, 0, 0], [1, 2]};
        
        %> =rates
        valuesfieldname = 'rates';
    end;
    
    methods
        function o = blbl_extract_ds_from_sovalues()
            o.classtitle = 'Extract dataset';
            o.inputclass = {'sovalues'};
        end;
    end;
    
    methods(Access=protected)
        function ds = do_use(o, sov)
            [values, ax] = sovalues.get_vv_aa(sov.values, sov.ax, o.dimspec);
            
            ds = irdata();
            ds.title = [sov.title, ' - ', o.valuesfieldname];
            
            V = permute(sov.getYY(values, o.valuesfieldname), [3, 2, 1]);
            [no_folds, no_tuning, no_features] = size(V);
            
            ds.X = reshape(V, [no_folds*no_tuning, no_features]);
            ds.classes = reshape(repmat(0:no_tuning-1, no_folds, 1), [no_folds*no_tuning, 1]);
            ds.classlabels = ax(2).legends;
            
            ds.fea_names = sov.ax(1).ticks;
            ds.xname = ax(1).label;
            ds.xunit = '';
            ds.fea_x = ax(1).values;
            ds.yname = labeldict(o.valuesfieldname);
            ds.yunit = '';
            
            ds = ds.assert_fix();
        end;

    end;
end
