%> @brief One-Versus-Reference calculation of grades curves
%>
%> Splits dataset using one-versus-reference split (blmisc_split_ovr), then calculates grades curve for each sub-dataset
%> using the FSG provided. Stores result in a log_ovrcurves
classdef ovrcurves < as
    properties
        hierarchy = [];
        %> Index of reference class
        idx_ref = 1;
        %> FSG object to grade the data features
        fsg;
    end;
    
    methods
        function o = ovrcurves()
            o.classtitle = 'One-Versus-Reference grades curves';
            o.flag_ui = 1;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, data)

            temp = data_split_classes(data, o.hierarchy);
            classmap = classlabels2cell(data.classlabels, o.hierarchy);
            ii = 0;
            for i = 1:length(temp)
                if i ~= o.idx_ref
                    ii = ii+1;
                    datasets(ii) = data_merge_rows(temp([o.idx_ref, i])); %#ok<*AGROW>
                    datasets(ii).title = [classmap{i, 3} ' vs. ' classmap{o.idx_ref, 3}];
                end;
            end;
            n = numel(datasets);
            
            da1 = datasets(1);
            out = log_ovrcurves();
            out.title = data.title;
            out.fea_x = da1.fea_x;
            out.xname = da1.xname;
            out.xunit = da1.xunit;
            out.yname = o.fsg.get_description();
            out.gradess = zeros(n, da1.nf);
            for i = 1:n
                fsg_ = o.fsg;
                fsg_.data = datasets(i);
                fsg_ = fsg_.boot();
                out.gradess(i, :) = fsg_.calculate_grades(num2cell(1:data.nf));
                out.legends{i} = datasets(i).title;
            end;
            out.idx_ref = o.idx_ref;
        end;
    end;  
end

