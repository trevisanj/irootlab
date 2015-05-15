%> goer_1i - Goer One Input
classdef goer_1i < goer
    properties
        %> File name where to retrieve a soitem object from.
        fn_input;
    end;
    
    methods(Sealed)
        %> Loads input soitem from file or creates own
        function input = get_input(o, des)
            if isempty(o.fn_input) || iscell(o.fn_input) && isempty(o.fn_input{1})
                input = soitem_sostagechoice();
                input.dia = des.get_initialdia();
            else
                fn = o.fn_input; % A bit of tolerance against input filename being given inside cell
                if iscell(fn)
                    fn = o.fn_input{1};
                end;
                irverbose(sprintf('Loading soitem from file "%s"', fn));
                load(fn);
                input = r.item;
            end;
        end;
    end

end
