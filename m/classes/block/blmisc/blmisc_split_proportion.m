%> @brief Splits dataset in two according to proportion specified 
%>
%> @sa uip_blmisc_split_proportion.m
classdef blmisc_split_proportion < blmisc_split
    properties
        %> = 0.9.
        proportion = 0.9;
        %> =1: whether to keep spectra from the same group together or not.
        flag_group = 1;
    end;
    
    methods
        function o = blmisc_split_proportion(o)
            o.classtitle = 'Proportion';
        end;
    end;
    
    methods(Access=protected)
        function datasets = do_use(o, data)
            if ~o.flag_group || isempty(data.groupcodes)
                p = randperm(data.no);
                cut = floor(data.no*o.proportion);
                datasets = data.split_map({p(1:cut), p(cut+1:end)});
            else
                p = randperm(data.no_groups);
                cut = floor(data.no_groups*o.proportion);
                v1 = data.get_obsidxs_from_groupidxs(p(1:cut));
                v2 = data.get_obsidxs_from_groupidxs(p(cut+1:end));
                datasets = data.split_map({v1, v2});
            end;
        end;
    end;  
end

