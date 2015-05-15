%> @ingroup guigroup
%> @file
%> @brief Properties Windows for @ref dataio_txt_basic_image
%>
%> Calls uip_dataio_txt_basic.m followed by uip_dataio_txt_dpt.m.
%> Input arguments are expected to be a dataio object only. This is passed to uip_dataio_txt_dpt.m only
%> @cond
function result = uip_dataio_txt_basic_image(varargin)
result.flag_ok = 0;
while 1
    if result.flag_ok
        break;
    end;
    
    r = uip_dataio_txt_basic();
    if ~r.flag_ok
        break;
    end;
    result.params = r.params;
    
    p = uip_dataio_txt_dpt(varargin{:});
    if r.flag_ok
        result.params = [result.params, p.params];
        result.flag_ok = 1;
        break;
    end;
end;
%>@endcond
