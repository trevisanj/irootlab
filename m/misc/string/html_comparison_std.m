%>@ingroup string htmlgen
%>@file
%>@brief Transforms comparison matrix into HTML
%>
%> @sa html_comparison.m, html_confusion.m, html_table_std_colors.m, html_table_std.m
%>
%> @sa html_table_std.m

%> @param M Square matrix or cell. If cell, may contain either numbers of strings
%> @param S Matrix of standard deviations. This one must be a matrix
%> @param labels cell of labels
%> @param B matrix with 2-bit elements: less significant bit: "flag_better"; most significant bit: "statistically significant?"
%> @param cornerstr =''. String to put in the corner
%> @return s A string
function s = html_comparison_std(M, S, labels, B, cornerstr)

if nargin < 4
    B = [];
end;

if nargin < 5
    cornerstr = '';
end;

s = html_table_std(M, S, labels, labels, B, cornerstr);
