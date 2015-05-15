%> Merges several sovalues objects in the "fold" level.
%>
%> "fold" level means columnwise, field by field
%>
%> result.values(i, j, ...).rates = [r1.values(i, j, ...).rates, r2.values(i, j, ...).rates, ...]
classdef ropr_merge_folds < block
    methods
        function o = ropr_merge_folds(o)
            o.classtitle = 'SOVALUES merger-foldwise';
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, in)
    
            n = numel(in);
            for i = 1:n
                r = in(i);
                if i == 1
                    si = size(r.values);
                    nj = numel(r.values);
                    ff = fields(r.values);
                    out = r; % result starts being the first one
                else
                    if ~isequal(size(r.values), si)
                        irerror(sprintf('values dimensions do not match; item 1: %s; item %d: %s', mat2str(si), i, mat2str(size(r.values))));
                    end;
                    if ~isequal(fields(r.values), ff)
                        irerror(sprintf('Fields don''t match between indexes %d and %d', 1, i));
                    end;
                    

                    for j = 1:nj
                        for e = 1:numel(ff)
                            out.values(j).(ff{e}) = [out.values(j).(ff{e}), r.values(j).(ff{e})];
                        end;
                    end;
                end;
            end;
        end;
    end;  

end
