%> @brief sostage - Classification k-NN
%>
%>
classdef sostage_cl_ann < sostage_cl
    properties
        %> Hidden layer spec
        hiddens;
    end;

    methods(Access=protected)
        function out = do_get_base(o)
            out = clssr_ann();
            out.hiddens = o.hiddens;
            out.flag_weighted = o.flag_cb;
        end;
    end;
    
    methods
        %> Constructor
        function o = sostage_cl_ann()
            o.title = 'ANN';
            o.flag_cbable = 1;
        end;
        
        function s = get_blocktitle(o)
            s = [get_blocktitle@sostage_cl(o), '(', mat2str(o.hiddens), ')'];
        end;
    end;
end
