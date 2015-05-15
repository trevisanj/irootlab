%> Manipulates a sodesigner object
%>
%> Way of input is not defined
%>
%>
classdef goer < filesession
    properties
        %> File name where to save soitem object to.
        fn_output;
        
        %> (string) Name of the class to create an instance of
        classname;
        
        %> The sodesigner within
        des;
        
        %> Task index
        taskidx;
    end;

    methods
        function o = goer()
            o = o.setup();

            if isempty(o.fn_output)
                s = class(o);
                i = strfind(s, '_');
                if isempty(i)
                    irerror(sprintf('I don''t like to be called "%s", can''t you give me a proper name?', s));
                end;
                i = i(1);
                o.fn_output = ['output_', s(i+1:end), '.mat']; %pwdprefixed(['output_', s(i+1:end), '.mat']);
                irverbose(sprintf('Assigned default output filename "%s"', o.fn_output));
            end;
        end;
    end;

    methods(Abstract)
        %> Need to setup the properties here 
        o = setup(o);
        
        input = get_input(o, des);
    end;
    
    methods
        %> Use this function to setup a sodesigner in a way that is not general enough to deserve its own class
        %>
        %> For example, altering the NF_MAX of s FEARCHSEL_FFS for a specific classifier
        %>
        %> This method typically has assignments like <code>d.oo.xxxxxx = zzzzzz;</code>
        function d = customize_session(o, d)
        end;
    end;
    
    methods(Sealed)
        %> Returns sodesigner object with soitem object assigned.
        %>
        %> The soitem object is either created or loaded from file.
        function des = get_session(o)
            if isempty(o.classname)
                irerror(sprintf('classname property of class "%s" hasn''t been assigned', class(o)));
            end;
            
            des = eval([o.classname, '();']);
            des = o.customize_session(des);
            des = des.configure();
            
            des.input = o.get_input(des);
        end;
    end

    methods(Access=protected, Sealed)
        function o = do_go(o)
            if isempty(o.des)
                o.des = o.get_session();
            end;
            
            irverbose(sprintf('_..ooO TAKING CASE "%s"...', o.fn_output), 2);

            if isempty(o.des.input)
                irverbose(sprintf('_..ooO EMPTY ITEM, nothing to do!'));
            else
                pp = pwd();
                try

                    t = tic();
                    o.des = o.des.go();
                    r.time_go = toc(t);
                    r.item = o.des.output;
                    r.taskidx = o.taskidx;

                    % I don't know why sometimes the file is saved corrupted!
                    % The solution is to try loading after saving and try re-saving if not ok
                    flag_ok = 0;
                    lastME = [];
                    for i = 1:5
                        save(o.fn_output, 'r');
                        try
                            r_save = r;
                            load(o.fn_output)
                            flag_ok = 1;
                        catch ME
                            irverbose(sprintf('-..ooOOOOps %d', i));
                            r = r_save;
                            lastME = ME;
                        end;
                        if flag_ok
                            break;
                        end;
                    end;
                    if ~flag_ok
                        irerror(sprintf('What a shame! Failed properly saving file "%s": %s', o.fn_output, lastME.message));
                    end;
                            
                    irverbose(sprintf('_..ooO Total ellapsed time: %.1f seconds', r.time_go()), 2);
                    irverbose(sprintf('_..ooO Saved result to file "%s"', o.fn_output), 2);
                catch ME
                    cd(pp);
                    irverbose(sprintf('_..ooOOO Case "%s" failed: %s', o.fn_output, ME.message), 2);
%                     if get_envflag('FLAG_RETHROW')
                    % Actually, has to rethrow all the time now, so that the error be caught by the task manager
                    rethrow(ME);
%                     end;
                end;
                cd(pp);
            end;
        end;
    end;
end
