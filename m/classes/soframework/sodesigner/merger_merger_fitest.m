%> This is designed to group several soitem_merger_fitest together
%>
%> It is assumed that all the input items were obtained through analysis of the same dataset. Therefore, the "dstitle" of the output will be copied
%> from the first item
classdef merger_merger_fitest < sodesigner
    methods(Access=protected)
        function out = do_design(o)
            out = soitem_merger_merger_fitest();
            items = o.input;
            ni = numel(items);
            for i = 1:ni
                out.items(i) = items{i}; % Converts cell to object array
            end;
            out.title = ['Merge of (Set-ups + estimations) merge) (', int2str(ni), ' item', iif(ni > 1, 's', ''), ')'];
            out.dstitle = items{1}.dstitle;
        end;
    end;
end
