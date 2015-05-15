%>@ingroup maths
%>@file
%>@brief Calculates scatter matrices from dataset
%>
%> @sa calculate_scatters.m
%
%> @param data @ref irdata object
%> @param flag_modified_s_b  if 1, S_B will be calculated in an alternative way which is class terms will not be weighet by class sample size, which
%> will cause all classes to have equal importance.
%> @param P penalty matrix to be added to @c S_W
%> @return <em>[S_B, S_W]</em> Respectively "inter-class scatter matrix" and "within-class scatter matrix"
function [S_B, S_W] = data_calculate_scatters(data, flag_modified_s_b, P)

if ~exist('flag_modified_s_b', 'var')
    flag_modified_s_b = 0;
end;

if ~exist('P', 'var')
    P = 0;
end;

[S_B, S_W] = calculate_scatters(data.X, data.classes, flag_modified_s_b, P);
