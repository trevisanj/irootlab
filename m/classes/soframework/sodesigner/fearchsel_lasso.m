%> Feature Extraction Design - Feature Selection using the LASSO algorithm
%>
%>
classdef fearchsel_lasso < fearchsel_fs_base
    methods
        %> Constructor
        function o = fearchsel_lasso()
            o.classtitle = 'FS_LASSO';
        end;

        function fb = get_as_fsel(o, ds, dia) %#ok<*INUSD>
            fb = as_fsel_lasso();
            fb.nf_select = o.oo.fearchsel_lasso_nf_max;
        end;        
    end;    
end
