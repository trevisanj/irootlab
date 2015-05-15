%> @brief Takes absolute value of data X
classdef pre_abs < pre
    methods
        function o = pre_abs()
            o.classtitle = 'Absolute value';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        %> Applies block to dataset
        function data = do_use(o, data)
            data.X = abs(data.X);
        end;
    end;
end