%> @brief Concentrates system optimization information
%>
%>
classdef sodata < irlog
    properties
        %> "go" time
        time_go;
        %> sodataitem object
        item = [];
        %> Where the computation took place (computer name)
        where = '?';
    end;
end
