%> @brief Feature Extraction (Fext) base class
%>
%> Feature Extraction has its @ref flag_train_inliers_only set to true.
classdef fext < block
    methods
        function o = fext(o)
            o.classtitle = 'Feature Extraction';
            o.color = [0, 179, 116]/255;
            o.flag_train_inliers_only = 1;
        end;
    end;
end
