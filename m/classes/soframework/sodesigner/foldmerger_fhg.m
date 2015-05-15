%> Merges individual cross-validation-fold-wise log_fselrepeater objects
classdef foldmerger_fhg < sodesigner
    methods(Access=protected)
        function out = do_design(o)
            out = soitem_fhgs();

            items = o.input;
            ni = numel(items);
            if ni > 0
                item1 = items{1};
                logs(1) = item1.log; % first log_fselrepeater 
                log = item1.log; 
                for i = 2:ni
                    % ... merges with other log_fselrepeater
                    temp = items{i}.log;
                    logs(i) = temp;
                    log.logs = [log.logs, temp.logs];
                end;

                out.items = o.input;
                out.logs = logs;
                out.log = log;
                out.stab = item1.stab;
                out.s_setup = item1.s_setup;
                out.title = o.make_title_dia(item1.dia);
                out.dstitle = item1.dstitle;
            end;
        end;
    end;
end


                
                
                
