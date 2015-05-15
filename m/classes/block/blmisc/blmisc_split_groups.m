%> @brief Splits dataset per group, one dataset per group
%>
%> Attention: this operation creates one dataset per group, this can be a lot!
%>
classdef blmisc_split_groups < blmisc_split
    methods
        function o = blmisc_split_groups(o)
            o.classtitle = 'Groups';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function datasets = do_use(o, data)
            datasets = data_split_groups(data);
        end;
    end;  
end

