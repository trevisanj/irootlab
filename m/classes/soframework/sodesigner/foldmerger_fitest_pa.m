%> Pairwise
classdef foldmerger_fitest_pa < foldmerger_fitest
    methods
        %> Gives an opportunity to change somethin inside the dia
        function dia = process_dia(o, dia) %#ok<MANU>
            dia.sostage_cl.flag_pairwise = 1;
        end;
    end;
end