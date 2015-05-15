%> @brief Class-Hierarchical Training Data Split
%>
%> Creates one classifier per class when taking the @c hie_split class hierarchical levels into account for splitting
%> the training dataset.
%>
%> Every time @c train() is called, new classifiers are added maintaining existing ones.
%>
%> @todo think about the future of this class, it cannot be trained like the others! The problem is that the classes in
%> dataset passed for training are not the classes classified by the classifier
%>
classdef aggr_hiesplit < aggr
    properties
        %> must contain a block object that will be replicated as needed
        block_mold = [];
    end;

    methods
        function o = aggr_hiesplit()
            o.classtitle = 'Class-Hierarchical Training Data Split';
        end;
    end;
    
    methods(Access=protected)
        %> Adds one classifier per class considering the-the-the-the. Existing classifiers remain
        function o = do_train(o, data)
            labels_temp = {};
            
            pieces = data.split_splitidxs();
            nump = numel(pieces);
            
            k = numel(o.blocks);
            
            ipro = progress2_open('AGGR_HIESPLIT', [], 0, nump);
            for i = 1:nump
                d = pieces(i);
                labels_temp = unique([labels_temp, d.classlabels]); % collects class labels - here providing for idfferent splits not having the same class labels

                cl = o.block_mold.boot();
                cl = cl.train(d);
                cl.title = ['Model ', int2str(i)];
                k = k+1;
                o.blocks(k).block = cl;
                o.blocks(k).classlabels = d.classlabels;
                
                ipro = progress2_change(ipro, [], [], i);
            end;
            progress2_close(ipro);
            
            o.classlabels = labels_temp;
        end;
    end;
end