%> Feature Selection common sostage_fe
%>
%>
%>
classdef sostage_fe_fs < sostage_fe
    properties
        %> Vector of features (to be restricted by .nf, if this is
        %que case)
        v;
        
        %> Yes, this is important
        fea_x;
        
        grades;
    end;
    
    methods
        function o = sostage_fe_fs()
            o.title = 'FS';
        end;
        
    end;    
    
    methods(Access=protected)
        function out = do_get_block(o)
            out = fsel();
            out.v = [];
            out.v = o.v;
            out.fea_x = o.fea_x;
            if ~isempty(o.nf)
                out.v = out.v(1:min(numel(out.v), o.nf));
            end;
            
            if ~isempty(o.grades)
                out.grades = o.grades;
            else
                % Makes default grades according to ranking
                ranking = numel(out.v):-1:1;
                out.grades = zeros(1, numel(out.fea_x));
                out.grades(out.v) = ranking;
            end;
        end;
        
        function out = do_get_bio(o)
            out = o.do_get_block();
        end;
    end;
end
