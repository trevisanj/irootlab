%> @file
%> @ingroup misc
%> @brief Assigns several fields to structure or object.
%
%> @param params Cell followint the pattern @verbatim {'property1', value1, 'property2', value2, ...} @endverbatim
function o = setbatch(o, params)
for i = 1:length(params)/2
    varname = params{i*2-1};
    value = params{i*2};
    o.(varname) = value;
end;

