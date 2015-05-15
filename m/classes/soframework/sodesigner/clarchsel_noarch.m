%> ClArchSel base class for those classifiers with nothing to be optimized
classdef clarchsel_noarch < clarchsel
    methods        
        function o = customize(o)
            o = customize@clarchsel(o);
        end;        
    end;
    
    methods(Abstract)
        %> LDC, QDC, DIST, all differ only in which sostage_cl that they use
        sos = get_sostage_cl(o);
    end;
        
    
    methods(Access=protected)
        function out = do_design(o)
            item = o.input;
            dia = item.get_modifieddia();
            dia.sostage_cl = o.get_sostage_cl();
            
            out = soitem_sostagechoice();
            out.sovalues = [];
            out.dia = dia;
            out.title = o.make_title_dia(out.dia);
            out.dstitle = '(not used)';
        end;
    end;
end

