%> @brief Analysis Session - Feature Selection Repeater
%>
%> This is the starting point to generate a histogram
classdef fselrepeater < as
    properties
        %> Subset Generation Specs to guide generation of different datasets to be passed to the Feature selection object.
        sgs;
        %> Feature selection object.
        as_fsel;
        %> Feature extractor to be used before passing the dataset to the feature selector. This may be used, e.g., if you want to
        %> produce a histogram of the best, e.g., Principal Component Analysis factors. Instead of passing an already PCA-transformed
        %> dataset to the as_fselrep, you can pass the PCA block in the @c fext property, so that at each iteration, the PCA block
        %> will be trained with the training set of that iteration only, not the whole dataset.
        fext;
        %> =0. Whether to parallelize the Feature Selection repetitions
        flag_parallel = 0;
    end;
    
    methods
        function o = fselrepeater()
            o.classtitle = 'Feature Selection Repeater';
        end;
    end;
    
    methods(Access=protected)
        %> Creates a @ref log_fselrepeater object
        %>
        %> This function may pass 1 or 2 datasets to the @ref as_fsel, depending on the @ref sgs property. It
        %> does not check whether the @ref as_fselrep::as_fsel needs one or two datasets.
        function log = do_use(o, data)
            flag_fext = ~isempty(o.fext);
            if flag_fext
                ff = o.fext.boot();
            else
                ff = [];
            end;

            obsidxs = o.sgs.get_obsidxs(data);
            [no_reps, no_bites] = size(obsidxs); %#ok<NASGU>
            
            if ~o.flag_parallel
                %---> Non-parallel version
                ipro = progress2_open('Feature Selection Repeater', [], 0, no_reps);
                for i_rep = 1:no_reps % Cross-validation loop
                    % #SAMECODE begin
                    datanow = data.split_map(obsidxs(i_rep, :), [], ff);
                    fsel_ = o.as_fsel;
                    log = fsel_.use(datanow); % GO!
                    logs(i_rep) = log;
                    % #SAMECODE end

                    ipro = progress2_change(ipro, [], [], i_rep);
                end;
                progress2_close(ipro);
            else
                %---> PARALLEL version
                parallel_open();
                t = tic();

                parfor i_rep = 1:no_reps % Cross-validation loop
                    % #SAMECODE begin
                    datanow = data.split_map(obsidxs(i_rep, :), [], ff); %#ok<PFBNS>
                    fsel_ = o.as_fsel;
                    fsel_.data = datanow;
                    log = fsel_.go(); % GO!
                    logs(i_rep) = log;
                    % #SAMECODE end
                    
                    irverbose(sprintf('Done run %d/%d; ellapsed %10.1f seconds', i_rep, no_reps, toc(t)));
                end;
            
                parallel_close();
            end;
            
            log = log_fselrepeater();
            log.fea_x = data.fea_x;
            log.xname = data.xname;
            log.xunit = data.xunit;
            log.logs = logs;
        end;
    end;
end
