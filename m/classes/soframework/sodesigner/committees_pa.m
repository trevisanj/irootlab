%> Non-pairwise
classdef committees_pa < committees
    methods
        function dia = process_dia(o, dia) %#ok<MANU>
            dia.sostage_cl.flag_pairwise = 1;
        end;
    end;
end