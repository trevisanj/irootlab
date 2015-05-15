%> @brief Pairwise classifier
%>
%> Creates one classifier per 2-class combination of the training dataset. For example, if the dataset has 4 classes, 6
%> classifiers will be created, each one trained respectively on a 2-class sub-dataset: classes [0, 1]; [0, 2]; [0, 3]; [1, 2]; [1, 3]; [2, 3]
%>
%> @sa uip_aggr_pairs.m
classdef aggr_pairs < aggr
    properties
        % must contain a block object that will be replicated as needed
        block_mold = [];
    end;

    methods
        function o = aggr_pairs()
            o.classtitle = 'One-versus-one';
            o.short = 'OVO';
        end;

    end;
    
    methods(Access=protected)
        function o = do_boot(o)
            o = do_boot@aggr(o);
        end;

        % Adds classifiers when new classes are presented
        function o = do_train(o, data)
            nc = data.nc;
            nb = length(o.blocks);

            ntotal = nc*(nc-1)/2; % Total number of models that will be created
            pieces = data_split_classes(data); % Por enquanto assim, mas dava pra tentar um split unico
            o.time_train = 0;
            for i1 = 1:nc-1
                for i2 = i1+1:nc

                    % Finds classifier that is assigned to classes corresponding to (i1, i2)
                    cl_data = {pieces(i1).classlabels{1}, pieces(i2).classlabels{1}}; % I am not relying on the pieces being in the same order of data.classlabelslabels
                    ifound = 0;
                    for ib = 1:nb
                        if sum(strcmp(cl_data, o.blocks(ib).classlabels)) == 2
                            ifound = ib;
                        end;
                    end;

                    if ifound == 0
                        % Pair of classes (i1, i2) has not been seen so far, so creates new classifier
                        o.blocks(nb+1).block = o.block_mold.boot();
                        o.blocks(nb+1).classlabels = cl_data;
                        o.classlabels = unique([o.classlabels, cl_data]);
                        ifound = nb+1;
                        nb = nb+1;
                    end;


%                     irverbose(sprintf('agg_pairs::train(): training model %d/%d...\n', ifound, ntotal), 0);
                    o.blocks(ifound).block = o.blocks(ifound).block.train(data_merge_rows(pieces([i1, i2])));
                    o.time_train = o.time_train+o.blocks(ifound).block.time_train;
                end;
            end;    
        end;
    end;
end