%> Tests committees of classifiers
%>
%> @arg Sorts the diagnosissystems based on their (already) recorded performance
%> @arg Creates a sequence of diagnosissystems 

classdef committees < sodesigner
    methods(Access=protected)
        function out = do_design(o)
            items = o.input{1}.items;
            
            ni = numel(items);
            
            % Makes single stripe of values
            for i = 1:ni
                sov = items(i).sovalues;
            
                if i == 1
                    values = sov.values;
                else
                    values = [values; sov.values];
                end;
            end;
            
            % Sorts values in descending order
            rates = mean(sovalues.getYY(values, 'rates'), 3);
            [sortedrates, sortedidxs] = sort(rates, 'descend');
            values = values(sortedidxs);
            
            % Trims to maximum number of committee elements
            nv = size(values, 1);
            values = values(1:ceil(nv*o.oo.committees_maxperc), :);
            nv = size(values, 1);
            
            % Builds matrix of blocks
            no_folds = numel(values(1).diaa);
            blks = cell(nv, no_folds);
            for i = 1:nv
                for j = 1:no_folds
                    dia = o.process_dia(values(i, 1).diaa{j});
                    blks{i, j} = dia.get_block();
                end;
            end;
            
            % Builds matrix of aggr
            aggs = aggr_mold.empty();
            for i = 1:nv
                for j = 1:no_folds
                    agg = aggr_mold();
                    temp = blks(1:i, j);
                    agg.block_mold = temp(:)'; % Makes a row vector
                    aggs(i, j) = agg;
                    diaa{j} = diagnosissystem();
                    diaa{j}.blk_cl = agg;
                end;
                
                % Also prepares output stuff
                outtitles{i, 1} = sprintf('Committee of %d system%s', i, iif(i == 1, '', 's'));
                outspecs{i, 1} = outtitles{i, 1};
                outdiaaa{i, 1} = diaa;
            end;
            
            
            % Loads datasets
            dl = o.oo.dataloader;
            dss = irdata.empty();
            for j = 1:no_folds
                dl.cvsplitindex = j;
                dl.ttindex = 1;
                dss(j, 1) = dl.get_dataset(); % Fit data
                dl.ttindex = 2;
                dss(j, 2) = dl.get_dataset(); % Test data
            end;
            
            
            % Evaluation
            [postpr_test, postpr_est] = o.oo.cubeprovider.get_postpr();
            ipro = progress2_open('COMMITTEES', [], 0, nv*no_folds);
            ii = 0;
            for i = 1:nv
                % Prepares logs
                logs = o.oo.cubeprovider.ttlogprovider.get_ttlogs(dss(1));
                no_logs = numel(logs);
                for k = 1:no_logs
                    logs{k} = logs{k}.allocate(no_folds);
                end; 
                
                for j = 1:no_folds
                    blk = aggs(i, j);
                    logs = traintest(logs, blk, dss(j, 1), dss(j, 2), postpr_test, postpr_est);
                    ii = ii+1;
                    ipro = progress2_change(ipro, [], [], ii);
                end;
                
                outvalues(i, 1) = sovalues.read_logs(logs);
            end;
            progress2_close(ipro);
            
            r = sovalues();
            r.chooser = o.oo.diacomp_chooser;
            r.values = outvalues;
            r = r.set_field('title', outtitles);
            r = r.set_field('spec', outspecs);
            r = r.set_field('diaa', outdiaaa);
            
            r.ax(1) = raxisdata();
            r.ax(1).label = 'Number of members';
            r.ax(1).values = 1:ni;
            r.ax(1).legends = outtitles;

            r.ax(2) = raxisdata_singleton();

            out = soitem_diachoice();
            out.sovalues = r;
            out.title = ['Committees - 1 to ', int2str(nv)];
            out.dstitle = dss(1).title; % Kindda random
        end;
    end;
end
