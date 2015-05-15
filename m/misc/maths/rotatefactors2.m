%>@ingroup maths
%>@file
%>@brief Reproduces the factor rotation of Pirouette
%>
%> <h3>References</h3>
%> Pirouette (Informetrix Inc.) Help Documentation.
%
%> @param L
%> @param flag_normal
%> @param L
function L = rotatefactors2(L, flag_normal)

if ~exist('flag_normal')
    flag_normal = 0;
end;

s = 'None';
if flag_normal
    % Communality as defined in 5.39 of Pirouette.pdf (Pirouette User
    % Guide). There is one communality measure for each row of the loadings
    % matrix (i.e., each of the original features/wavenumbers).
    h = sqrt(sum(L.^2, 2));

    for i = 1:size(L, 1)
%         if h(i) ~= 0
            L(i, :) = L(i, :)/(h(i)+realmin);
%         end;
    end;
    
    s = 'Normal';
end;

L = rotatefactors(L, 'normalize', 'off');

if flag_normal
    for i = 1:size(L, 1)
        L(i, :) = L(i, :)*h(i);
    end;
end;

disp(sprintf('INFO: Loadings were rotated (pre-processing: ''%s'').', s));
