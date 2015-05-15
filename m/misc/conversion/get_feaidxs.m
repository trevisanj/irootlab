%> @ingroup conversion
%> @file
%> @brief Returns indexes for manual feature selection
%>
%> Implements several ways of converting a list of features specificication
%> into the actual feature indexes
%>
%> <h3>Examples:</h3>
%> @code
%> % for v_type = 'x'
%> v = [1800, 1474; 1432, 1401; 1313, 1176; 1134, 900];
%>
%> % for type = 'i'
%> v = [1 86;97 105;128 163;174 235];
%> @endcode
%
%> @param x Feature x-axis, such as @ref irdata::fea_x
%> @param v Contains ranges or an index list (see v_type below) to include, 1 in each row.
%> @param v_type
%> @arg @c 'rx' if v is expressed in the same unit as data vars x
%> @arg @c 'ri' if v contains index ranges
%> @arg @c 'i' if v contains feature indexes
%> @param flag_complement If 1, will exclude the specified variables
%> @return indexes Vector of feature indexes
function indexes = get_feaidxs(x, v, v_type, flag_complement)

if ~exist('v_type', 'var')
    v_type = 'x';
end;

if ~exist('flag_complement', 'var')
    flag_complement = 0;
end;



nf = length(x);

if v_type == 'i'
    indexes = v;
elseif v_type == 'x'
    indexes = v_x2ind(v, x);
else
    if v_type == 'rx'
        ranges = v_x2ind(v, x);
    elseif v_type == 'ri'
        ranges = v;
    end;

    indexes = [];
    for i = 1:size(ranges, 1)
        indexes = [indexes  ranges(i, 1):ranges(i, 2)];
    end;   
end;

if flag_complement
    temp = 1:nf;
    temp(indexes) = [];
    indexes = temp;
end;
