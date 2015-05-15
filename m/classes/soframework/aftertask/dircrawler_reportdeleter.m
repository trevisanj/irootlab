%> Report deleter
classdef dircrawler_reportdeleter < dircrawler
    methods
        function o = dircrawler_reportdeleter()
            o.patt_exclude = 'report';
        end;

        function o = process_dir(o, d)
            dd = getdirs([], [], 'report');
            for i = 1:numel(dd)
                irverbose(sprintf('- Removing "%s"...', dd{i}));
                rmdir(dd{i}, 's');
            end;
        end;
    end;
end