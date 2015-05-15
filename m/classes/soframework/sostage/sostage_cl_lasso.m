%> @brief sostage - Classification k-NN
%>
%>
classdef sostage_cl_lasso < sostage_cl
    properties
        %> =10. Has the prefix "lasso" so that it won't be confused with othe nf's in this class
        nf = 10;
        flag_precond = 0;
        precond_threshold = 0;
        precond_no_factors = 10;
        
        %> This is result for biomakers
        L;
    end;

    methods(Access=protected)
        function out = do_get_base(o)
            if o.flag_cb
                irerror('LASSO cannot counterbalance!');
            end;
            out = clssr_lasso();
            out.nf_select = o.nf;
            out.flag_precond = o.flag_precond;
            out.precond_threshold = o.precond_threshold;
            out.precond_no_factors = o.precond_no_factors;
        end;
    end;
    
    methods
        %> Constructor
        function o = sostage_cl_lasso()
            o.title = 'LASSO';
            o.flag_cbable = 0;
            o.flag_2class = 1;
            o.flag_embeddedfe = 1;
        end;
        
        
        function s = get_blocktitle(o)
            s = [get_blocktitle@sostage_cl(o), '(nf=', mat2str(o.nf), ')'];
        end;
    end;
end
