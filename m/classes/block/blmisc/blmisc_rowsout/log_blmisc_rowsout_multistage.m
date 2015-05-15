%> @brief Log for the @ref blmisc_rowsout_multistage block activity
%> @sa @ref blmisc_rowsout_multistage
classdef log_blmisc_rowsout_multistage < irlog
    properties
        mode;
        %> Number of observations of the input dataset
        inputno;
        %> Number of observations selected at each stage
        stagesno;
        maps;
        map;
    end;
    
    methods
        function s = get_text(o)
            smodes = {'Cascade', 'Intersection', 'Union'};
            s = '';
            s = cat(2, s, 'Mode: ', smodes{o.mode+1}, 10);
            s = cat(2, s, 'Number initial: ', int2str(o.inputno), 10);
            
            if o.mode > 0
                for i = 1:length(o.maps)
                    s = cat(2, s, 'Stage ', int2str(i), ', number kept: ', int2str(numel(o.maps{i})), 10);
                end;
            else
                no = o.inputno;
                for i = 1:length(o.maps)
                    nr = no-numel(o.maps{i});
                    no = no-nr;
                    s = cat(2, s, 'Stage ', int2str(i), ', number removed: ', int2str(nr), 10);
                end;
            end;
            
            s = cat(2, s, 'Number kept: ', int2str(numel(o.map)), 10, 'Number removed: ', int2str(o.inputno-numel(o.map)), 10);
        end;
    end;
    
    methods(Access=protected)
        function s = do_get_html(o)
            s = [do_get_html@irlog(o), '<pre>', 10, o.get_text(), 10, '</pre>', 10];
        end;
    end;
end

