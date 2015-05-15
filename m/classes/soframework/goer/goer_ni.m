%> goer_1i - Goer Multiple inputs
classdef goer_ni < goer
    properties
        %> File name where to retrieve a soitem object from.
        fns_input;
    end;
    
    methods(Sealed)
        %> Loads items soitem from file or creates own
        function items = get_input(o, des) %#ok<INUSD>
            nfi = numel(o.fns_input);
            if nfi ~= length(o.fns_input)
                irerror('nD cell of items files not supported');
            end;

            items = {};
            for i = 1:nfi
                load(o.fns_input{i});
                items{i} = r.item;
            end;
            
        end;
    end
end
