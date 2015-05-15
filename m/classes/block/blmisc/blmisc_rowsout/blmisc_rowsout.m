%> @brief Outlier Removal base class
%>
%> There are two possible ways to generate output from the @c use() method:
%> <ol>
%>   <li> @c flag_mark_only = 0. Generates two datasets. The first one contains the inliers and the second one the
%outliers.</li>
%>   <li> @c flag_mark_only = 1. Marks the outliers with class -2.</li>
%> </ol>
%> train() and use() don't need to be called with the same dataset, but
%> the datasets do need to have the same number of rows.
%>
%> block_cascade will skip blmisc_rowsout blocks at <code>use()</code>
%>
classdef blmisc_rowsout < blmisc
    properties(SetAccess=protected)
        map = [];
    end;
    
    properties
        %> =1. Whether to mark outliers class as -2, or else to generate two datasets in the output.
        flag_mark_only = 0;
    end;

    methods(Access=protected)
        function o = do_train(o, data)
            o = o.calculate_map(data);
        end;

        function datasets = do_use(o, data)
            map_out = 1:data.no;
            map_out(o.map) = [];
            if o.flag_mark_only
                datasets = data;
                datasets.classes(map_out) = -2;
                datasets = datasets.eliminate_unused_classlabels();
            else
                datasets = [data.map_rows(o.map), data.map_rows(map_out)];
            end;
        end;
    end;  

    methods
        function o = blmisc_rowsout(o)
            o.classtitle = 'Outlier Removal';
            o.flag_trainable = 1;
            o.flag_fixednf = 0;
            o.flag_fixedno = 1;
        end;

        %> Abstract. This function must assign the @ref map property with the indexes of the <b>inliers</b>.
        function o = calculate_map(o, data)
        end;
    end;
end

