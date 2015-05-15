%> Non-pairwise
classdef committees_np < committees
    methods
        function dia = process_dia(o, dia) %#ok<MANU>
            dia.sostage_cl.flag_pairwise = 0;
        end;
    end;
end