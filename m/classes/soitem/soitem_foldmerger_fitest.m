%> This SOITEM is generated a FOLDMERGER_FITEST class
%>
%> @sa foldmerger_fitest
classdef soitem_foldmerger_fitest < soitem_items
    properties
        %> cell of ttlogs
        logs;
        %> Cell of diagnosissystem objects. Each element corresponds to one system found at one fold of the k-fold cross-validation
        diaa;
    end;

    methods
        function o = soitem_foldmerger_fitest()
        end;
    end;
end
