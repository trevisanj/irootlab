%> @brief sostage - Classification k-NN
%>
%>
classdef sostage_cl_knn < sostage_cl
    properties
        k = 1;
    end;
    methods(Access=protected)
        function out = do_get_base(o)
            if o.flag_cb
                irerror('k-NN cannot counterbalance!');
            end;
            out = clssr_knn();
            out.k = o.k;
        end;
    end;
    
    methods
        %> Constructor
        function o = sostage_cl_knn()
            o.title = 'k-NN';
            o.flag_cbable = 0;
        end;
        
        function s = get_blocktitle(o)
            s = [get_blocktitle@sostage_cl(o), '(k=', int2str(o.k), ')'];
        end;
    end;
end
