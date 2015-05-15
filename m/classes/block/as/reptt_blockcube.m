%> @brief REpeated Train-Test - Block Cube
%>
%> If @ref sgs is passes, it is used to guide splitting the dataset. Otherwise, it will be expected that the
%> reptt_sgs::data property has at least two elements (the first will be used for training and the other for test).
classdef reptt_blockcube < reptt
    properties
        %> SGS. If not supplied, the @ref data property will be expected to
        %> have at least two elements. Another option is to use obsidxs
        %> instead
        sgs;
        
        %> Alternative to SGS
        obsidxs;
        
        %> =0. Whether to run in parallel mode!
        flag_parallel = 0;
    end;
    
    properties(SetAccess=protected)
        no_datasets;
    end;
    
    methods
        function o = reptt_blockcube()
            o.classtitle = 'Block Cube';
            o.flag_ui = 1;
            o.flag_multiin = 1;
        end;
    end;
    
    methods(Access=protected)
        %> Goes somewhere
        function log = do_use(o, data)
            log = log_cube();
            o = o.boot_postpr(); % from reptt

            flag_obsidxs = 1;
            if ~isempty(o.sgs)
                obsidxs_ = o.sgs.get_obsidxs(data);
                nds = size(obsidxs_, 1);
            elseif ~isempty(o.obsidxs)
                obsidxs_ = o.obsidxs;
                nds = size(obsidxs_, 1);
            else
                nds = 1;
                flag_obsidxs = 0;
                if numel(data) < 2
                    irerror('reptt_blockcube needs 2 input datasets (train, use) when sgs and obsidxs are both empty!');
                end;
            end;
%             o.no_datasets = nds;

            log = log.allocate_logs(o.log_mold, o.block_mold, nds);
            
            [ni, nj, nk, nl] = size(log.logs);
            ntotal = nds*ni*nj*nk;

            log.blocks = cell(ni, nj, nk);
            
            if ~o.flag_parallel
            
                %---
                %--- Serial version
                %---

                ipro = progress2_open('REPTT_BLOCKCUBE', [], 0, ntotal);
                ids_save = -1;
                for i = 1:ntotal
                    % base decomposition of i
                    ik = mod(i-1, nk)+1;
                    inext = floor((i-1)/nk)+1;
                    ij = mod(inext-1, nj)+1;
                    inext = floor((inext-1)/nj)+1;
                    ii = mod(inext-1, ni)+1;
                    inext = floor((inext-1)/ni)+1;
                    ids = mod(inext-1, nds)+1;

                    if flag_obsidxs
                        if ids ~= ids_save
                            datasets = data.split_map(obsidxs_(ids, :));
                            ids_save = ids;
                        end;

                    else
                        datasets = data;
                    end;
                    
                    if ~isempty(o.block_mold{ii, ij, ik})

                        bl = o.block_mold{ii, ij, ik}.boot();
                        bl = bl.train(datasets(1));
                        est = bl.use(datasets(2));

                        if ~isempty(o.postpr_est)
                            est = o.postpr_est.use(est);
                        end;

                        if ~isempty(o.postpr_test)
                            ds_test = o.postpr_test.use(datasets(2));
                        else
                            ds_test = datasets(2);
                        end;

                        pars = struct('est', {est}, 'ds_test', {ds_test}, 'clssr', {bl});
                        for il = 1:nl
                            log.logs{ii, ij, ik, il} = log.logs{ii, ij, ik, il}.record(pars);
                        end;
                        log.blocks{ii, ij, ik, ids} = bl; % records the trained block
                    else
                    end;


                    ipro = progress2_change(ipro, [], [], i);
                end;
                progress2_close(ipro);

            else
                %|||
                %||| Parallel version
                %|||
                
                nijk = ni*nj*nk;

                v_logs = cell(1, nijk); %, nl);
                
                parallel_open();
                
                parfor i = 1:nijk
                    och = o; %#ok<NASGU>
                    
                    % base decomposition of i
                    ik = mod(i-1, nk)+1;
                    inext = floor((i-1)/nk)+1;
                    ij = mod(inext-1, nj)+1;
                    inext = floor((inext-1)/nj)+1;
                    ii = mod(inext-1, ni)+1;

                    for ids = 1:nds
                        if flag_obsidxs
                            datasets = data.split_map(obsidxs_(ids, :)); %#ok<PFBNS>
                        else
                            datasets = o_data;
                        end;

                        if ~isempty(o.block_mold{ii, ij, ik})
                        
                            bl = o.block_mold{ii, ij, ik}.boot();
                            bl = bl.train(datasets(1));
                            est = bl.use(datasets(2));

                            if ~isempty(o.postpr_est)
                                est = o.postpr_est.use(est);
                            end;

                            if ~isempty(o.postpr_test)
                                ds_test = o.postpr_test.use(datasets(2));
                            else
                                ds_test = datasets(2);
                            end;

                            pars = struct('est', {est}, 'ds_test', {ds_test}, 'clssr', {bl});
                            for il = 1:nl
                                if ids == 1
                                    v_logs{i}{il} = log.logs{ii, ij, ik, il}; %#ok<PFBNS>
                                end;
                                v_logs{i}{il} = v_logs{i}{il}.record(pars);
                            end;
                            v_blocks{i}{ids} = bl;
                        end;
                    end;
                end;
                
                parallel_close();
                                
                for i = 1:nijk
                    % base decomposition of i
                    ik = mod(i-1, nk)+1;
                    inext = floor((i-1)/nk)+1;
                    ij = mod(inext-1, nj)+1;
                    inext = floor((inext-1)/nj)+1;
                    ii = mod(inext-1, ni)+1;
                                    
                    for il = 1:nl
                        log.logs{ii, ij, ik, il} = v_logs{i}{il};
                    end;
                    for ids = 1:nds
                        log.blocks{ii, ij, ik, ids} = v_blocks{i}{ids}; % records the trained block
                    end;
                end;
            end;
        end;
    end;
end
                
