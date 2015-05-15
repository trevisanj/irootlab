%> @brief Paired Vector Comparer base class
%>
%> Compares two vectors. Number of elements must be the same in both vector. This is applied to:
%> @arg comparing two classifiers (see @ref reptt_sgs, which has a @ref reptt_sgs::vectorcomp property)
%> @arg measusing the diversity of two classifiers (example: @ref reptt_xornorm)
%>
%> Depending on the case (i.e., the @ref vectorcomp descendant considered), the vectors must be classification rates or the class predictions
%> themselves. See the descendant classes (i.e., classes vectorcomp_*)
classdef vectorcomp < irobj
    methods(Access=protected)
    	% Abstract
        function z = do_test(o, vv)
            z = 0;
        end;
    end
    methods
        function o = vectorcomp(o)
            o.classtitle = 'Vector Comparer';
            %o.color = [118, 176, 189]/255;
            o.color = [244, 192, 34]/255;

            
        end;
        
        % May return one grade or a vector thereof
        function z = test(o, v1, v2)
            z = o.do_test(v1, v2);
        end;
        
        %> Cross-test of many vectors
        %>
        %> Performs the test with all combinations of the columns of R
        %>
        %> The resulting table should be read as: the row represents the first variable
        %> and the column represents the second variable.
        %>
        %> Examples:
        %> @arg for a 2-sided t-test: H0: mean_row_i - mean_col_j = 0
        %> @arg for a right-tail t-test: H0: mean_row_i - mean_col_j < 0
        %>
        %> @param o
        %> @param R a matrix of shape [v1, v2, v3, v4, ...]
        %> @return a matrix [number of v's]x[number of v's]
        function M = crosstest(o, R)
            nb = size(R, 2);
            
            M = zeros(nb, nb);
            for i = 1:nb
                for j = i+1:nb
                    meas = o.test(R(:, i), R(:, j));

                    if numel(meas) > 1
                        M(i, j) = meas(1);
                        M(j, i) = meas(2);
                    else
                        M(i, j) = meas;
                        M(j, i) = meas;
                    end;
                end;
            end;
        end;
    end;   
end
