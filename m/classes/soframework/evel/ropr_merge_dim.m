%> Merges several sovalues objects along a given dimension
classdef ropr_merge_dim < block
    properties
        dim = 1;
        flag_redo_axis = 0;
    end;
    methods
        function o = ropr_merge_dim(o)
            o.classtitle = 'SOVALUES merger-dimension-wise';
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
                    out.values = cat(o.dim, out.values, r.values);
                    if ~o.flag_redo_axis
                        out.ax(dim).values = [out.ax(dim).values, r.ax(dim).values];
                        out.ax(dim).ticks = [out.ax(dim).ticks, r.ax(dim).ticks];
                        out.ax(dim).legends = [out.ax(dim).legends, r.ax(dim).legends];
                    end;
                end;
            end;
            
            % if concatenation was successful, proceeds to fixing the axis
             
            
        end;
    end;  

end
