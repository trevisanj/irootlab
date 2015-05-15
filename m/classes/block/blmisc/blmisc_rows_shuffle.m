%> @brief Shuffles rows keeping spectra from the same group together or not
classdef blmisc_rows_shuffle < blmisc_rows
    properties
        %> whether to keep spectra from the same group together or not
        flag_group = 1;
    end;
    
    methods
        function o = blmisc_rows_shuffle(o)
            o.classtitle = 'Shuffle';
            o.flag_params = 0; % I won't publish flag_group because will always want them together anyway
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            if ~o.flag_group
                p = randperm(data.no);
                data = data.map_rows(p);
            else
                p = randperm(data.no_groups);
                data = data.map_rows(data.get_obsidxs_from_groupidxs(p));
            end;
        end;
    end;  
end

