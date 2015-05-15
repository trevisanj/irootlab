%> Non-pairwise
classdef fitest_np < fitest
    methods
        %> Gives an opportunity to change somethin inside the item
        function item = process_item(o, item) %#ok<MANU>
            item.dia.sostage_cl.flag_pairwise = 0;
        end;
    end;
end