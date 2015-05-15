%>@ingroup maths
%>@file
%> @brief Calculates sensitivities and specificities for each class (row of cc)
%>
%>
%>@verbatim
%> sens(i) = cc(i, i)/sum(cc(i, :))
%> spec(i) = sum_{j, j ~= i} c(j, j) / sum_{j, j ~= i} sum(cc(j, :))
%>@endverbatim
%
%> @param cc confusion matrix either in HITS, not percentage
%> @param flag_mean if true, the average of all sensitivities and specificities will be returned (this is useful because the
%> cases when sensitivity or specificity is not defined (like rows or columns of cc containing all zeros) 
%> are discounted
%> @return a no_classes X 2 matrix. First column are the sensitivities; second column are the specificities
function values = calc_sens_spec(cc, flag_mean)


if ~exist('flag_mean')
    flag_mean = 0;
end;

no_classes = size(cc, 2);

values = zeros(no_classes, 2);

tr = trace(cc);
no_obs = sum(cc(:));

for i = 1:no_classes
    hits_class = cc(i, i);
    no_obs_class = sum(cc(i, :));
    values(i, 1)  = hits_class/no_obs_class;
    values(i, 2) = (tr-hits_class)/(no_obs-no_obs_class);
end;


if flag_mean
    values = values(:);
    values(isnan(values)) = [];
    values = mean(values(:));
end;
