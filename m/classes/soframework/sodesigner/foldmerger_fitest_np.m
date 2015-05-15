%> Non-pairwise
classdef foldmerger_fitest_np < foldmerger_fitest
    methods
        %> Gives an opportunity to change somethin inside the dia
        function dia = process_dia(o, dia) %#ok<MANU>
            dia.sostage_cl.flag_pairwise = 0;
        end;
    end;
end