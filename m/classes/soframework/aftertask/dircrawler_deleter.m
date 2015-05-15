%> General file deleter
classdef dircrawler_deleter < dircrawler
    properties
        pattern = [];
    end;
    methods
        function o = dircrawler_deleter()
            o.patt_exclude = 'report';
        end;

        function o = process_dir(o, d)
            if isempty(o.pattern)
                irerror('Pattern is empty');
            end;

            
            dd = dir(o.pattern);
            if ~isempty(dd)
                ss = {dd.bytes};
                dd = {dd.name};
                for i = 1:numel(dd)
                    irverbose(sprintf('+++ Removing "%s" (%d bytes)...', dd{i}, ss{i}));
                    delete(dd{i});
                end;
            end;
        end;
    end;
end