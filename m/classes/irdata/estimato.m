%> @brief Dataset representing estimation
%>
%> These datasets are outputted by a classifier, clssr::use() method
classdef estimato < irdata
    methods
        function o = estimato(o)
            o.classtitle = 'Estimation';
        end;
        
        %> This function expects @c X to represent supports for each class. With the new class labels, it will expand
        %> and reorganize X, with the supports the previously non-existing classes being 0, obviously.
        function o = change_classlabels(o, clnew)
            idxnew = renumber_classes(0:o.nc-1, o.classlabels, clnew)+1;
            X = zeros(o.no, numel(clnew));
            X(:, idxnew) = o.X;
            o.X = X;
            o.fea_x = 1:numel(clnew);
            o.classlabels = clnew;
        end;
        
        %> Copies relevant properties from dataset
        function o = copy_from_data(o, data)
            o.groupcodes = data.groupcodes;
            o.groupnumbers = data.groupnumbers;
        end;
    end;
end
