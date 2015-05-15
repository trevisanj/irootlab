%>@ingroup maths
%> @file
%> @brief Normalization
%>
%> <table>
%>   <tr><td>Direction</td><td>Type</td><td>@c type parameter</td><td>Description</td></tr>
%>   <tr><td>row-wise</td><td>Max</td><td>@c v</td><td>"max" normalization across each row (if present, will be first task).
%>       @c idxs_fea affects only this option</td></tr>
%>   <tr><td>col-wise</td><td>Mean-centering</td><td>@c c</td><td>centers variables</td></tr>
%>   <tr><td>row-wise</td><td>Vector</td><td>@c n</td><td>Normalized to Euclidean norm (\a aka "Vector Normalization")</td></tr>
%>   <tr><td>row-wise</td><td>Area</td><td>@c a</td><td>Normalizes to total area (makes area to be unity)</td></tr>
%>   <tr><td>row-wise</td><td>Amide I</td><td>@c 1</td><td>per-row normalization to Amide I peak</td></tr>
%>   <tr><td>row-wise</td><td>Amide II</td><td>@c 2</td><td>per-row normalization starting at wavenumber 1585 to seach max (Amide II)</td></tr>
%>   <tr><td>col-wise</td><td>Standardization</td><td>@c s</td><td>centers and forces all variable variances to 1 (so-called "standardization")</td></tr>
%>   <tr><td>col-wise</td><td>0-1 range</td><td>@c r</td><td>forces each variable range to [0, 1]</td></tr>
%> </table>
%> <h3>References</g3>
%> [1] Pirouette (Infometrix Inc.) Help Documentation.
%>
%> ﻿[2] Bruker Optik GmbH, OPUS 5 Reference Manual. Ettlingen: Bruker, 2004.
%>
%> ﻿[3] J. G. Kelly et al., “Biospectroscopy to metabolically profile biomolecular structure: a multistage approach linking computational analysis with biomarkers,” J. Proteome Res., vol. 10, no. 4, pp. 1437-1448, Apr. 2011.
%
%> @param X data matrix containing rows as observations, columns as features.
%> @param x x-axis values of the columns of X. unused in most cases, essential for '1' or '2' normalization.
%> @param types see table
%> @param idxs_fea optional idxs_fea for max normalization (@c types = @c 'v'). It is the FULL RANGE, NOT limits
%> @return Normalized X
function X = normaliz(X, x, types, idxs_fea)

[no, nf] = size(X);
if nargin() == 1
    types = '';
end;

flag_var = sum(types == 's') > 0;
flag_center = sum(types == 'c') > 0;
flag_range = sum(types == 'r') > 0;

if flag_var
    if sum(var(X) == 0)
        irerror('Can''t standardize data because there are variables with ZERO variance!');
    end;
end;
    
%> HHH Horizontal normalization
flag_range_max = 0;
flag_area = sum(types == 'a') > 0;
flag_norm2 = sum(types == 'n') > 0;
flag_logit = sum(types == 'l') > 0;
if flag_area
    %> Note: area calculation assumes the x-axis range to be unity, that's why 'a' below is divided by 'nf'
    %> For ex., if all points are '1/nf', the total area will be 'nf'.
    for i = 1:no
        a = sum(X(i, :))/nf;
        X(i, :) = X(i, :)/a;
    end;
    
elseif flag_norm2
    for i = 1:no
        X(i, :) = X(i, :)/norm(X(i, :));
    end;
elseif flag_logit
    X = log(1./(1-X));
else
    [xx, yy] = meshgrid(types, 'v12');
    flag_range_max = sum(sum(xx == yy)) > 0;
    if flag_range_max
        if any(types == 'v') || any(types == 'r')
            if ~exist('idxs_fea', 'var') || isempty(idxs_fea)
                idxs_fea = 1:size(X, 2);
            end;
        elseif sum(types == '1') > 0
            %>***Attention: needs p1 as DATA
            %> amide I peak
            if all(x < 1610) || all (x > 1680)
                irerror('Cannot normalize to Amide I peak; x axis out of Amide I limits!');
            end;
            idxs_fea = v_x2ind(1680, x):v_x2ind(1610, x);
        elseif sum(types == '2') > 0
            %> amide II peak
            if all(x < 1570) || all (x > 1470)
                irerror('Cannot normalize to Amide II peak; x axis out of Amide II limits!');
            end;
            idxs_fea = v_x2ind(1570, x):v_x2ind(1470, x);
        end;
        for i = 1:no
            X(i, :) = X(i, :)/max(X(i, idxs_fea));
        end;
    end;
end;

%> VVV Vertical normalization;
if flag_center || flag_var || flag_range
    means = mean(X, 1); %> vector containing the means for each feature/column
    vars = var(X, 1); %> variances of features/columns of X
    for icol = 1:nf
        colnowcentered = X(:, icol)-means(icol);

        if flag_center
            X(:, icol) = colnowcentered;
        elseif flag_var
            %> forces variance to 1
            X(:, icol) = colnowcentered/sqrt(vars(icol));
        elseif flag_range
            %> forces column range to 1
            mi = min(X(:, icol));
            ma = max(X(:, icol));
            X(:, icol) = (X(:, icol)-mi)/(ma-mi);
        end;
    end;
end;

