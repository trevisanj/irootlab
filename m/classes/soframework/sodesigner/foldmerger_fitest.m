%> Cross-validated Fit-estimate with the individual datasets
classdef foldmerger_fitest < sodesigner
    methods
        %> Gives an opportunity to change somethin inside the item, e.g. activate/desactivate pairwise
        function dia = process_dia(o, dia)
        end;
        
        function o = customize(o)
            o = customize@sodesigner(o);
        end;
    end;
    
    % Bit lower level
    methods(Access=protected)
        function out = do_design(o)
            out = soitem_foldmerger_fitest();

            items = o.input;
            
            dl = o.oo.dataloader;
            no_cv = dl.k; % cross-validation's "k"
            
            [postpr_test, postpr_est] = o.oo.cubeprovider.get_postpr();
            
            for i = 1:no_cv
                dl.cvsplitindex = i;
                dl.ttindex = 1;
                ds_fit = dl.get_dataset();
                if i == 1
                    dstitle = ds_fit.title;
                    logs = o.oo.cubeprovider.ttlogprovider.get_ttlogs(ds_fit);
                    no_logs = numel(logs);
                    for j = 1:no_logs
                        logs{j} = logs{j}.allocate(no_cv);
                    end; 
                end;
                dl.ttindex = 2;
                ds_est = dl.get_dataset();

                
                dia = o.process_dia(items{i}.get_modifieddia());
                out.diaa{i} = dia;
                blk = dia.get_block();
                
                logs = traintest(logs, blk, ds_fit, ds_est, postpr_test, postpr_est);
            end;
                
            out.logs = logs;
            out.items = items;
            out.title = ['Fold merge (', int2str(no_cv), ') for system set-up "', dia.get_s_sequence([], 1), '"'];
            out.dstitle = dstitle;
        end;
    end;
end
