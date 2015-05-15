%>@ingroup datasettools
%> @file
%> @brief Isolates a particular class, so it will be class 0 and all the other will be class 1
function data = data_isolate_class(data, class)

    score_code = data.classlabels{class+1};
    no_obs = data_get_size(data);

    for i = 1:no_obs
        if data.classes(i) == class
            data.classes(i) = 0;
        else
            data.classes(i) = 1;
        end;
    end;
    data.classlabels = {score_code, 'All other classes'};
end;
