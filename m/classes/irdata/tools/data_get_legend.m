%>@ingroup datasettools
%>@file
%> @brief Returns selected elements from @c data.classlabels according to the classes actually present in data.classes
%> @sa classes2legends.m
function legends = data_get_legend(data)
if data.nc > 0
    legends = classes2legends(data.classes, data.classlabels);
else
    legends = {'(unclassed)'};
end;
