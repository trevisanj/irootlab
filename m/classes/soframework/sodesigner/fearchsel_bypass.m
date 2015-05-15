%> FEARCHSEL_BYPASS: design does nothing except for make the sostage_fe of the diagnosissytem into a sostage_fe_bypass
classdef fearchsel_bypass < fearchsel
    properties
        nfs;
    end;
    
    methods        
        function o = customize(o)
            o = customize@fearchsel(o);
        end;        
    end;

    methods(Access=protected)
        function out = do_design(o)
            item = o.input;
            dia = item.get_modifieddia();
            dia.sostage_fe = sostage_fe_bypass();

            out = soitem_sostagechoice();
            out.sovalues = [];
            out.dia = dia;
            out.title = o.make_title_dia(out.dia);
            out.dstitle = '(not used)';
        end;
    end;
end
