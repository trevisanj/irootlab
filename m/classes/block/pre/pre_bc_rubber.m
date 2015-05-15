%> @brief Convex Polygonal Line (Rubberband-like) Baseline Correction
%>
%> The algorithm is in bc_rubber.m
%>
%> @image html rubberlike_explain.png
%>
%> @sa bc_rubber.m, demo_pre_bc_rubber.m
classdef pre_bc_rubber < pre_bc
    properties
        %> =1. Whether to trim the first and last variables, which are going to stop being variables, anyway. There may be cases when this is
        %> not desired, e.g. when the baseline correction is being carried out exclusively for visualization of the spectra, without any
        %> further analysis.
        flag_trim = 1;
    end;
    
    methods
        function o = pre_bc_rubber(o)
            o.classtitle = 'Rubberband-like';
            o.short = 'BCRubber';
            o.flag_params = 1;
        end;
    end;
    
    methods(Access=protected)
        %> Applies block to dataset
        function data = do_use(o, data)
            data.X = bc_rubber(data.X);
            
            if o.flag_trim
                data = data.select_features(2:data.nf-1);
            end;
        end;
    end;
end