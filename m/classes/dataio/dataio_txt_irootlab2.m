%> @brief IRootLab TXT that saves classes column as labels, not numbers
classdef dataio_txt_irootlab2 < dataio_txt_irootlab
    methods
        function o = dataio_txt_irootlab2()
            o.flag_stringclasses = 1;
        end;
    end
end
