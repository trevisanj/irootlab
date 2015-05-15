%> @brief One-Versus-One dataset split class combination
%>
%> Will result in n*(n-1)/2 datasets. Each dataset will have two classes: the one corresponding to idx_ref and one of the other classes
%>
%> Not published in GUI.
classdef blmisc_split_ovo < blmisc_split
    properties
        hierarchy = [];
    end;
    
    methods
        function o = blmisc_split_ovo()
            o.classtitle = 'One-Versus-One';
            o.flag_ui = 1;
        end;
    end;
    
    methods(Access=protected)
        function datasets = do_use(o, data)

            temp = data_split_classes(data, o.hierarchy);
            n = numel(temp);
            classmap = classlabels2cell(data.classlabels, o.hierarchy); % For the titles
            ii = 0;
            for i = 1:n
                for j = i+1:n
                    ii = ii+1;
                    datasets(ii) = data_merge_rows(temp([i, j]));
                    datasets(ii).title = [classmap{i, 3} ' vs. ' classmap{j, 3}];
                end;
            end;
        end;
    end;  
end

