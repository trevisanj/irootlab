%> LCR2 - Learning Curver Raiser 2 - no variation in NF
%>
%> As opposed to the original LCR, this one does not vary the number of features in the FE stage, but accepts the one that comes with the
%> sostages_cl
%> 
classdef lcr2 < sodesigner
    methods(Access=protected)
        function out = do_design(o)
            item = o.input;
            dia = item.get_modifieddia();
            ds = o.oo.dataloader.get_dataset();
            ds = dia.preprocess(ds);

            if dia.sostage_cl.flag_pairwise
                irwarning('Learning Curve Raiser with pairwise classifier is gonna be slooooooooooow');
            end;
            if dia.sostage_cl.flag_under
                dia.sostage_cl.under_no_reps = 1; % Restricts undersampling to 1
            end;

            
            %=== BlockCube
            flag_parallel = o.oo.cubeprovider.flag_parallel;
            o.oo.cubeprovider.flag_parallel = 0; % Cube provider is not going to go parallel. A parfor exists here inside
            cube = o.oo.cubeprovider.get_cube(ds); % ds is only used for its classlabels
            cube.sgs.flag_perclass = 0;
            cube.block_mold = {dia.get_fecl()};

            %=== Sub-dataset Provider
            sdp = subdatasetprovider();
            sdp.randomseed = 0;
            sdp.subdspercs = o.oo.lcr2_subdspercs;
            sdp.randomseed = 0;

            no_folds = o.oo.lcr2_no_folds;

            if ~flag_parallel
                ipro = progress2_open('LCR2 FOLD', [], 0, no_folds);
                for ifold = 1:no_folds
                    % ###loopbody

                    dss = sdp.get_subdatasets(ds);

                    r0 = sovalues();

                    nds = numel(dss);
                    for i = 1:nds % This is the heavy loop!
                        log = cube.use(dss(i));
                        r0 = r0.read_log_cube(log, i);
                    end;
                    
                    sors(ifold) = r0;
                    
                    % ###loopbody-end
                    
                    ipro = progress2_change(ipro, [], [], i);
                end;
                
                progress2_close(ipro);
            else
                parallel_open();
                try
                    parfor ifold = 1:no_folds
                        % Piece of code to for irverbose() to show the "lab" number
                        ta = getCurrentTask();
                        if ~isempty(ta)
                            verbose_set_sid(['L', int2str(ta.ID)]);
                        end;

                        cube_ = cube;
                        
                        % ###loopbody
                        % I actually had to create "cube_" because MATLAB was getting confused wit
                        
                        dss = sdp.get_subdatasets(ds);

                        r0 = sovalues();

                        nds = numel(dss);
                        for i = 1:nds % This is the heavy loop!
                            cube_.data = dss(i);
                            cube_ = cube_.go();
                            r0 = r0.read_log_cube(cube_, i);
                        end;

                        sors(ifold) = r0;

                        % ###loopbody-end
                    end;
                catch ME
                    parallel_close();
                    rethrow(ME);
                end;
                parallel_close();
            end;

            
            % Merges all sovaluess
            blk = ropr_merge_folds();
            r = blk.use(sors);
            
            r.ax(1).label = 'Dataset percentage (%)';
            r.ax(1).values = o.oo.lcr2_subdspercs;
            
            r.ax(2) = raxisdata_singleton(dia.sostage_cl.title);
            
            out = soitem_sostagechoice();
            out.sovalues = r;
            out.dia = item.get_modifieddia();
        end;
    end;
end
