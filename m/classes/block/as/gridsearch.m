%> @brief Grid Search
%>
%> Grid search is an simple iterative way of optimization that avoids using the gradient of the objective function (F(.)). Instead, it
%> evaluates F(.) at all points within a point grid and finds to find the maximum value. A new, finer grid is then formed
%> around the point that corresponds to this maximum and the process follows.
%>
%> The idea came from the guide that comes with LibSVM [1].
%> 
%> Rather than passing a vector from the domain to the objective function, this grid search assigns values to fields
%> within a structure ('.obj') and calls the objective function ('.f_get_rate()') passing '.obj' as a parameter.
%>
%> Grid search is of course not restricted to SVM neither to classifiers.
%>
%> Not published in the GUI at the moment.
%>
%> <h3>References:</h3>
%> [1] http://www.csie.ntu.edu.tw/~cjlin/papers/guide/guide.pdf.
%>
%> @sa gridsearchparam, reptt_blockcube
classdef gridsearch < as
    properties
        %> SGS. If not supplied, the @ref data property will be expected to
        %> have at least two elements. Another option is to use obsidxs
        %> instead
        sgs;
        %> Mold classifier
        clssr;
        %> =(automatic). Cell array. Molds for the recording.
        %>
        %> Automatic logs are rates, time_train, and time_use.
        %>
        %> If passed, make sure that first log is rate, and second is time
        %>
        %> log titles will become fields inside the sovaluess.values
        %> 
        log_mold;
        %> (Optional) Block to post-process the test data. For example, a @ref grag_classes_first.
        postpr_test;
        %> Block to post-process the estimation issued by the classifier. Examples:
        %> @arg a @ref decider
        %> @arg a @block_cascade_base consisting of a @ref decider followed by a @ref grag_classes_vote
        %> There isn't a default, this must be provided
        postpr_est;
        
        %> Number of times to zoom close to best point
        no_refinements = 0;
        %> =3. Maximum number of tries per iteration. A try counts when the chosen item was on any edge. In this case, the search space will
        %> be shifted to have the chosen in the middle, without refinements
        maxmoves = 3;
        %> Array of gridsearchparam objects
        params = gridsearchparam.empty;
        %> Parameters specifications in a cell
        %>
        %> If provided, will override @ref gridsearch::params
        paramspecs;
        %> =0. Whether to run in parallel mode!
        %>
        %> @sa reptt_blockcube::flag_parallel
        flag_parallel = 0;
        %> Chooser object
        chooser;
    end;
    
    methods
        function o = gridsearch()
            o.classtitle = 'Grid Search';
            o.flag_ui = 1;
            o.flag_params = 1;
        end;
        
        %> Adds parameter using @ref gridsearchparam constructor with varargin
        function o = add_param(o, varargin)
            if numel(o.params) >= 3
                irerror('Grid search can handle a maximum of 3 variables!');
            end;
            o.params(end+1) = gridsearchparam(varargin{:});
        end;
        
        function o = assert(o)
            no_dims = length(o.params);
            if no_dims < 1
                irerror('No paramaters for gridsearch!');
            end;
            
            if o.no_refinements > 0 && ~all([o.params.flag_numeric])
                irerror('In order to refine search, all parameters must be numeric!');
            end;
        end;
        
        function o = make_defaults(o, data)
            if isempty(o.log_mold)
                ott = ttlogprovider();
                o.log_mold = ott.get_ttlogs(data);
            end;
            
            if isempty(o.chooser)
                ch = chooser(); %#ok<*CPROP,*PROP>
                ch.rate_maxloss = 0.001;
                ch.time_mingain = 0.4500;
            
                idx = find(cellfun(@(x) strcmp(x.title, 'rates'), o.log_mold)); %#ok<*EFIND>
                if isempty(idx)
                    ch.ratesname = o.log_mold{1}.title;
                % else assumes chooser_base default, which is 'rates'
                end;
                idx = find(cellfun(@(x) strcmp(x.title, 'times3'), o.log_mold));
                if isempty(idx)
                    ch.timesname = o.log_mold{2}.title;
                % else assumes chooser_base default, which is 'times3'
                end;
                o.chooser = ch;
            end;

            if ~isempty(o.paramspecs)
                o.params = gridsearchparam.empty();
                for i = 1:size(o.paramspecs, 1)
                    o.params(i) = gridsearchparam(o.paramspecs{i, :});
                end;
            end;
            
% Won't make default post-processors anymore
%             if isempty(o.postpr_est)
%                 o.postpr_est = def_postpr_est();
%                 o.postpr_test = def_postpr_test(); % Overrides pospr_test because need a harmonic pair
%             end;
        end;
    end;
    
    methods(Access=protected)
        function log = do_use(o, data)
            o = o.make_defaults(data);
            o.assert();
            
            u = reptt_blockcube();
            u.log_mold = o.log_mold;
            u.sgs = o.sgs;
            u.flag_parallel = o.flag_parallel;
            u.postpr_test = o.postpr_test;
            u.postpr_est = o.postpr_est;
            moldcube = u;
            
            params = o.params;

            % get lengths
            nj = numel(params);
            nv = 1;
            for j = 1:nj
                nvv(j) = numel(params(j).values);
                nv = nv*nvv(j);
                ticklabelss{j} = params(j).get_ticklabels();
            end;

            log = log_gridsearch();
            
            if o.flag_parallel
                parallel_open();
            end;

            % main loop
            irefin = 0;
            iiter = 1;
            imove = 0;
            nExpected = o.no_refinements+1; % Expected iterations
            ipro = progress2_open('GRIDSEARCH', [], 0, nExpected);
            while 1
                s_it = sprintf('Iteration: %d (refinement: %d; move: %d)', iiter, irefin, imove);
                
                irverbose ('**************', 2);
                irverbose(['************** Grid search ', s_it], 2);
                irverbose ('**************', 2);
                
                % Creates sovalues
                sov = sovalues();
                sov.title = s_it;
                sov.chooser = o.chooser;
                for j = 1:nj
                    p = params(j);
                    ax = raxisdata();
                    ax.label = p.get_label();
                    ax.values = p.get_values_numeric();
                    ax.ticks = p.get_ticklabels();
                    ax.legends = p.get_legends();
                    sov.ax(j) = ax;
                end;
                    
                
                % make block_cube
                idxs = cell(1, nj);
                for q = 1:nv
                    % Parameter setting
                    r = q;
                    blk = o.clssr;
                    s_spec =  '';
                    for j = 1:nj
                        p = params(j);
                        idx = mod(r-1, nvv(j))+1;
                        r = floor((r-1)/nvv(j))+1;
                        
                        eval(sprintf('blk.%s = p.get_value(idx);', p.name)); % Sets block value
                        s_spec = cat(2, s_spec, iif(j > 1, ', ', ''), p.name, '=', p.get_value_string(idx)); %ticklabelss{j}{idx});
                        idxs{j} = idx;
                    end;
                    blk.title = s_spec;
%                     fprintf('%05d %s\n', q, s_spec);

                    if nj == 1
                        idxs{2} = 1;
                    end;
                    
                    % populate the block_cube
                    molds{idxs{:}} = blk;
                    specs{idxs{:}} = s_spec;
                    idxss{idxs{:}} = idxs;
                end;
                
                % Runs stuff
                cube = moldcube;
                cube.block_mold = molds;
                cubelog = cube.use(data);

                
                % Collects results
                sov = sov.read_log_cube(cubelog, []);
                sov = sov.set_field('spec', specs);
                sov = sov.set_field('mold', molds);
                sov = sov.set_field('idxs', idxss);
                
                if nj == 1
                    sov.ax(2) = raxisdata_singleton();
                end;
                
                log.sovaluess(iiter) = sov;
                

                
                [item, idxs] = sov.choose_one();
                idxs = idxs(1:nj);
                idxs = cell2mat(idxs);
                flag_edge = any(idxs == 1) || any(idxs == nvv); % Whether any value was on the edge
                flag_shrink = 0;
                flag_moved = 0;
                if flag_edge
                    if imove >= o.maxmoves
                        irverbose(sprintf('Still hit the edge after %d moves', imove));
                        flag_shrink = 1;
                    else
                        irverbose('Hit the edge, will move to have best point in the centre', 1);
                        for j = 1:nj
                            params(j) = params(j).move_to(idxs(j));
                        end;
                        imove = imove+1;
                        nExpected = nExpected+1;
                        flag_moved = 1;
                    end;
                else
                    flag_shrink = 1;
                end;
                
                if flag_shrink && irefin < o.no_refinements
                    % Prepares for refinement
                    for j = 1:nj
                        params(j) = params(j).shrink_around(idxs(j));
                    end;
                    irefin = irefin+1;
                    imove = 0;
                elseif ~flag_moved
                    break;
                end;
                iiter = iiter+1;  

                ipro = progress2_change(ipro, [], [], iiter, nExpected);
            end;
            progress2_close(ipro);
            
            if o.flag_parallel
                % I don't need a try..."finally" for this, not critical, really
                parallel_close();
            end;
        end;
    end;        
            
    
    methods(Access=protected)
        function v = get_ticks(o, centre, length, no_points)
            x1 = centre-length/2;
            x2 = centre+length/2;
            v = linspace(x1, x2, no_points);
        end

    end;
end
