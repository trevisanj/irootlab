%> @ingroup guigroup
%> @file
%> @brief Properties Windows for @ref blbl_extract_cv
%>
%> Asks for dataset (blbl_extract_cv::data), and index of reference class (blbl_extract_cv::idx_class_origin.
%>
%> @sa blbl_extract_cv, ask_dataset.m
%>
%> @image html Screenshot-ask_dataset.png
%>
%> @image html Screenshot-uip_blbl_extract_cv_0.png
%
%> @cond
function result = uip_blbl_extract_cv(o, data0)
result.flag_ok = 0;
while 1
    if result.flag_ok
        break;
    end;
    
    r = ask_dataset();
    if ~r.flag_ok
        break;
    end;
    result.params = r.params;
    
    
    while 1
        p = inputdlg(sprintf('Enter index of reference class (0=ignored)'), 'Extract Cluster Vectors', 1, {'0'});
        if isempty(p)
            break;
        end;
        np = eval(p{1});
%         if np < 0 || np > data.nc
        if np < 0
            irerrordlg('Invalid value!');
        else
            result.params = [result.params, 'idx_class_origin', int2str(np)];
            result.flag_ok = 1;
            break;
        end;
    end;
end;
%>@endcond