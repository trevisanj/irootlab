%> @brief Derives from dataio_txt_pir; just sets flag_params to open GUI when opening file
classdef dataio_txt_pir_image < dataio_txt_pir
    methods
        function o = dataio_txt_pir_image()
            o.flag_params = 1;
        end;
    end;
end