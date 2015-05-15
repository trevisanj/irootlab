%> @brief sostage - Differentiation followed by vector normalization
%>
%>
classdef sostage_pp_diffnorm < sostage_pp
    properties
        diff_order = 1;
        diff_porder = 2;
        diff_ncoeff = 9;
        %> ='n'. Defaults to "Vector Normalization"
        %> @warning Must not have any vertical normalization (e.g. standardization or mean-centering)! Because the pre-processing is applied to training and test sets separately sometimes.
        normtypes = 'n';
    end;
    
    methods
        function o = sostage_pp_diffnorm()
            o.title = 'Diff-N';
        end;
        function s = get_blocktitle(o)
            s = [get_blocktitle@sostage_pp(o), '(', o.normtypes, ')'];
        end;
    end;

    methods(Access=protected)
        function a = get_blocks(o)

            difer = pre_diff_sg();
            difer.order = o.diff_order;
            difer.porder = o.diff_porder;
            difer.ncoeff = o.diff_ncoeff;
        
            norer = pre_norm();
            norer.types = o.normtypes;

            a = {difer, norer};
        end;
    end;
end
