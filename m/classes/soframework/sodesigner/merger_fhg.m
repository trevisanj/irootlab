%> Merges several "fhg merges" into a single overall item
classdef merger_fhg < sodesigner
    methods(Access=protected)
        function out = do_design(o)
            items = o.input;
            ni = numel(items);
            
            out = soitem_merger_fhg();
            
            for i = 1:ni
                it = items{i};
                out.s_methodologies{i} = it.s_setup;
                out.stabs(i) = it.stab;
                if i == 1
                    out.logs = it.log;
                else
                    out.logs(i) = it.log;
                end;
            end;
            
            out.title = ['Merge of ', int2str(ni), ' FHG', iif(ni > 1, '''s', '')];
            out.dstitle = items{1}.dstitle;
        end;
    end;
end
