%> @brief sostage - Classification k-NN
%>
%>
classdef sostage_cl_svm < sostage_cl
    properties
        %> SVM's C
        c = 1;
        %> SVM's gamma
        gamma = 1;
    end;

    methods(Access=protected)
        function out = do_get_base(o)
            out = clssr_svm();
            out.flag_weighted = o.flag_cb;
            out.c = o.c;
            out.gamma = o.gamma;
        end;
    end;
    
    methods
        %> Constructor
        function o = sostage_cl_svm()
            o.title = 'SVM';
            o.flag_cbable = 1;
        end;
        
        function s = get_blocktitle(o)
            s = [get_blocktitle@sostage_cl(o), sprintf('(C=%.2g,gamma=%.2g)', o.c, o.gamma)];
        end;

    end;
end
