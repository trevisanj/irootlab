%> @brief sostage - Rubberband -> Normalization
%>
%> The normalization defaults to Vector because Amide I was giving trouble
%> after feature averaging
%>
classdef sostage_pp_rubbernorm < sostage_pp
    properties
        %> ='n'. Defaults to "Vector Normalization
        %> @warning Must not have any vertical normalization (e.g. standardization or mean-centering)! Because the pre-processing is applied to training and test sets separately sometimes.
        normtypes = 'n';
    end;

    methods
        function o = sostage_pp_rubbernorm()
            o.title = 'RBBC-N';
        end;

        function s = get_blocktitle(o)
            s = [get_blocktitle@sostage_pp(o), '(', o.normtypes, ')'];
        end;
    end;
    
    methods(Access=protected)
        function a = get_blocks(o)
            rbbc = pre_bc_rubber();
            rbbc.flag_trim = 1;
            norer = pre_norm();
            norer.types = o.normtypes;
            a = {rbbc, norer};
        end;
    end;
end
