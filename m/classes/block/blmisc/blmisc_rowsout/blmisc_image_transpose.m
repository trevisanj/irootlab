%> @brief Switches direction between 'hor' or 'ver'
classdef blmisc_image_transpose < blmisc_image
    methods
        function o = blmisc_image_transpose(o)
            o.classtitle = 'Transpose';
            o.flag_ui = 1;
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)
            data = data.transpose2();
        end;
    end;  

end

