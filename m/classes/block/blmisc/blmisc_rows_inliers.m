%> @brief Select inliers only.
%>
%> Discards all dataset rows whose class is <= -1, (outliers, refuse-to-decide, and refuse-to-cluster).
%>
%> @sa classnumbers
classdef blmisc_rows_inliers < blmisc_rows
    methods
        function o = blmisc_rows_inliers()
            o.classtitle = 'Inliers';
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            data = data_select_inliers(data);
        end;
    end;  
end

