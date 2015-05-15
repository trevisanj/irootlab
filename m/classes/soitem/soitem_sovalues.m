%> SODATAITEM object with a sovalues property.
%>
%> These can be visualized through a @ref report_soitem_sovalues
classdef soitem_sovalues < soitem
    properties
        %> sovalues object
        sovalues;
    end;
    
    methods
        function o = soitem_sovalues()
            o.moreactions{end+1} = 'extract_sovalues';
        end;
        
        function sov = extract_sovalues(o)
            sov = o.sovalues;
        end;
    end;
end