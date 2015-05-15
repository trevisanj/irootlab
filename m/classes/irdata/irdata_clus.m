%> @brief Dataset class - cluster data
%>
%> These datasets are outputted by a @ref clus block
%>
%> @sa clus
classdef irdata_clus < irdata
    methods
        %> Constructor
        function data = irdata_clus(data)
            data.classtitle = 'Cluster Data';
        end;
    end;
end
