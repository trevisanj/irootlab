%>@ingroup ioio string
%>@file
%>@brief 
%> @brief Determines number of columns and delimiter from a CSV file
%>
%> Delimiter is determined by maximum probability among a list of the most common CSV delimiters
%
%> @param filename
%> @retval [no_cols, deli]
function [no_cols, deli] = get_no_cols_deli(filename)
% Opens for the first time to determine the number of columns
fid = fopen(filename);
if fid == -1
    irerror(sprintf('File not found: %s !', filename));
end;

s = fgets(fid);

% Tries to figure out which is the delimiter being used
delimiters = sprintf(';,\t');
no_delimiters = length(delimiters);
no_colss = zeros(1, no_delimiters);
for i = 1:no_delimiters
    no_colss(i) = sum(s == delimiters(i))+1;
end;    

[no_cols, index] = max(no_colss);
deli = delimiters(index);
fclose(fid);
