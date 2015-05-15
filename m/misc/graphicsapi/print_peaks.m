%>@ingroup graphicsapi
%>@file
%> @brief disp()'s a peak report.
%
%> @param x
%> @param idxs_peaks
function print_peaks(x, idxs_peaks)
db = peak_db(x);
for i = 1:length(idxs_peaks)
    ic = peak_closest(db, idxs_peaks(i));
    s = db.names{ic};
    fprintf('%g (%g waves/cm) - %s\n', idxs_peaks(i), x(idxs_peaks(i)), s);
end;
