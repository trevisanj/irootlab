%> @brief Derives from dataio_txt_basic to match uip_dataio_txt_basic.m
classdef dataio_txt_basic_image < dataio_txt_basic
    methods
        function o = dataio_txt_basic_image()
            o.flag_params = 1;
        end;
    end;
end