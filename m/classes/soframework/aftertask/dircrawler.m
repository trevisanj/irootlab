%> Directory crawler
classdef dircrawler
    properties
        %> ='.'. Root directory
        rootdir = '.';
        %> If specified, directories will have to match this pattern
        patt_match;
        %> If specified, directories will have NOT TO match this pattern
        patt_exclude;
        %> =1. whether to cd into the directory before calling process_dir()
        flag_cd = 1;
    end;
    
    methods(Abstract)
        o = process_dir(o, d);
    end;

    % These methods can be overriden
    methods
        %> Currently doing nothing
        function o = finish(o)
        end;
        
        %> Currently doing nothing
        function o = start(o)
        end;
    end;
    
    methods
        function o = go(o)
            o = o.start();
            here = pwd();
            
            dirs = getdirs(o.rootdir, [], o.patt_match, o.patt_exclude);
            
            for i = 1:numel(dirs)
                d = dirs{i};
                
                flag_continue = 1;
                if o.flag_cd
                    try
                        cd(d);
                    catch ME %#ok<NASGU>
                        irverbose(sprintf('(dircrawler::go()) Failed cd''ing into directory "%s"', d, 3));
                        flag_continue = 0;
                    end;
                end;
                
                if flag_continue
                    try
                        irverbose(sprintf('Processing "%s" ...', d), 3);
                        o = o.process_dir(d);
                    catch ME
                        irverbose(sprintf('(dircrawler::go()) Failed processing directory "%s": %s', d, ME.message), 3);
                        if get_envflag('FLAG_RETHROW'); rethrow(ME); end;
                    end;
                
                    if o.flag_cd
                        cd(here);
                    end;
                end;
            end;
            
            o = o.finish();
        end;
    end;
end