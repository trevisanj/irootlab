%> @ingroup conversion string
%> @file
%> @brief Converts integer to ordinal number string
%>
%> @param idx Integer number
%> @return out String like '1st', '411th' etc
function out = int2ord(idx)

mo10 = mod(idx, 10);
mo100 = mod(idx, 100);
if mo10 == 1 && ~(mo100 == 11)
    s = 'st';
elseif mo10 == 2 && ~(mo100 == 12)
    s = 'nd';
elseif mo10 == 3 && ~(mo100 == 13)
    s = 'rd';
else
    s = 'th';
end;

out = sprintf('%d%s', idx, s);