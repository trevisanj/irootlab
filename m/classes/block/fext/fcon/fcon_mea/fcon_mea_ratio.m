%> @brief Ratio between the X matrix of two datasets
classdef fcon_mea_ratio < fcon_mea
    methods
        function o = fcon_mea_ratio(o)
            o.classtitle = 'Ratio';
            o.flag_params = 0;
            o.flag_multiin = 1;
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, dataa)
            if numel(dataa) < 2
                irerror('I need two datasets to take ratios!');
            end
            
            if any(dataa(2).X) == 0
                irerror('Second dataset has ZERO elements; cannot divide by zero!');
            end;
            
            if ~(dataa(1).no == dataa(2).no && dataa(1).nf == dataa(2).nf)
                irerror(sprintf('Two datasets must have same number of observations and number of features.\nDataset 1 has no=%d and nf=%d;\nDataset 2 has no=%d and nf=%d.\n', ...
                    dataa(1).no, dataa(1).nf, dataa(2).no, dataa(2).nf));
            end;
            
            data = dataa(1);
            data.fea_x = 1;
            
            
            data.X = dataa(1).X./dataa(2).X;
        end;
    end;
end
