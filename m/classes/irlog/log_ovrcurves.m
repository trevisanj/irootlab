%>@brief Stores set of grades as a matrix
%>
%> Although it is called log_*ovr*curves, the name is purely etymological. This log is generic enough to store any set of grades curves
classdef log_ovrcurves < irlog
    properties
        %> (nf)x(number of grades) matrix
        gradess;
        %> Legends: meaning of each row within gradess
        legends = {};
        
        %> Extracted from data
        fea_x;
        %> Extracted from data
        xname = '';
        %> Extracted from data
        xunit;
        %> Describes what the "grades" represent
        yname;
        %> Describes what the "grades" represent
        yunit;
        
        %> Index of reference class.
        idx_ref = 1;
    end;
    
    properties
        nf;
    end;
    
    methods
        function o = log_ovrcurves()
            o.flag_ui = 0;
        end;
        
        function n = get.nf(o)
            n = numel(o.fea_x);
        end;
        
    end;
end
