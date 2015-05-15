%> @brief Feature Grades using a @ref fsg object to grade the features
classdef vis_featuregrades < vis
    properties
        %> FSG object to grade the data features
        fsg;
        %> Hint dataset to draw that spectrum in the background
        data_hint;
    end;
    
    methods
        function o = vis_featuregrades(o)
            o.classtitle = 'Feature grades';
            o.inputclass = 'irdata';
            o.flag_params = 1;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, data)
            fsg_ = o.fsg;
            fsg_.data = data;
            fsg_ = fsg_.boot();
            grades = fsg_.calculate_grades(num2cell(1:data.nf));
               
            if ~isempty(o.data_hint)
                xhint = o.data_hint.fea_x;
                yhint = mean(o.data_hint.X);
            else
                xhint = [];
                yhint = [];
            end;
            
            draw_loadings(data.fea_x, grades, xhint, yhint, [], 0, [], 0, 0, 0);
            format_xaxis(data);
            ylabel(fsg_.classtitle);
            set_title(o.classtitle, data);
            make_box();
            out = [];
        end;
    end;
end
