%> @brief Estimation Aggregator - Winner takes all
%>
%> For each row, the output will be the output of the dataset that contains the highest confidence degree
classdef esag_wta < esag
    methods
        function o = esag_wta(o)
            o.classtitle = 'Winner-Takes-All';
            o.inputclass = 'irdata';
        end;
    end;
    
    methods(Access=protected)
        %> Abstract
        function out = do_use(o, dd)
            dd = o.apply_threshold(dd);
            
            out = dd(1).copy_emptyrows();
            out = out.copy_from_data(dd(1));

            nf = dd(1).nf;
            X = zeros(dd(1).no, dd(1).nf);
            Xbig = [dd.X]; % Horizontal concatenation
            
            [vv, ii] = max(Xbig, [], 2);
            ii = floor((ii-1)/3)+1; % Determines which dataset contains the maximum for each row
            ii = [(ii-1)*nf+1, ii*nf]; % initial and end position into Xbig for each row
            
            % Unfortunately I don't know how to avoid this loop
            for i = 1:dd(1).no
                X(i, :) = Xbig(i, ii(i, 1):ii(i, 2));
            end;
            
            out.X = X;
        end;
    end;
end