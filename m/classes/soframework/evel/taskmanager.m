%>
%> Now uses database to store information
%>
%> Got this annoying "Commands out of sync; you can't run this command now" error coming from the MySQL C API. This seems to be rather an API bug
%> (I saw same case happening with Python and PHP users). In order to make it work, I coded a single multi-row INSERT; a function to try to execute
%> any query always twice (the connection is lost after that error, but if I reconnect, the query is likely to run); and an additional field "idx"
%> in table "task_tasklist". So my search key will be idscene+idx rather than the table id.
%>
classdef taskmanager
    properties
        %> Array of taskitem objects. It is a buffer to accumulate tasks to be added at once to the database.
        data = {}; %taskitem.empty;
        
        %> Name of the "scene" in the database
        scenename;
    end;
    
    properties(SetAccess=protected)
        %> Whether boot() has been called
        flag_booted = 0;
    end;
    
    properties(Access=private)
        pvt_idscene = NaN;
        
        % Computer name + random integer number
        pvt_who = NaN;
    end;
    
    properties(Dependent)
        %> scene id in table task_scene, corresponding to scene name
        idscene;
        %> Identifier of the machine running. Computer name + random integer number. Ok, may overlap but not critical.
        who;
    end;
    

    methods(Static)
        %> Calculates hash to be used as an identifier of the task
        %>
        %> Note that the scene ID and the file names suffice to uniquely define the task 
        function n = calculate_crc(idscene, fns_input, fn_output)
            n = pm_hash('crc', idscene, fns_input, fn_output);
        end;
    end;
    
    
    methods
        function i = get.idscene(o)
            o.check_booted();
            i = o.pvt_idscene;
        end;
        
        function s = get.who(o)
            o.check_booted();
            s = o.pvt_who;
        end;
        
        function o = check_booted(o)
            if ~o.flag_booted
                irerror('Call boot() first!');
            end;
        end;
        
        function o = assert_booted(o)
            if ~o.flag_booted()
                o = o.boot();
            end;
        end;
        
        function o = boot(o)
            o.assert_connected();
            
            % finds idscene corresponding to scenename
            r = irquery('select id from task_scene where name = "{S}"', o.scenename);
            if isempty(r.id)
                irerror(sprintf('Scene "%s" not registered in database!', o.scenename));
            end;
            
            o.pvt_idscene = r.id;

            
            o.pvt_who = sprintf('%s-%04d', get_computer_name(), randi([0, 9999]));
            
            irverbose(sprintf('Session name is "%s"', o.pvt_who));
            
            o.flag_booted = 1;
        end;

        

        
        %> Buffers element into the @c data structure to later be saved to database
        function [o, idx] = add_task(o, classname, fns_input, fn_output, ovrindex, cvsplitindex, dependencies, stab)
            if ~iscell(fns_input)
                fns_input = {fns_input};
            end;
            if ~isempty(dependencies)
                dependencies = dependencies(:)'; % Converts to row vector
            end;
            idx = size(o.data, 2)+1;
            o.data(:, end+1) = {o.idscene, idx, classname, cell2str(fns_input), fn_output, ovrindex, cvsplitindex, mat2str(dependencies), stab, ...
                int2str(o.calculate_crc(o.idscene, cell2str(fns_input), fn_output))};
        end;

        

        %> Returns data cell
        %>
        %> Excludes tasks that are already registered in the database
        function dat = get_filtered_data(o)
            a = irquery('select count(*) as cnt from task_tasklist where idscene = {Si}', o.idscene);
            cnt = a.cnt;
            idel = 0;
            dat = o.data;
            no_tasks = size(dat, 2);
            boo = ones(1, no_tasks);
            if cnt == 0
            else
                a = irquery('select hash from task_tasklist where idscene = {Si}', o.idscene);
                for i = no_tasks:-1:1
                    if any(a.hash == o.calculate_crc(o.idscene, dat{4, i}, dat{5, i}))
                        dat(:, i) = [];
                        boo(i) = 0;
                        idel = idel+1;
                    end;
                end;
            end;
            irverbose(sprintf('>>>>> TM >>>>> INFO: #task_list: %d; #tasks_in_db: %d; #*to add*: %d', no_tasks, cnt, size(dat, 2)), 3);
        end;

        function dat = check_tasks(o)
            dat = o.get_filtered_data();
        end;
        
        
        %> Commits the @c data buffer to the database and cleans it.
        function o = commit_tasks(o)
            dat = o.get_filtered_data();
            if isempty(dat)
                return;
            end;
            
            o.assert_connected();
            
            ONEGO = 1000; % Number of tasks to be added at once (I was experiencing too long insert time and subsequent timeout when the insert statement was too long)
            
            template = '({Si}, {Si}, "{S}", "{S}", "{S}", {Si}, {Si}, "{S}", {Si}, {S})';
            
            try
                while ~isempty(dat)
                    nrows = min(size(dat, 2), ONEGO);

                    if nrows == 1
                        vv = template;
                    else
                        vv = [repmat([template, ', '], 1, nrows-1), template];
                    end;

                    slice = dat(:, 1:nrows);
                    dat(:, 1:nrows) = [];

                    assert_connected_to_cells();
                    s = ['insert into task_tasklist ' ...
                         '(idscene, idx, classname, fns_input, fn_output, ovrindex, cvsplitindex, dependencies, stabilization, hash) values ', vv, ';'];
                    n = irquery(s, slice{:});

                    irverbose(sprintf('>>>>> TM >>>>> Number of tasks inserted: %d', n), 3);
                end;
            
                o.data = {};
            catch ME
                rethrow(ME);
            end;
        end;

        %> Runs until there is nothing else to do
        %> Returns a list of tasks run as second argument
        function [o, idxs] = run_until_all_gone(o)
            assert_connected_to_cells();
            irquery('SET autocommit = 1');

            
            irverbose(['>>>>> TM >>>>> Scene name: "', o.scenename, '"'], 3);

            
            idxs = [];
            while 1
                if o.get_flag_all_gone()
                    irverbose('>>>>> TM >>>>> All tasks are gone!', 3);
                    break;
                end;
                
                idx = o.find_next();
                if idx <= 0
                    % Supposedly there is some task with dependencies unmet, AND
                    % other processes are taking care of these tasks
                    irverbose('>>>>> TM >>>>> No task is free to run, waiting 10 seconds...', 3);
                    pause(10);
                else
                    [o, flag] = o.run_task(idx);
                    if flag
                        idxs(end+1) = idx;
                    end;
                end;
                
                pause(rand()/50);
            end;
        end;
        

        %> Resets all "failed" statuses to "0".
        function o = reset_failed(o)
            o.assert_connected();
            n = irquery('update task_tasklist set status = "0" where status = "failed" and idscene = {Si}', o.idscene);
            irverbose(sprintf('>>>>> TM >>>>> Number reset: %d', n), 3);
        end;
    end;


    
    
    %>>>>>>>>>> DANGEROUS METHODS!!!!!!!!

    methods
        %> Resets single task to "0". Called to clear ongoing status upon user pressing Ctrl+C
        function o = on_cleanup(o, id)
            global FLAG_CLEANUP;
            if FLAG_CLEANUP
                irquery('update task_tasklist set status = "0" where id = {Si}', id);
                irverbose(sprintf('>>>>> TM >>>>> Reset task id=%d', id), 3);
            end;
        end;
        
        %> Resets all "ongoing" statuses to "0". Careful!!!! Make sure no one is running any task!
        function o = reset_ongoing(o)
            o.assert_connected();
            n = irquery('update task_tasklist set status = "0" where status = "ongoing" and idscene = {Si}', o.idscene);
            
            irverbose(sprintf('>>>>> TM >>>>> Number reset: %d', n), 3);
        end;
        
        %> Resets all tasks to "0". Careful!!!! Make sure no one is running any task!
        function o = reset_all(o)
            o.assert_connected();
            n = irquery('update task_tasklist set status = "0" where idscene = {Si}', o.idscene);
            irverbose(sprintf('>>>>> TM >>>>> Number reset: %d', n), 3);
        end;
        
        
        %> Deletes all the tasks!
        function o = delete_tasks(o)
            o.assert_connected();
            n = irquery('delete from task_tasklist where idscene = {Si}', o.idscene);
            irverbose(sprintf('>>>>> TM >>>>> Number of deleted rows: %d', n), 3);
        end;
    end;
    
    
    
    
    
    
    
    
    
    %>>>>>>> "MEDIUM"-LEVEL
    %>>>>>>> These functions are all getters
    
    methods
        %> Checks whether the dependencies of a certain task are met
        function flag = get_flag_dependencies_met(o, idx)
            z = o.get_dependencies(idx);
            
            flag = 1;
            for i = 1:numel(z)
                if ~strcmp(z(i).status, 'completed')
                    flag = 0;
                    break;
                end;
            end;
        end;
        
        %> Checks whether any of the dependencies of a certain task have failed
        function flag = get_flag_dependencies_failed(o, idx)
            fprintf('.');
            z = o.get_dependencies(idx);
            
            flag = 0;
            for i = 1:numel(z)
                switch z(i).status
                    case 'failed'
                        flag = 1;
                        break;
                    case '0'
                        % If dependency hasn't run yet, maybe dependency of dependency has failed
                        flag = o.get_flag_dependencies_failed(z(i).idx);
                        if flag
                            break;
                        end;
                end;
            end;
        end;
        
        %> Checks whether all the tasks are gone = completed or failed
        function flag = get_flag_all_gone(o)
            o.assert_connected();
            flag = 1;
            
            a = irquery('select id, idx, status from task_tasklist where idscene = {Si} and status = "0" order by idx', o.idscene);
            if isempty(a)
                return;
            end;
            
            z = o.res2items(a);

            for i = 1:numel(z)
                switch z(i).status
                    case {'0'}
                        if ~o.get_flag_dependencies_failed(z(i).idx)
                            flag = 0;
                            break;
                        end;
                end;
            end;
        end;
        
        
        %> Finds next task to execute
        function idx = find_next(o)
            o.assert_connected();
            idx = 0;
            
%             while 1
                a = irquery('select id, idx, status from task_tasklist where idscene = {Si} and status = "0" order by idx', o.idscene);
                if isempty(a.id)
                    return;
                end;

                z = o.res2items(a);

                for i = 1:numel(z)
                    a = irquery('select status from task_tasklist where id = {Si}', z(i).id);
                    if strcmp(a.status{1}, '0') % Checks once more (this is very important, since the initial list is big and a lot can happen in the meanwhile)
                        if o.get_flag_dependencies_met(z(i).idx)
                            % has to check if it is still available. It is possible that it has been taken while I was checking the dependencies
                            a = irquery('select status from task_tasklist where id = {Si}', z(i).id);
                            y = o.res2items(a);
                            if strcmp(y.status, '0')
                                idx = z(i).idx;
                                break;
                            end;
                        end;
                    end;
                end;
%                 if idx > 0
%                     break;
%                 end;
%             end;
        end;
    end;
    

    
    
    %>>>>>>> LOW-LEVEL
    
    methods(Access=protected)

        %-*-*-*-*
        %-*-*-*-*
        %-*-*-*-* run_task()
        %-*-*-*-*
        %-*-*-*-*
        
        %> @return [o, flag]  @c flag signals if the task has really run
        function [o, flag] = run_task(o, idx)
            global FLAG_CLEANUP; % Controls task reset upon user pressing Ctrl+C
            flag = 0;
            o.assert_connected();
            
            
            flag_return = 0;
            irquery('begin');
            try
                a = irquery('select * from task_tasklist where idscene = {Si} and idx = {Si} lock in share mode', o.idscene, idx);
            catch ME
                irquery('rollback');
                irverbose(sprintf('>>>>> TM >>>>> (%s) The task %d is locked by someone else, ignoring request to run...', ME.message, idx), 3)
                flag_return = 1;
            end;
            if flag_return
                return;
            end;

            z = o.res2items(a);
            
% % %             % Checks if it is really available. I think I could probably delete this part, since the status can only leave '0' if the record is locked
% % %             if ~strcmp(z.status, '0')
% % %                 irquery('rollback');
% % %                 irverbose(sprintf('>>>>> TM >>>>> Task %d is no longer available, ignoring request to run...', idx), 3);
% % %                 return;
% % %             end;
            
            % Updates status
            flag_return = 0;
            try
                % Updates status & number of tries
                irquery('update task_tasklist set status = "ongoing", who = "{S}", tries = {Si}, when_started = "{S}" where id = {Si}', ...
                    o.who, z.tries+1, datestr(now(), 'yyyy-mm-dd HH:MM:SS'), z.id);
                irquery('commit');
            catch ME
                irquery('rollback');
                    irverbose(sprintf('>>>>> TM >>>>> Couldn''t set status to "ongoing" (%s) on task %d, ignoring request to run...', ME.message, idx), 3);
                    flag_return = 1;
            end;
            if flag_return
                return;
            end;


            % Finally runs the task
            try
                irverbose('>>>>> TM >>>>> RUNNING TASK:')
                irverbose(sprintf('>>>>> TM >>>>>         index: %d', idx), 3);
                irverbose(sprintf('>>>>> TM >>>>>     classname: %s', z.classname), 3);
                irverbose(sprintf('>>>>> TM >>>>> #dependencies: %s', mat2str(z.dependencies)), 3);
                irverbose(sprintf('>>>>> TM >>>>>   output file: %s', z.fn_output), 3);

                
                obj = eval([z.classname, '();']);
                obj.taskidx = idx;
                
                if isa(obj, 'goer_1i')
                    obj.fn_input = z.fns_input;
                else
                    obj.fns_input = z.fns_input;
                end;
                obj.fn_output = z.fn_output;
                
                obj.des = obj.get_session();
                
                obj.des.oo.dataloader.ovrindex = z.ovrindex;
                obj.des.oo.dataloader.cvsplitindex = z.cvsplitindex;
                obj.des.oo.cubeprovider.no_reps_stab = z.stabilization;
                
                c = onCleanup(@()o.on_cleanup(z.id));
                FLAG_CLEANUP = 1;
                obj.go();
                
                % attempts to load the newly created file (just to make sure, I was getting messages of corrupt files!)
                load(z.fn_output);
                
                flag = 1;
                
                o.assert_connected();
                irquery('update task_tasklist set status = "completed", when_finished = "{S}" where id = {Si}', ...
                    datestr(now(), 'yyyy-mm-dd HH:MM:SS'), z.id);
            catch ME
                % Failed
                
                irverbose(sprintf('>>>>> TM >>>>> ERROR EXECUTING TASK: check report on idx %d: "%s"', idx, ME.message), 3);
                
                fr = [z.failedreports, 10, '#########', 10, ME.getReport()];
                
                irquery('update task_tasklist set status = "failed", failedreports = "{S}", when_finished = "{S}" where id = {Si}', ...
                    fr, datestr(now(), 'yyyy-mm-dd HH:MM:SS'), z.id);
            end;
            FLAG_CLEANUP = 0;
        end;
    end;
    
    
    methods(Access=protected)
        %> Returns an array of taskitem objects representing the dependencies of the task identified by @c idx
        function z = get_dependencies(o, idx)
            z = taskitem.empty();
            
            o.assert_connected();
            
            % 1. retrieves the dependency indexes
            a = irquery('select dependencies from task_tasklist where idscene = {Si} and idx = {Si}', o.idscene, idx);
            dep = eval(char(a.dependencies{1})); 

            if ~isempty(dep)
                sor = '';
                for i = 1:numel(dep)
                    if i > 1; sor = cat(2, sor, ' or '); end;
                    sor = cat(2, sor, sprintf('idx = %d', dep(i)));
                end;
                % 2 - retrieves the dependency rows
                s = ['select id, idx, status from task_tasklist where idscene = {Si} and (', sor, ')'];
                a = irquery(s, o.idscene);
                z = o.res2items(a);
            end;
        end;
        
    end;
    
    methods(Static)
        %> Converts a structure returned by mYm to a @ref taskitem array
        function z = res2items(a)
            z = taskitem.empty();
            
            ff = intersect(properties(taskitem()), fields(a)); % Figures out which fields are available from the query result
            for i = 1:numel(a.(ff{1}))
                for j = 1:numel(ff)
                    if iscell(a.(ff{j}))
                        z(i).(ff{j}) = a.(ff{j}){i};
                    else
                        z(i).(ff{j}) = a.(ff{j})(i);
                    end;
                end;
                
                % eval()'s some items
                if isfield(a, 'fns_input')
                    z(i).fns_input = eval(char(z(i).fns_input));
                end;
                if isfield(a, 'dependencies')
                    z(i).dependencies = eval(char(z(i).dependencies)');
                end;
                if isfield(a, 'failedreports')
                    if ~isempty(z(i).failedreports)
                        z(i).failedreports = char(z(i).failedreports)';
                    else
                        z(i).failedreports = '';
                    end;
                end;
            end;
        end;
        
        function assert_connected()
            assert_connected_to_cells();
        end;
    end;
end
    
