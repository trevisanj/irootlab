%> Report deleter
classdef dircrawler_resultsdeleter < dircrawler
    properties
        pattern = [];
    end;
    methods
        function o = dircrawler_resultsdeleter()
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
                    if ss{i} == 0
                        irverbose(sprintf('  - Not removing "%s" because it has zero size.', dd{i}));
                    else
                        irverbose(sprintf('+++ Removing "%s" (%d bytes)...', dd{i}, ss{i}));
                        delete(dd{i});
                    end;
                end;
            end;
        end;
    end;
end