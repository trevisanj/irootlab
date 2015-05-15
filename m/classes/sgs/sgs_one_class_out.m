%> @brief One-class-out SGS
%>
%> Not published in GUI, currently.
%>
%> @sa sgs
classdef sgs_one_class_out < sgs
    properties
        %> =0. Whether to perform the one-class-out split within each class of @ref hie_split1 separately. Similar to the meaning of the
        %> original @ref sgs::flag_perclass
        flag_split1;
        %> Hierarchical level(s) that will be used to separate the dataset if @ref flag_split1 is 1. Otherwise it is ignored
        hie_split1;
        %> Split level(s).
        hie_split2;
        %> Class labels (because the dataset passed to @ref get_obsidxs() will have different class labels)
        classlabels;
        %> Classes. Must physically/semantically match the rows within the dataset that is passed to @ref get_obs_idxs(). Don't worry, @ref
        %> data_select_hierarchy.m does not reorganize the row order in a dataset.
        classes;
        %> Number of sub-sets per repetition. 2 is the classical train-test. 3 is the train-validate-test. From the second on, there is
        %> going to be only one reserved class, then the rest goes into the first (training) (that's why it is called leave-one-class-out).
        no_bites;
        %> =10. Stands for the "K".
        no_reps = 1;

    end;

    methods(Access=protected)
        %> Overwrittern
        function idxs = get_repidxs(o)
            if ~o.flag_split1
                map = classlabels2cell(o.classlabels, o.hie_split2);
                map = cell2mat(map(:, 4));
%                 uniquemap = unique(map);
                nc = max(map)+1;
                
                nreff = min(o.no_reps, nc);
                if nreff < o.no_reps
                    irwarning(sprintf('Number of repetitions will be %d instead %d', nreff, o.no_reps));
                end;
                
                if o.no_bites > nreff
                    irerror(sprintf('Number of subsets ("bites") too big. Maximum possible is %d', nreff));
                end;
                
                idxsc = cell(nreff, o.no_bites);
                cperm = randperm(nc);
                for i = 1:nreff
                    gone = zeros(1, nc);
                    for j = 1:o.no_bites-1
                        idx = cperm(mod(i+j-2, nc)+1);
                        gone(idx) = 1;
                        idxsc{i, j+1} = idx;
                    end;
                    idxsc{i, 1} = find(gone == 0);
                end;
                
                classeseff = map(o.classes+1);
                idxs_ = classmap2obsmap(idxsc, classeseff);
            else
                % First sees how many sub-problems we have
                map1 = classlabels2cell(o.classlabels, o.hie_split1);
                map1 = cell2mat(map1(:, 4));
                nc1 = max(map1)+1;
                
                map2 = classlabels2cell(o.classlabels, o.hie_split2);
                map2 = cell2mat(map2(:, 4));
                classeseff = map2(o.classes+1);
                
                % Now sees the minimum effective number of repetitions
                nreff = o.no_reps;
                minnc = Inf;
                for h = 1:nc1
                    idxs1 = map1 == h-1;
                    temp = numel(unique(map2(idxs1)));
                    nreff = min(nreff, temp);
                    minnc = min(minnc, temp);
                end;
                
                if nreff < o.no_reps
                    irwarning(sprintf('Number of repetitions will be %d instead %d', nreff, o.no_reps));
                end;
                
                if o.no_bites > minnc
                    irerror(sprintf('Number of subsets ("bites") too big. Maximum possible is %d', nreff));
                end;
                
                idxsc_ = cell(nreff, o.no_bites, nc1);
                
                for h = 1:nc1
                    map2now = map2(map1 == h-1);
                    unique2now = unique(map2now); % Unique class numbers
                    nc2now = numel(unique2now);
                    cperm = randperm(nc2now);
                    for i = 1:nreff
                        gone = zeros(1, nc2now);
                        for j = 1:o.no_bites-1
                            idx0 = cperm(mod(i+j-2, nc2now)+1);
                            gone(idx0) = 1;
                            idxsc_{i, j+1, h} = unique2now(idx0);
                        end;
                        idxsc_{i, 1, h} = unique2now(find(gone == 0));
                    end;
                end;
                
                % contatenates third dimension
                idxsc = cell(nreff, o.no_bites);
                for i = 1:nreff
                    for j = 1:o.no_bites
                        temp = idxsc_(i, j, :);
                        idxsc{i, j} = cell2mat(temp(:));
                    end;
                end;

                classeseff = map2(o.classes+1);
                idxs_ = classmap2obsmap(idxsc, classeseff);
            end;
            
            ni = size(idxs_, 1);
            idxs = cell(1, ni);
            for i = 1:ni
                idxs{i} = idxs_(i, :);
            end;

        end;
        
        
        %> Parameter validation
        function o = do_assert(o)
            if o.flag_group
                irerror('Grouping is not applicable!');
            end;
            if o.flag_perclass
                irerror('flag_perclass is not applicable!');
            end;
            do_assert@sgs(o);
        end;
    end;

    methods
        function o = sgs_one_class_out(o)
            o.classtitle = 'One-class-out SGS';
            o.flag_ui = 0;
        end;
    end;
end