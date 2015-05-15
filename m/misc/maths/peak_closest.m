%>@ingroup maths
%>@file
%> @brief Returns index of peak closest to @c a.
%>
%> @sa db_peaks.m
%
%> @param db Data structure obtained from db_peaks.m
%> @param a can be either the index of a wavenumber or the wavenumber itself, because it is easy to distinguish one from the
%> other
%> @return result is an index of an element in db, such as db.names(result), db.centres(result) of db.indexes(result)
function result = peak_closest(db, a)


flag_wn = a > 250;

if flag_wn
    v = db.centres;
else
    v = db.indexes(end:-1:1);
end;

result = 0;
for i = 1:length(v)
    if v(i) < a
        if i == 1
            result = i;
        elseif (a-v(i)) < (v(i-1)-a)
            result = i;
        else
            result = i-1;
        end;
        break;
    end;
end;
if result == 0
    result = length(v);
end;

if ~flag_wn
    result = length(v)+1-result;
end;

