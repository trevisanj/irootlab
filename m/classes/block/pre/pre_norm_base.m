%> @brief Normalization - base class
%>
%> Uses normaliz.m to do the job.
%>
%> @sa pre_norm, normaliz.m
classdef pre_norm_base < pre
    properties
        %> See normaliz.m
        types = 'c';
        %> See normaliz.m
        idxs_fea = [];
    end;

    
    methods
        function o = pre_norm_base(o)
            o.classtitle = 'Normalization';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)

        %> Applies block to dataset
        function data = do_use(o, data)
            data.X = normaliz(data.X, data.fea_x, o.types, o.idxs_fea);
        end;
    end;
end