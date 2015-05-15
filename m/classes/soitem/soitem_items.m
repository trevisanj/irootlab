%> This SODATAITEM is generated a FOLDMERGER_FITEST class
%>
%> @sa foldmerger_fitest
classdef soitem_items < soitem
    properties
        %> cell of soitem
        items;
    end;

    methods
        function o = soitem_items()
             o.moreactions = [o.moreactions, {'extract_sovalues'}];
        end;

        %> Performs a "fold merge" of several @warning This function is not testing for incorrect dimensions within sostage.values
        function out = extract_sovalues(o)
            no_items = numel(o.items);
            
            if no_items == 0
                irerror('Items is empty!');
            end;
            if isempty(o.items{1}.sovalues)
                irerror('Item sovalues is empty!');
            end;
            
            for i = 1:no_items
                sovv(i) = o.items{i}.sovalues;
            end;
            out = sovalues.foldmerge(sovv, 1);
        end;
    end;
end
