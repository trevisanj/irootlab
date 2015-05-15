%> @brief Multi-Stage Complex Outlier Removal
%>
%> Uses a sequence of ( @c block , @c blmisc_rowsout ) pairs to output two datasets as any @c blmisc_rowsout block.
%>
%> Not published in UI
classdef blmisc_rowsout_multistage < blmisc_rowsout
    properties
        %> ={}. Processors blocks.
        processors = {};
        %> ={}. @c blmisc_rowsout blocks
        removers = {};
        %> =0 (cascade). Possibilities:
        %> @arg 0 - "cascade". Runs step on output of previous step.
        %> @arg 1 - "intersection". Removes only the outliers yielded by all the stages.
        %> @arg 2 - "union". Removes the outliers yielded by any of the stages.
        mode = 0;
        
        log;
    end;
    
    methods
        function o = blmisc_rowsout_multistage()
            o.classtitle = 'Multi-Stage';
        end;
    end;

    methods
        function o = calculate_map(o, data)
            o.log = log_blmisc_rowsout_multistage();
            o.log.mode = o.mode;
            o.log.inputno = data.no;

            ns = length(o.processors);
            
            datai = data; % working dataset
            ipro = progress2_open('BLMISC_ROWSOUT_MULTISTAGE', [], 0, ns);
            for i = 1:ns
                if ~isempty(o.processors{i}) % data does not necessarily need to be processed before outlier removal
                    o.processors{i} = o.processors{i}.boot();
                    o.processors{i} = o.processors{i}.train(datai);
                    datao = o.processors{i}.use(datai);
                else
                    datao = datai; % bypass
                end;
                o.removers{i} = o.removers{i}.train(datao);
                map = o.removers{i}.map;
                maps{i} = map;

                o.log.stagesno(i) = numel(map);
                
                if o.mode == 0
                    datai = datai.map_rows(map);
                end;
                
                ipro = progress2_change(ipro, [], [], i);
            end;
            progress2_close(ipro);
            
            
            if o.mode > 0
                map = maps{i};
                for i = 2:ns
                    if o.mode == 1 % intersection
                        map = intersect(map, maps{i});
                    elseif o.mode == 2 % union
                        map = union(map, maps{i});
                    else
                        irerror(sprintf('Invalid mode: %d', o.mode));
                    end;
                end;
                o.map = map;
            else
                map = maps{1};
                for i = 2:ns
                    map = map(maps{i});
                end;
                o.map = map;
            end;
            
            o.log.maps = maps;
            o.log.map = o.map;
        end;
    end;
end

